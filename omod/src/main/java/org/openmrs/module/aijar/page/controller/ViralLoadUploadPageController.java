package org.openmrs.module.aijar.page.controller;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.openmrs.*;
import org.openmrs.api.context.Context;
import org.openmrs.parameter.EncounterSearchCriteria;
import org.openmrs.ui.framework.UiUtils;
import org.openmrs.ui.framework.annotation.SpringBean;
import org.openmrs.ui.framework.page.PageModel;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;

import static org.openmrs.module.aijar.AijarConstants.*;

public class ViralLoadUploadPageController {
    protected final Log log = LogFactory.getLog(this.getClass());

    private List<String> noEncounterFound = new ArrayList<>();

    private List<String> noPatientFound = new ArrayList<>();

    private List<String> patientResultNotReleased = new ArrayList<>();

    public void get(@SpringBean PageModel pageModel, @RequestParam(value = "breadcrumbOverride", required = false) String breadcrumbOverride) {
        pageModel.put("breadcrumbOverride", breadcrumbOverride);
        pageModel.put("noEncounterFound", this.noEncounterFound);
        pageModel.put("noPatientFound", this.noPatientFound);
        pageModel.put("patientResultNotReleased", this.patientResultNotReleased);

    }

    public void post(@SpringBean PageModel pageModel, UiUtils ui, @RequestParam(value = "breadcrumbOverride", required = false) String breadcrumbOverride, @RequestParam(value = "returnUrl", required = false) String returnUrl, @RequestParam(value = "file", required = false) MultipartFile file) {

        readCSVFile(file);
        pageModel.put("breadcrumbOverride", breadcrumbOverride);
        pageModel.put("noEncounterFound", this.noEncounterFound);
        pageModel.put("noPatientFound", this.noPatientFound);
        pageModel.put("patientResultNotReleased", this.patientResultNotReleased);
    }

