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
 * Enrolls patients into the MCH program
 */
public class MCHProgramEnrollmentPostSubmissionAction implements CustomFormSubmissionAction {
	
	@Override
	public void applyAction(FormEntrySession session) {
		//enroll only on initial form submission
		if (!session.getContext().getMode().equals(FormEntryContext.Mode.ENTER)) {
			return;
		}
		
		ProgramWorkflowService service = Context.getService(ProgramWorkflowService.class);
		Program mchProgram = service.getProgramByUuid(Programs.MCH_PROGRAM.uuid());
		if (mchProgram == null) {
			throw new APIException("The MCH Program does not exist. Please restore it if deleted");
		}
		Patient patient = session.getPatient();
		
		//return if patient is already enrolled in an MCH program
		for (PatientProgram patientProgram : service.getPatientPrograms(patient, mchProgram, null, null, null, null,
		    false)) {
			if (patientProgram.getActive()) {
				return;
			}
		}
		
		PatientProgram enrollment = new PatientProgram();
		enrollment.setProgram(mchProgram);
		enrollment.setPatient(patient);
		enrollment.setDateEnrolled(session.getEncounter().getEncounterDatetime());
		service.savePatientProgram(enrollment);
	}
}
