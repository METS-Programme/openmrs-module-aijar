package org.openmrs.module.aijar.htmlformentry;

import org.openmrs.Obs;
import org.openmrs.Patient;
import org.openmrs.PatientProgram;
import org.openmrs.Program;
import org.openmrs.api.context.Context;
import org.openmrs.module.htmlformentry.CustomFormSubmissionAction;
import org.openmrs.module.htmlformentry.FormEntryContext;
import org.openmrs.module.htmlformentry.FormEntryContext.Mode;
import org.openmrs.module.htmlformentry.FormEntrySession;


import java.util.*;

import static org.openmrs.module.aijar.AijarConstants.GP_DSDM_CONCEPT_ID;
import static org.openmrs.module.aijar.AijarConstants.GP_DSDM_PROGRAM_UUID_NAME;

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
        List<PatientProgram> patientPrograms = getActivePatientProgramAfterThisEncounter(patient, null, session.getEncounter().getEncounterDatetime());

        /**
         * Terminate wen patient is already enrolled in the program selected.
         */
        for (PatientProgram patientProgram : patientPrograms) {
            /**
             * Check if Same program is enrolled on the same date
             */
            if (patientProgram.getProgram() == getProgramByConceptFromObs(obsList) && patientProgram.getDateEnrolled() == session.getEncounter().getEncounterDatetime()) {
                return;
            }
        }

        /**
         * Completing all DSDM active programs of the patient
         */
        if (!patientPrograms.isEmpty()) {
            for (PatientProgram previousPatientDSDMProgram : patientPrograms) {
                /**
                 * Check if program to enroll is greater than
                 */
                if (session.getEncounter().getEncounterDatetime().compareTo(previousPatientDSDMProgram.getDateEnrolled()) > 0) {
                    if (getDSDMPrograms().contains(previousPatientDSDMProgram.getProgram())) {
                        previousPatientDSDMProgram.setDateCompleted(session.getEncounter().getEncounterDatetime());
                        Context.getProgramWorkflowService().savePatientProgram(previousPatientDSDMProgram);
                    }
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
            newPatientDSDMProgram.setDateCompleted(null);
            Context.getProgramWorkflowService().savePatientProgram(newPatientDSDMProgram);
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
            if (obs.getConcept().getConceptId() == Integer.parseInt(dsdmConceptId) && obs.getConcept().getDatatype() == Context.getConceptService().getConceptDatatypeByName("Coded")) {
                programList = Context.getProgramWorkflowService().getProgramsByConcept(obs.getValueCoded());
            }
        }
        if (!programList.isEmpty()) {
            program = programList.get(0);
        }
        return program;
    }


    /**
     * This takes in a patient program and weather previous or after search and determines if there is a previous program or there is an after program
     *
     * @param patient
     * @param maxEnrollmentDate
     * @return
     */
    private List<PatientProgram> getActivePatientProgramAfterThisEncounter(Patient patient, Date minEnrollmentDate, Date maxEnrollmentDate) {
       List<PatientProgram> patientPrograms=new ArrayList<PatientProgram>();

        patientPrograms = Context.getProgramWorkflowService().getPatientPrograms(patient, null, minEnrollmentDate, maxEnrollmentDate, null, null, false);
        if (patientPrograms.size() > 0) {
            for (PatientProgram patientProgram : patientPrograms) {
                if (!patientProgram.getActive()) {
                    patientPrograms.remove(patientProgram);
                }
            }
        }
        return patientPrograms;
    }
    /**
     * Get List of DSDM Programs
     *
     * @return
     */
    public List<Program> getDSDMPrograms() {
        String dsdmuuids = Context.getAdministrationService().getGlobalProperty(GP_DSDM_PROGRAM_UUID_NAME);

        List<String> listOfDSDMPrograms = Arrays.asList(dsdmuuids.split("\\s*,\\s*"));
        List<Program> dsdmPrograms = new ArrayList<>();

        for (String s : listOfDSDMPrograms) {

            Program dsdmProgram = Context.getProgramWorkflowService().getProgramByUuid(s);
            if (dsdmProgram != null) {
                dsdmPrograms.add(dsdmProgram);
            }
        }

        return dsdmPrograms;
    }
}