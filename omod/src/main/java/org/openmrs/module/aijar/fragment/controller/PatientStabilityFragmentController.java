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
        List<Obs> vlObsList = getObsListFromIdList("SELECT obs_id FROM obs where  obs.obs_datetime BETWEEN '" + getDateBefore(encounterVisit.getStartDatetime(), -12) + "' AND '" + encounterVisit.getStartDatetime() + "' AND obs.person_id='" + patient.getPatientId() + "' AND obs.concept_id = 1305 AND obs.voided = false  ORDER BY  obs.encounter_id DESC");
        if (vlObsList.size() > 0) {
            model.addAttribute("vlObs", vlObsList.get(0));
        } else {
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
        List<Obs> regimenObsList = getObsListFromIdList("SELECT obs_id FROM obs where  obs.obs_datetime <= DATE('" + getDateBefore(encounterVisit.getStartDatetime(), -12) + "') AND obs.person_id='" + patient.getPatientId() + "' AND obs.value_coded = " + patientSummaryFragmentController.getMostRecentObservation(obsService, personList, currentRegimentConcept).getValueCoded().getConceptId() + " AND obs.voided = false ORDER BY  obs.encounter_id DESC");
        if (regimenObsList.size() > 0) {
            model.addAttribute("regimenObs", regimenObsList.get(0));
        } else {
            model.addAttribute("regimenObs", null);
        }


        /**
         * Adherence
         */
        List<Obs> adherenceObsList = getObsListFromIdList("SELECT obs_id FROM obs where  obs.obs_datetime BETWEEN '" + getDateBefore(encounterVisit.getStartDatetime(), -6) + "' AND '" + encounterVisit.getStartDatetime() + "' AND obs.person_id='" + patient.getPatientId() + "' AND obs.concept_id = 90221 AND obs.voided = false ORDER BY  obs.encounter_id DESC");

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
        if (regimenObsList.size()>0 && concepts.contains(regimenObsList.get(0).getValueCoded())) {
            model.addAttribute("onThirdRegimen", true);
        } else {
            model.addAttribute("onThirdRegimen", false);
        }

        /**
         * Clinic Staging
         */

        List<Concept> clinicStage = new ArrayList<>();
        List<Obs> clinicStageObsList=getObsListFromIdList("SELECT obs_id FROM obs where obs.person_id='" + patient.getPatientId() + "' AND obs.concept_id IN (99083,90203) AND obs.voided = false  ORDER BY  obs.encounter_id DESC");

        if (clinicStageObsList.size()>0) {
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
    }


    /**
     * @param referenceDate
     * @param noOfMoths
     * @return
     */
    public String getDateBefore(Date referenceDate, int noOfMoths) {
        Calendar cal = Calendar.getInstance();
        cal.setTime(referenceDate);
        cal.set(Calendar.DAY_OF_MONTH, cal.getActualMinimum(Calendar.DAY_OF_MONTH));
        cal.add(Calendar.MONTH, noOfMoths);
        DateFormat format = new SimpleDateFormat("yyyy-MM-dd");
        String finalDate = null;
        try {
            finalDate = format.format(cal.getTime());
        } catch (Exception e) {
            e.printStackTrace();
        }
        return finalDate;
    }

    private List<Obs> getObsListFromIdList(String query) {
        List<Obs> obsList = new ArrayList<>();
        for (Object o : Context.getAdministrationService().executeSQL(query, true)) {
            obsList.add(Context.getObsService().getObs(Integer.parseInt(((ArrayList) o).get(0).toString())));
        }
        return obsList;
    }
}
