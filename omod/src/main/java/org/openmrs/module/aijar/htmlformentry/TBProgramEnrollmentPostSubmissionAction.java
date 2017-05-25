package org.openmrs.module.aijar.htmlformentry;

import org.openmrs.Patient;
import org.openmrs.PatientProgram;
import org.openmrs.Program;
import org.openmrs.api.APIException;
import org.openmrs.api.ProgramWorkflowService;
import org.openmrs.api.context.Context;
import org.openmrs.module.aijar.metadata.core.Programs;
import org.openmrs.module.htmlformentry.CustomFormSubmissionAction;
import org.openmrs.module.htmlformentry.FormEntryContext;
import org.openmrs.module.htmlformentry.FormEntrySession;

/**
 * Enrolls patients into the TB program
 */
public class TBProgramEnrollmentPostSubmissionAction implements CustomFormSubmissionAction {
	
	@Override
	public void applyAction(FormEntrySession session) {
		//enroll only on initial form submission
		if (!session.getContext().getMode().equals(FormEntryContext.Mode.ENTER)) {
			return;
		}
		
		ProgramWorkflowService service = Context.getService(ProgramWorkflowService.class);
		Program tbProgram = service.getProgramByUuid(Programs.TB_PROGRAM.uuid());
		if (tbProgram == null) {
			throw new APIException("The TB Program does not exist. Please restore it if deleted");
		}
		Patient patient = session.getPatient();
		
		//return if patient is already enrolled in a TB program
		for (PatientProgram patientProgram : service.getPatientPrograms(patient, tbProgram, null, null, null, null, false)) {
			if (patientProgram.getActive()) {
				return;
			}
		}
		
		PatientProgram enrollment = new PatientProgram();
		enrollment.setProgram(tbProgram);
		enrollment.setPatient(patient);
		enrollment.setDateEnrolled(session.getEncounter().getEncounterDatetime());
		service.savePatientProgram(enrollment);
	}
}
