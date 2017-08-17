package org.openmrs.module.aijar.htmlformentry;

import java.util.Date;

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
 * Exits patients out of the MCH program
 */
public class MCHProgramExitPostSubmissionAction implements CustomFormSubmissionAction {
	
	@Override
	public void applyAction(FormEntrySession session) {
		
		//exit only on initial form submission
		if (!session.getContext().getMode().equals(FormEntryContext.Mode.ENTER)) {
			return;
		}
		
		ProgramWorkflowService service = Context.getService(ProgramWorkflowService.class);
		Program mchProgram = service.getProgramByUuid(Programs.MCH_PROGRAM.uuid());
		if (mchProgram == null) {
			throw new APIException("The MCH Program does not exist. Please restore it if deleted");
		}
		Patient patient = session.getPatient();
		boolean enrollmentFound = false;
		for (PatientProgram patientProgram : service.getPatientPrograms(patient, mchProgram, null, null, null, null, false)) {
			if (patientProgram.getActive()) {
				patientProgram.setDateCompleted(new Date());
				service.savePatientProgram(patientProgram);
				enrollmentFound = true;
			}
		}
		
		if (!enrollmentFound) {
			//enroll and exit immediately
			PatientProgram patientProgram = new PatientProgram();
			patientProgram.setProgram(mchProgram);
			patientProgram.setPatient(patient);
			patientProgram.setDateEnrolled(session.getEncounter().getEncounterDatetime());
			patientProgram.setDateCompleted(new Date());
			service.savePatientProgram(patientProgram);
		}
	}
}
