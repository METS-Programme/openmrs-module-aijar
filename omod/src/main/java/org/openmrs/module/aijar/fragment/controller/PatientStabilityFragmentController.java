package org.openmrs.module.aijar.fragment.controller;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.openmrs.*;
import org.openmrs.api.ConceptService;
import org.openmrs.api.ObsService;
import org.openmrs.api.PatientService;
import org.openmrs.api.context.Context;
import org.openmrs.ui.framework.UiUtils;
import org.openmrs.ui.framework.fragment.FragmentModel;
import org.springframework.web.bind.annotation.RequestParam;

import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;

public class PatientStabilityFragmentController {

    private static final Log log = LogFactory.getLog(PatientStabilityFragmentController.class);

    public void controller(FragmentModel model, @RequestParam(value = "patientId", required = false) Patient patient, @RequestParam(value = "visitId", required = false) Visit visit, @RequestParam(value = "encounterId", required = false) Encounter encounter, UiUtils ui) throws ParseException {
        Integer baselineRegimenConceptId = 99061;
        Integer currentRegimenConceptId = 90315;
        ObsService obsService = Context.getObsService();
        ConceptService conceptService = Context.getConceptService();
        PatientService patientService = Context.getPatientService();

        Visit encounterVisit = new Visit();
        if (visit == null && encounter != null) {
            encounterVisit = encounter.getVisit();
        } else if (visit != null) {
            encounterVisit = visit;
        }


        /**
         * Last Viral Load
         */
        List<Obs> vlDateObsList = getObsListFromIdList("SELECT obs_id FROM obs where  obs.value_datetime BETWEEN '" + getDateBefore(encounterVisit.getStartDatetime(), 0, -1) + "' AND '" + encounterVisit.getStartDatetime() + "' AND obs.person_id='" + patient.getPatientId() + "' AND obs.concept_id = 163023 AND obs.voided = false  ORDER BY  obs.encounter_id DESC");

        if (vlDateObsList.size() > 0) {
            List<Obs> vlObsList = getObsListFromIdList("SELECT obs_id FROM obs where obs.person_id='" + patient.getPatientId() + "' AND obs.concept_id = 856 AND encounter_id='" + vlDateObsList.get(0).getEncounter().getEncounterId() + "' AND obs.voided = false  ORDER BY  obs.encounter_id DESC");

            if (vlObsList.size() > 0) {
                model.addAttribute("vlObs", vlObsList.get(0));
                model.addAttribute("vlDateObs", vlDateObsList.get(0));
            } else {
                model.addAttribute("vlObs", null);
                model.addAttribute("vlDateObs", null);
            }
        } else {
            model.addAttribute("vlDateObs", null);
            model.addAttribute("vlObs", null);
        }


        List<Concept> currentRegimentConcept = new ArrayList<>();
        currentRegimentConcept.add(Context.getConceptService().getConcept(90315));
        List<Person> personList = new ArrayList<>();
        personList.add(patient.getPerson());

        PatientSummaryFragmentController patientSummaryFragmentController = new PatientSummaryFragmentController();

        /**
         * Current regimen
         */

        int monthOffSet = -12;
        Date date = null;


        Obs obs = patientSummaryFragmentController.getMostRecentObservation(obsService, personList, currentRegimentConcept);

        String query = "";
        String queryCurrentRegimen = "";
        List<Obs> regimenObsList = new ArrayList<>();
        List<Obs> currentRegimenList = new ArrayList<>();

        //Check if Obs of Regimen is on not Null
        if (obs != null) {
            //Check if Obs conceptId is the same as the art encounter regimen concept
            // Check if regimen is a DTG regimen
            if (checkIfDTG(obs)) {
                query = "SELECT obs_id FROM obs where  obs.obs_datetime <= DATE('" + encounterVisit.getStartDatetime() + "') AND obs.person_id='" + patient.getPatientId() + "' AND concept_id= 90315 AND obs.voided = false ORDER BY  obs.obs_datetime DESC";
            } else {
                query = "SELECT obs_id FROM obs where  obs.obs_datetime <= DATE('" + getDateBefore(encounterVisit.getStartDatetime(), monthOffSet, 0) + "') AND obs.person_id='" + patient.getPatientId() + "' AND obs.value_coded = " + obs.getValueCoded().getConceptId() + " AND obs.voided = false ORDER BY  obs.encounter_id ASC";
            }
            regimenObsList = getObsListFromIdList(query);

            queryCurrentRegimen = "SELECT obs_id FROM obs where  obs.person_id='" + patient.getPatientId() + "' AND obs.value_coded = " + obs.getValueCoded().getConceptId() + " AND obs.voided = false ORDER BY  obs.encounter_id ASC";

            currentRegimenList = getObsListFromIdList(queryCurrentRegimen);
        }


        if (regimenObsList.size() > 0) {
            if ("164976,164977,164978,164979".contains(regimenObsList.get(0).getValueCoded().getConceptId().toString()) && regimenObsList.size() > 1) {
                List<Obs> regimenBeforeDTGObs = getObsListFromIdList("SELECT obs_id FROM obs where  obs.obs_datetime <= DATE('" + getDateBefore(encounterVisit.getStartDatetime(), -12, 0) + "') AND obs.person_id='" + patient.getPatientId() + "' AND obs.value_coded = " + regimenObsList.get(1).getValueCoded().getConceptId() + " AND obs.voided = false ORDER BY  obs.encounter_id ASC");
                if (regimenBeforeDTGObs.size() > 0) {
                    model.addAttribute("regimenBeforeDTGObs", regimenBeforeDTGObs.get(0));
                } else {
                    model.addAttribute("regimenBeforeDTGObs", "");
                }
            } else {
                model.addAttribute("regimenBeforeDTGObs", "");
            }
            model.addAttribute("regimenObs", regimenObsList.get(0));
        } else {
            model.addAttribute("regimenObs", null);
            model.addAttribute("regimenBeforeDTGObs", "");
        }

        if (currentRegimenList.size() > 0) {
            model.addAttribute("currentRegimenObs", currentRegimenList.get(0));
        } else {
            model.addAttribute("currentRegimenObs", null);
        }
        model.addAttribute("baselineRegimenConceptId", baselineRegimenConceptId);

        /**
         * Adherence
         */
        List<Obs> adherenceObsList = getObsListFromIdList("SELECT obs_id FROM obs where  obs.obs_datetime BETWEEN '" + getDateBefore(encounterVisit.getStartDatetime(), -6, 0) + "' AND '" + encounterVisit.getStartDatetime() + "' AND obs.person_id='" + patient.getPatientId() + "' AND obs.concept_id = 90221 AND obs.voided = false ORDER BY  obs.encounter_id DESC");

        if (adherenceObsList.size() > 0) {
            model.addAttribute("adherenceObs", adherenceObsList);
        } else {
            model.addAttribute("adherenceObs", null);
        }

        /**
         * ThirdLine Regimen
         */
        List<Concept> concepts = new ArrayList<>();
        Collection<ConceptAnswer> conceptAnswers = conceptService.getConcept(1).getAnswers(false);
        for (ConceptAnswer conceptAnswer : conceptAnswers) {
            if (conceptAnswer.getConcept().getConceptId() != 90002) {
                conceptAnswers.remove(conceptAnswer);
                concepts.add(conceptAnswer.getAnswerConcept());
            }
        }
        if (regimenObsList.size() > 0 && concepts.contains(regimenObsList.get(0).getValueCoded())) {
            model.addAttribute("onThirdRegimen", true);
        } else {
            model.addAttribute("onThirdRegimen", false);
        }

        /**
         * Clinic Staging
         */

        List<Concept> clinicStage = new ArrayList<>();
        List<Obs> clinicStageObsList = getObsListFromIdList("SELECT obs_id FROM obs where obs.person_id='" + patient.getPatientId() + "' AND obs.concept_id IN (99083,90203) AND obs.voided = false  ORDER BY  obs.encounter_id DESC");

        if (clinicStageObsList.size() > 0) {
            model.addAttribute("conceptForClinicStage", clinicStageObsList.get(0).getValueCoded().getConceptId());
        } else {
            model.addAttribute("conceptForClinicStage", null);
        }

        /**
         * Sputum Results
         */

        List<Concept> sputumConcept = new ArrayList<>();
        sputumConcept.add(Context.getConceptService().getConcept(307));
        Obs spetumObs = patientSummaryFragmentController.getMostRecentObservation(obsService, personList, sputumConcept);
        model.addAttribute("sputumResultObs", spetumObs);

        /**
         * Sputum ResultDate
         */

        List<Concept> sputumDateConcept = new ArrayList<>();
        sputumDateConcept.add(Context.getConceptService().getConcept(99392));
        Obs spetumDateObs = patientSummaryFragmentController.getMostRecentObservation(obsService, personList, sputumDateConcept);
        model.addAttribute("sputumResultDateObs", spetumDateObs);


        /**
         * Current Regimen
         */
        model.addAttribute("artStartDate", getArtStartDate(patient));
    }


