package org.openmrs.module.aijar.dataintegrity;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotNull;

import java.util.List;

import org.joda.time.DateTime;
import org.junit.Before;
import org.junit.Test;
import org.openmrs.Patient;
import org.openmrs.module.aijar.metadata.concept.Concepts;
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
	
	//@Test
	public void patientsWithNoFinalOutcomeNineMonthsAfterStartOfTreatmentTest() {
		DateTime date = new DateTime("2017-07-19");
		List<RuleResult<Patient>> result = invalidTBEncounters.patientsWithNoFinalOutcomeNineMonthsAfterStartOfTreatment(date);
		assertNotNull(result);
		assertEquals(3, result.size());
	}
	
	//@Test
	public void multiplePatientsWithTheSameTBIdentifiersTest() {
		List<RuleResult<Patient>> result = invalidTBEncounters.multiplePatientsWithTheSameTBIdentifiers(Concepts.DISTRICT_TB_NUMBER, "District TB Number");
		assertNotNull(result);
		assertEquals(2, result.size());
		
	}
	
	@Test
	public void singlePatientWithDuplicateTBNumberAcrossMultipleTreatmentProgramsTest() {
		List<RuleResult<Patient>> result = invalidTBEncounters.singlePatientWithDuplicateTBNumberAcrossMultipleTreatmentPrograms(Concepts.UNIT_TB_NUMBER, "Unit TB Number");
		assertNotNull(result);
		assertEquals(1, result.size());
		Patient patient = result.get(0).getEntity();
		assertEquals(10002, patient.getId().longValue());
		
	}
	
	//@Test
	public void patientsWithMissingTBNumbersTest() {
		List<RuleResult<Patient>> result = invalidTBEncounters.patientsWithMissingTBNumbers(Concepts.HSD_TB_NUMBER, "HSD TB Number");
		assertNotNull(result);
		assertEquals(2, result.size());
		
	}
	
}
