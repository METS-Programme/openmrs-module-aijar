package org.openmrs.module.aijar.tasks;

import java.util.Date;
import java.util.List;

import org.joda.time.DateTime;
import org.joda.time.Days;
import org.openmrs.Encounter;
import org.openmrs.Patient;
import org.openmrs.PatientProgram;
import org.openmrs.Program;
import org.openmrs.api.ProgramWorkflowService;
import org.openmrs.api.context.Context;
import org.openmrs.module.aijar.metadata.core.Programs;
import org.openmrs.scheduler.tasks.AbstractTask;

/**
 * Exits patients, who have lost follow up, from the TB program
 */
public class ExitTBProgramASLostToFollowUpTask extends AbstractTask {

	public static final int LOST_TO_FOLLOWUP_CONCEPT_ID = 5240;
	
	private int lostToFollowUpDays = 60;
	
	@Override
	public void execute() {
		
		lostToFollowUpDays = Integer.parseInt(Context.getAdministrationService().getGlobalProperty("ugandaemr.lostToFollowUpDaysTB", "60"));
		
		ProgramWorkflowService service = Context.getService(ProgramWorkflowService.class);
		Program tbProgram = service.getProgramByUuid(Programs.TB_PROGRAM.uuid());

		//exit if patient is enrolled and lost to follow up
		for (PatientProgram patientProgram : service.getPatientPrograms(null, tbProgram, null, null, null, null, false)) {
			if (!patientProgram.getActive()) {
				continue;
			}
			
			if (lostToFollowUp(patientProgram.getPatient())) {
				patientProgram.setDateCompleted(new Date());
				patientProgram.setOutcome(Context.getConceptService().getConcept(LOST_TO_FOLLOWUP_CONCEPT_ID));
				service.voidPatientProgram(patientProgram, "ExitTBProgramTask Lost to followup");
			}
		}
	}
	
	private boolean lostToFollowUp(Patient patient) {
		List<Encounter> encounters = Context.getEncounterService().getEncountersByPatient(patient);
		if (encounters == null || encounters.size() == 0) {
			return false;
		}
		
		Encounter latestEncounter = encounters.get(encounters.size() - 1);
		int days = Days.daysBetween(new DateTime(latestEncounter.getEncounterDatetime().getTime()), new DateTime()).getDays();
		return days > lostToFollowUpDays;
	}
}
