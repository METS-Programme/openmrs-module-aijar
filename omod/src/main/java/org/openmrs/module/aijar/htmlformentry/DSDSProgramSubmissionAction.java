package org.openmrs.module.aijar.htmlformentry;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import org.openmrs.Obs;
import org.openmrs.Patient;
import org.openmrs.PatientProgram;
import org.openmrs.Program;
import org.openmrs.User;
import org.openmrs.api.context.Context;
import org.openmrs.module.aijar.fragment.controller.PatientSummaryFragmentController;
import org.openmrs.module.htmlformentry.CustomFormSubmissionAction;
import org.openmrs.module.htmlformentry.FormEntryContext;
import org.openmrs.module.htmlformentry.FormEntryContext.Mode;
import org.openmrs.module.htmlformentry.FormEntrySession;


import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Set;
import java.util.Arrays;

import static org.openmrs.module.aijar.AijarConstants.GP_DSDM_CONCEPT_ID;
import static org.openmrs.module.aijar.AijarConstants.GP_DSDM_PROGRAM_UUID_NAME;

/**
 * Enrolls patients into DSDM programs
 */
public class DSDSProgramSubmissionAction implements CustomFormSubmissionAction {
    private static final Log log = LogFactory.getLog(PatientSummaryFragmentController.class);

    @Override
    public void applyAction(FormEntrySession session) {
        Mode mode = session.getContext().getMode();
        if (!(mode.equals(FormEntryContext.Mode.ENTER) || mode.equals(FormEntryContext.Mode.EDIT))) {
            return;
        }

        //Create DSDM Program on entry of ART Summary Page
        if(mode.equals(Mode.ENTER) && session.getEncounter().getEncounterType()==Context.getEncounterService().getEncounterTypeByUuid("8d5b27bc-c2cc-11de-8d13-0010c6dffd0f")){
            createPatientProgram(session.getEncounter().getPatient(), session.getEncounter().getEncounterDatetime(), Context.getProgramWorkflowService().getProgramByUuid("de5d54ae-c304-11e8-9ad0-529269fb1459"));
        return;
        }


        Patient patient = session.getPatient();
        Set<Obs> obsList = session.getEncounter().getAllObs();
        List<PatientProgram> patientPrograms = getActivePatientProgramAfterThisEncounter(patient, null, session.getEncounter().getEncounterDatetime());

        List<Program> dsdmPrograms = getDSDMPrograms();

        if (mode.equals(FormEntryContext.Mode.EDIT) && session.getEncounter().getEncounterType()!=Context.getEncounterService().getEncounterTypeByUuid("8d5b27bc-c2cc-11de-8d13-0010c6dffd0f")) {
            List<PatientProgram> patientProgramOnEncounterDate = getActivePatientProgramAfterThisEncounter(patient, session.getEncounter().getEncounterDatetime(), session.getEncounter().getEncounterDatetime());

            if (obsList != null && getProgramByConceptFromObs(obsList) == null && patientProgramOnEncounterDate.size() > 0) {
                for (PatientProgram currentPatientProgram : patientProgramOnEncounterDate) {
                    /**
                     * Void DSDM Program whose obs has been voided
                     */
                    voidPatientProgram(currentPatientProgram, "Matching Observation voided", session.getEncounter().getChangedBy(), session.getEncounter().getDateChanged());

                    List<PatientProgram> previousPatientPrograms = openPreviouslyClosedPatientProgram(patient, currentPatientProgram.getDateEnrolled(), session.getEncounter().getChangedBy());

                    if (previousPatientPrograms.size() > 0) {
                        for (PatientProgram previousPatientProgram : previousPatientPrograms) {
                            if (dsdmPrograms.contains(currentPatientProgram.getProgram())) {

                                /**
                                 * Void Previous DSDM Program
                                 */
                                voidPatientProgram(previousPatientProgram, "Matching Observation voided", session.getEncounter().getChangedBy(), session.getEncounter().getDateChanged());

                                /**
                                 * Recreate Voided Program
                                 */
                                createPatientProgram(patient, previousPatientProgram.getDateEnrolled(), previousPatientProgram.getProgram());
                            }
                        }
                    }
                }

            } else if (obsList != null && patientProgramOnEncounterDate.size() > 0 && getProgramByConceptFromObs(obsList) != null && getProgramByConceptFromObs(obsList) != patientProgramOnEncounterDate.get(0).getProgram()) {

                for (PatientProgram patientProgram : patientProgramOnEncounterDate) {
                    voidPatientProgram(patientProgram, "Matching Observation voided", session.getEncounter().getChangedBy(), session.getEncounter().getDateChanged());
                }
            }
        }

        /**
         * Terminate wen patient is already enrolled in the program selected.
         */
        for (PatientProgram patientProgram : patientPrograms) {
            /**
             * Check if Same program is enrolled
             */
            if(patientProgram.getProgram() == getProgramByConceptFromObs(obsList)){
                return;
            }
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
         * Enroll patient in  new PatientProgram
         */
        if (getProgramByConceptFromObs(obsList) != null) {
            createPatientProgram(patient, session.getEncounter().getEncounterDatetime(), getProgramByConceptFromObs(obsList));
        }
    }

    private PatientProgram createPatientProgram(Patient patient, Date enrollmentDate, Program program) {
        PatientProgram patientProgram = new PatientProgram();
        patientProgram.setPatient(patient);
        patientProgram.setDateEnrolled(enrollmentDate);
        patientProgram.setProgram(program);
        patientProgram.setDateCompleted(null);
        return Context.getProgramWorkflowService().savePatientProgram(patientProgram);
    }

    private PatientProgram voidPatientProgram(PatientProgram patientProgram, String reason, User user, Date changedDated) {
        patientProgram.setVoided(true);
        patientProgram.setVoidedBy(user);
        patientProgram.setVoidReason(reason);
        patientProgram.setDateChanged(changedDated);
        return Context.getProgramWorkflowService().savePatientProgram(patientProgram);
    }


    private List<PatientProgram> openPreviouslyClosedPatientProgram(Patient patient, Date date, User user) {
        return getCompletedPatientProgramOnDate(patient, date);
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
     * @param minEnrollmentDate
     * @param maxEnrollmentDate
     * @return
     */
    private List<PatientProgram> getActivePatientProgramAfterThisEncounter(Patient patient, Date minEnrollmentDate, Date maxEnrollmentDate) {
        List<PatientProgram> patientPrograms = new ArrayList<PatientProgram>();

        patientPrograms = Context.getProgramWorkflowService().getPatientPrograms(patient, null, minEnrollmentDate, maxEnrollmentDate, null, null, false);
        return patientPrograms;
    }


    /**
     * This takes in a patient program and weather previous or after search and determines if there is a previous program or there is an after program
     *
     * @param patient
     * @param completionDate
     * @return
     */
    private List<PatientProgram> getCompletedPatientProgramOnDate(Patient patient, Date completionDate) {
        List<PatientProgram> patientPrograms = new ArrayList<PatientProgram>();

        patientPrograms = Context.getProgramWorkflowService().getPatientPrograms(patient, null, null, null, completionDate, completionDate, false);
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