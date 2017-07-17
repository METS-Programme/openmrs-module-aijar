package org.openmrs.module.aijar.dataintegrity;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotNull;

import java.util.List;

import org.junit.Before;
import org.junit.Test;
import org.openmrs.Patient;
import org.openmrs.module.dataintegrity.rule.RuleResult;
import org.openmrs.test.BaseModuleContextSensitiveTest;

public class InvalidTBEncountersTest extends BaseModuleContextSensitiveTest{
	
	protected static final String UGANDAEMR_STANDARD_DATASET_XML = "org/openmrs/module/aijar/include/standardTestDataset.xml";
	protected static final String UGANDAEMR_DATA_VIOLATIONS_XML = "org/openmrs/module/aijar/include/tbEncountersData.xml";

	InvalidTBEncounters invalidTBEncounters;

	@Before
	public void initialize() throws Exception {
		executeDataSet(UGANDAEMR_STANDARD_DATASET_XML);
		executeDataSet(UGANDAEMR_DATA_VIOLATIONS_XML);

		invalidTBEncounters = new InvalidTBEncounters();
	}
	
	@Test
	public void testInvalidTBEncounters() {
		List<RuleResult<Patient>> result = invalidTBEncounters.patientsWithNoFinalOutcomeNineMonthsAfterStartOfTreatment();
		assertNotNull(result);
		assertEquals(1, result.size());
		Patient patient = result.get(0).getEntity();
		assertEquals(10001, patient.getId().longValue());
	}
	
	@Test
	public void patientsWithSimilarTBIdentifiersDuplicatedAcrossMultiplePatientsTest() {
		List<RuleResult<Patient>> result = invalidTBEncounters.patientsWithSimilarTBIdentifiersDuplicatedAcrossMultiplePatients(99031, "District TB Number");
		assertNotNull(result);
		assertEquals(2, result.size());
		
	}
	
	@Test
	public void patientsWithSimilarTBNumberIdentifiersDuplicatedForASinglePatientTest() {
		List<RuleResult<Patient>> result = invalidTBEncounters.patientsWithSimilarTBNumberIdentifiersDuplicatedForASinglePatient(164955, "Unit TB Number");
		assertNotNull(result);
		assertEquals(1, result.size());
		Patient patient = result.get(0).getEntity();
		assertEquals(10002, patient.getId().longValue());
		
	}
	
	@Test
	public void patientsWithMissingTBNumberIdentifiersTest() {
		List<RuleResult<Patient>> result = invalidTBEncounters.patientsWithMissingTBNumberIdentifiers("d1cda288-4853-4450-afbc-76bd4e65ea70", "HSD TB Number");
		assertNotNull(result);
		assertEquals(2, result.size());
		
	}
	
}