    public void readCSVFile(MultipartFile csvFile) {

        List<Patient> noEncounterFound = new ArrayList<>();
        List<String> noPatientFound = new ArrayList<>();
        List<Patient> patientResultNotReleased = new ArrayList<>();
        String cvsSplitBy = ",";
        InputStream is = null;
        try {
            is = csvFile.getInputStream();
        } catch (IOException e) {
            e.printStackTrace();
        }

        try (BufferedReader br = new BufferedReader(new InputStreamReader(is))) {
            Object[] objects = br.lines().toArray();
            Collection<EncounterType> encounterTypes = getEcounterTypes("8d5b2be0-c2cc-11de-8d13-0010c6dffd0f");

            for (int i = 0; i < objects.length; i++) {
                // use comma as separator
                String[] vlResult = objects[i].toString().split(cvsSplitBy);


                //When on headers of the CSV File
                if (vlResult[VL_DATE_COLLECTION_CELL_NO].contentEquals("date_collected")) continue;

                String vlDate = vlResult[VL_DATE_COLLECTION_CELL_NO].replaceAll("\"", "");
                String patientARTNo = vlResult[VL_PATIENT_ART_ID_CELL_NO].replaceAll("\"", "");
                String vlQuantitative = vlResult[VL_RESULTS_NUMERIC_CELL_NO].replaceAll("\"", "");
                String vlQualitative = vlResult[VL_RESULTS_ALHPA_NUMERIC_CELL_NO].replaceAll("\"", "");
                String vlReleaseDate = vlResult[VL_RELEASED_CELL_NO].replaceAll("\"", "");
                String dateFormat = getDateFormat(vlDate);


                EncounterSearchCriteria encounterSearchCriteria = new EncounterSearchCriteria(getPatientByPatientId(patientARTNo), null, convertStringToDate(vlDate, "00:00:00", dateFormat), convertStringToDate(vlDate, "23:59:59", dateFormat), null, null, encounterTypes, null, null, null, false);
                List<Encounter> encounters = new ArrayList<>();

                //Determine if patient is found

                if (encounterSearchCriteria.getPatient() != null) {
                    // Determine if results were released
                    if (vlReleaseDate.contains("NULL")) {
                        this.patientResultNotReleased.add(vlResult[VL_PATIENT_ART_ID_CELL_NO]);
                        continue;
                    }


                    encounters = Context.getEncounterService().getEncounters(encounterSearchCriteria);

                    if (encounters.size() > 0) {
                        try {
                            addVLToEncounter(vlQualitative, vlQuantitative, vlDate, encounters.get(0));
                        } catch (ArrayIndexOutOfBoundsException e) {
                            log.error(e);
                        }
                    } else {
                        this.noEncounterFound.add(vlResult[VL_PATIENT_ART_ID_CELL_NO]);
                    }
                } else {
                    this.noPatientFound.add(vlResult[VL_PATIENT_ART_ID_CELL_NO]);
                }
            }

        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    private Encounter addVLToEncounter(String qualitativeVl, String quantitativeVl, String vlDate, Encounter encounter) {

        Concept dateSampleTaken = Context.getConceptService().getConcept("163023");
        Concept viralLoadQualitative = Context.getConceptService().getConcept("1305");
        Concept viralLoadQuantitative = Context.getConceptService().getConcept("856");
        Concept valueCoded = null;

        String dateFormat = getDateFormat(vlDate);

        String vlQualitativeString = qualitativeVl.replaceAll("\"", "");

        if (vlQualitativeString.contains("Target Not Detected") || vlQualitativeString.contains("Not detected")) {
            valueCoded = Context.getConceptService().getConcept("1306");
        } else if (vlQualitativeString.contains("FAILED")) {
            valueCoded = Context.getConceptService().getConcept("1304");
        } else {
            valueCoded = Context.getConceptService().getConcept("1301");
        }

        Obs obs = createObs(encounter, dateSampleTaken, null, convertStringToDate(vlDate, "00:00:00", dateFormat), null);
        Obs obs1 = createObs(encounter, viralLoadQualitative, valueCoded, null, null);
        Obs obs2 = createObs(encounter, viralLoadQuantitative, null, null, Double.valueOf(quantitativeVl));

        //Void Similar observation
        voidObsFound(encounter, dateSampleTaken);
        voidObsFound(encounter, viralLoadQualitative);
        voidObsFound(encounter, viralLoadQuantitative);

        encounter.addObs(obs);
        encounter.addObs(obs1);
        encounter.addObs(obs2);

        return Context.getEncounterService().saveEncounter(encounter);

    }


    private String getDateFormat(String date) {
        String dateFormat = "";
        if (date.contains("-")) {
            dateFormat = "yyyy-MM-dd";
        } else if (date.contains("/")) {
            dateFormat = "dd/MM/yyyy";
        }
        return dateFormat;
    }


    private void voidObsFound(Encounter encounter, Concept concept) {
        List<Obs> obsList = Context.getObsService().getObservationsByPersonAndConcept(encounter.getPatient(), concept);
        for (Obs obs1 : obsList) {
            if (obs1.getEncounter() == encounter) {
                obs1.setVoided(true);
                obs1.setDateVoided(new Date());
                obs1.setVoidedBy(encounter.getCreator());
                obs1.setVoidReason("Replaced with a new one because it was changed");
                Context.getObsService().saveObs(obs1, "Obs Voided");
            }
        }
    }


    private Obs createObs(Encounter encounter, Concept concept, Concept valueCoded, Date valueDatetime, Double valueNumeric) {
        Obs newObs = new Obs();
        newObs.setConcept(concept);
        newObs.setValueCoded(valueCoded);
        newObs.setValueNumeric(valueNumeric);
        newObs.setValueDatetime(valueDatetime);
        newObs.setCreator(encounter.getCreator());
        newObs.setDateCreated(encounter.getDateCreated());
        newObs.setEncounter(encounter);
        newObs.setPerson(encounter.getPatient());
        return newObs;
    }

    private Collection<EncounterType> getEcounterTypes(String encounterTypesUUID) {
        Collection<EncounterType> encounterTypes = new ArrayList<>();
        encounterTypes.add(Context.getEncounterService().getEncounterTypeByUuid(encounterTypesUUID));
        return encounterTypes;
    }

    private Patient getPatientByPatientId(String patientId) {
        try {
            return Context.getPatientService().getPatientIdentifiers(patientId, null, null, null, null).get(0).getPatient();
        } catch (Exception e) {
            return null;
        }
    }


    private boolean validateFacility(String facilityDHIS2UUID) {
        String globalProperty = Context.getAdministrationService().getGlobalProperty(GP_DHIS2);
        return facilityDHIS2UUID.contentEquals(globalProperty);
    }

    private Date convertStringToDate(String string, String time, String dateFormat) {
        DateFormat format = new SimpleDateFormat(dateFormat, Locale.ENGLISH);
        Date date = null;

        try {
            date = format.parse(string);
            if (date != null && time != "") {
                date = dateFormtter(date, time);
            }
        } catch (ParseException e) {
            e.printStackTrace();
        }

        return date;
    }

    public Date dateFormtter(Date date, String time) throws ParseException {
        SimpleDateFormat formatter = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");

        SimpleDateFormat formatterExt = new SimpleDateFormat("dd/MM/yyyy");

        String formattedDate = formatterExt.format(date) + " " + time;

        return formatter.parse(formattedDate);
    }
}
