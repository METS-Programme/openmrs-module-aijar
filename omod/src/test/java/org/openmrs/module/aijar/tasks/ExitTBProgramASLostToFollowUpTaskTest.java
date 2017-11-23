package org.openmrs.module.aijar.tasks;

import java.util.Date;
import java.util.List;

import org.junit.Assert;
import org.junit.Before;
import org.junit.Test;
import org.openmrs.Encounter;
import org.openmrs.Patient;
import org.openmrs.PatientProgram;
import org.openmrs.Program;
import org.openmrs.api.ProgramWorkflowService;
import org.openmrs.api.context.Context;
import org.openmrs.module.aijar.metadata.core.Programs;
import org.openmrs.module.aijar.tasks.ExitTBProgramASLostToFollowUpTask;
import org.openmrs.web.test.BaseModuleWebContextSensitiveTest;

public class ExitTBProgramASLostToFollowUpTaskTest extends BaseModuleWebContextSensitiveTest {
	
	protected static final String UGANDAEMR_STANDARD_DATASET_XML = "org/openmrs/module/aijar/include/standardTestDataset.xml";

	@Before
	public void setup() throws Exception {
		executeDataSet(UGANDAEMR_STANDARD_DATASET_XML);
	}
	
	@Test
	public void shoudExitPatientsWhoAreLostToFollowUp() {
		
		Patient patient = new Patient(7);
		ProgramWorkflowService service = Context.getService(ProgramWorkflowService.class);
		Program tbProgram = service.getProgramByUuid(Programs.TB_PROGRAM.uuid());
		
		//should be enrolled in the tb program
		List<PatientProgram> patientPrograms = service.getPatientPrograms(patient, tbProgram, null, null, null, null, false);
		Assert.assertEquals(1, patientPrograms.size());
		
		new ExitTBProgramASLostToFollowUpTask().execute();
		
		//should not be enrolled in tb program
        patientPrograms = service.getPatientPrograms(patient, tbProgram, null, null, null, null, false);
		Assert.assertEquals(0, patientPrograms.size());
	}
	
	@Test
	public void shoudNotExitPatientsWhoAreNotLostToFollowUp() {
		
		Patient patient = new Patient(7);
		ProgramWorkflowService service = Context.getService(ProgramWorkflowService.class);
		Program tbProgram = service.getProgramByUuid(Programs.TB_PROGRAM.uuid());
		
		//should be enrolled in the tb program
		List<PatientProgram> patientPrograms = service.getPatientPrograms(patient, tbProgram, null, null, null, null, false);
		Assert.assertEquals(1, patientPrograms.size());
		
		//adjust the latest encounter date to less than the lost to follow up days
		List<Encounter> encounters = Context.getEncounterService().getEncountersByPatient(patient);
		Encounter latestEncounter = encounters.get(encounters.size() - 1);
		latestEncounter.setEncounterDatetime(new Date());
		Context.getEncounterService().saveEncounter(latestEncounter);
		
		new ExitTBProgramASLostToFollowUpTask().execute();
		
		//should still be enrolled in tb program
        patientPrograms = service.getPatientPrograms(patient, tbProgram, null, null, null, null, false);
		Assert.assertEquals(1, patientPrograms.size());
	}
}
