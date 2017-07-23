package org.openmrs.module.aijar.dataintegrity;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotNull;

import java.util.List;

import org.joda.time.DateTime;
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
	public void patientsWithNoFinalOutcomeNineMonthsAfterStartOfTreatmentTest() {
		DateTime date = new DateTime("2017-07-19");
		List<RuleResult<Patient>> result = invalidTBEncounters.patientsWithNoFinalOutcomeNineMonthsAfterStartOfTreatment(date);
		assertNotNull(result);
		assertEquals(3, result.size());
	}
	
	@Test
	public void patientsWithSimilarTBIdentifiersDuplicatedAcrossMultiplePatientsTest() {
		List<RuleResult<Patient>> result = invalidTBEncounters.patientsWithSimilarTBIdentifiersDuplicatedAcrossMultiplePatients("67e9ec2f-4c72-408b-8122-3706909d77ec", "District TB Number");
		assertNotNull(result);
		assertEquals(2, result.size());
		
	}
	
	@Test
	public void patientsWithSimilarTBNumberIdentifiersDuplicatedForASinglePatientTest() {
		List<RuleResult<Patient>> result = invalidTBEncounters.patientsWithSimilarTBNumberIdentifiersDuplicatedForASinglePatient("304df0d0-afe4-4a61-a917-d684b100a65a", "Unit TB Number");
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