    /**
     * This Subtracts a date provided by number of moths and years given and returns a new date
     *
     * @param referenceDate
     * @param noOfMoths
     * @return
     */
    public String getDateBefore(Date referenceDate, int noOfMoths, int noOfYears) {
        Calendar cal = Calendar.getInstance();
        cal.setTime(referenceDate);
        if (noOfMoths != 0) {
            cal.set(Calendar.DAY_OF_MONTH, cal.getActualMinimum(Calendar.DAY_OF_MONTH));
        }
        cal.add(Calendar.MONTH, noOfMoths);
        cal.add(Calendar.YEAR, noOfYears);
        DateFormat format = new SimpleDateFormat("yyyy-MM-dd");
        String finalDate = null;
        try {
            finalDate = format.format(cal.getTime());
        } catch (Exception e) {
            e.printStackTrace();
        }
        return finalDate;
    }

    /**
     * Gets List of Obs Basing on the query provided
     *
     * @param query
     * @return
     */
    private List<Obs> getObsListFromIdList(String query) {
        List<Obs> obsList = new ArrayList<>();
        for (Object o : Context.getAdministrationService().executeSQL(query, true)) {
            obsList.add(Context.getObsService().getObs(Integer.parseInt(((ArrayList) o).get(0).toString())));
        }
        return obsList;
    }

    /**
     * Get ART START DATE From Summary Page of a Patient
     *
     * @param patient
     * @return
     */
    public Date getArtStartDate(Patient patient) {
        List<Obs> list = Context.getObsService().getObservationsByPersonAndConcept(patient, Context.getConceptService().getConcept(99161));
        Date artStartDate = null;
        if (list.size() > 0) {
            artStartDate = list.get(0).getValueDatetime();
        }
        return artStartDate;

    }

    /**
     * Check if DTG
     *
     * @param obs
     * @return
     */
    private boolean checkIfDTG(Obs obs) {
        return "164976,164977,164978,164979".contains(obs.getValueCoded().getConceptId().toString());
    }
}
