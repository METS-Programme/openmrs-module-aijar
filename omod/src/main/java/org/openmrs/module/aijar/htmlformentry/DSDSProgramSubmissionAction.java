package org.openmrs.module.aijar.htmlformentry;

import org.openmrs.Obs;
import org.openmrs.Patient;
import org.openmrs.PatientProgram;
import org.openmrs.Program;
import org.openmrs.api.context.Context;
import org.openmrs.module.aijar.page.controller.AddPatientProgramPageController;
import org.openmrs.module.htmlformentry.CustomFormSubmissionAction;
import org.openmrs.module.htmlformentry.FormEntryContext;
import org.openmrs.module.htmlformentry.FormEntryContext.Mode;
import org.openmrs.module.htmlformentry.FormEntrySession;

import java.sql.Date;
import java.util.ArrayList;
import java.util.List;
import java.util.Set;

import static org.openmrs.api.context.Context.getProgramWorkflowService;
import static org.openmrs.module.aijar.AijarConstants.GP_DSDM_CONCEPT_ID;

/**
 * Enrolls patients into the TB program
 */
public class DSDSProgramSubmissionAction implements CustomFormSubmissionAction {
    @Override
    public void applyAction(FormEntrySession session) {
        Mode mode = session.getContext().getMode();
        if (!(mode.equals(FormEntryContext.Mode.ENTER) || mode.equals(FormEntryContext.Mode.EDIT))) {
            return;
        }

        Patient patient = session.getPatient();
        Set<Obs> obsList = session.getEncounter().getAllObs();
        AddPatientProgramPageController addPatientProgramPageController = new AddPatientProgramPageController();
        List<PatientProgram> patientPrograms = addPatientProgramPageController.getPatientActiveProgram(patient);

        /**
         * Terminate wen patient is already enrolled in the program selected.
         */
        for (PatientProgram patientProgram : patientPrograms) {
            if (patientProgram.getProgram() == getProgramByConceptFromObs(obsList)) {
                return;
            }
        }

        /**
         * Completing all DSDM active programs of the patient
         */
        if (!patientPrograms.isEmpty()) {
            for (PatientProgram previousPatientDSDMProgram : patientPrograms) {
                if (addPatientProgramPageController.getDSDMPrograms().contains(previousPatientDSDMProgram.getProgram())) {
                    previousPatientDSDMProgram.setDateCompleted(session.getEncounter().getEncounterDatetime());
                    getProgramWorkflowService().savePatientProgram(previousPatientDSDMProgram);
                }
            }
        }

        /**
         * Create new PatientProgram
         */
        if (getProgramByConceptFromObs(obsList) != null) {
            PatientProgram newPatientDSDMProgram = new PatientProgram();
            newPatientDSDMProgram.setPatient(patient);
            newPatientDSDMProgram.setDateEnrolled(session.getEncounter().getEncounterDatetime());
            newPatientDSDMProgram.setProgram(getProgramByConceptFromObs(obsList));
            getProgramWorkflowService().savePatientProgram(newPatientDSDMProgram);
        }
    }

    /**
     * Get Program from selected value of the DSDM field on the form
     *
     * @param obsList
     * @return
     */
    private Program getProgramByConceptFromObs(Set<Obs> obsList) {
        List<Program> programList = new ArrayList<>();
        Program program = null;
        String dsdmConceptId = Context.getAdministrationService().getGlobalProperty(GP_DSDM_CONCEPT_ID);
        for (Obs obs : obsList) {
            AddPatientProgramPageController addPatientProgramPageController = new AddPatientProgramPageController();
            if (obs.getConcept().getConceptId() == Integer.parseInt(dsdmConceptId) && obs.getConcept().getDatatype() == Context.getConceptService().getConceptDatatypeByName("Coded")) {
                programList = Context.getProgramWorkflowService().getProgramsByConcept(obs.getValueCoded());
            }
        }
        if (!programList.isEmpty()) {
            program = programList.get(0);
        }

        return program;
    }
}