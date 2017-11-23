package org.openmrs.module.aijar.dataintegrity;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotNull;

import java.util.List;

import org.junit.Before;
import org.junit.Test;
import org.openmrs.Encounter;
import org.openmrs.Patient;
import org.openmrs.module.dataintegrity.rule.RuleResult;
import org.openmrs.test.BaseModuleContextSensitiveTest;

/**
 * Test for Incomplete Exposed Infant information data integrity rules
 */
public class IncompleteExposedInfantInformationTest extends BaseModuleContextSensitiveTest {

	protected static final String UGANDAEMR_STANDARD_DATASET_XML = "org/openmrs/module/aijar/include/standardTestDataset.xml";
	protected static final String UGANDAEMR_DATA_VIOLATIONS_XML = "org/openmrs/module/aijar/include/exposedInfantData.xml";

	IncompleteExposedInfantInformation incompleteExposedInfantInformation;

	@Before
	public void initialize() throws Exception {
		executeDataSet(UGANDAEMR_STANDARD_DATASET_XML);
		executeDataSet(UGANDAEMR_DATA_VIOLATIONS_XML);

		incompleteExposedInfantInformation = new IncompleteExposedInfantInformation();
	}

	@Test
	public void testExposedInfantsWithEncountersAndNOSummaryPage() {
		List<RuleResult<Patient>> result = incompleteExposedInfantInformation.exposedInfantsWithEncountersAndNOSummaryPage();
		assertNotNull(result);
		assertEquals(1, result.size());
		Patient patient = result.get(0).getEntity();
		assertEquals(10002, patient.getId().longValue());
	}

	@Test
	public void testExposedInfantsOlderThan18MonthsWithNoFinalOutcome() {
		List<RuleResult<Patient>> result = incompleteExposedInfantInformation.exposedInfantsOlderThan18MonthsWithNoFinalOutcome();
		assertNotNull(result);
		
		for (RuleResult<Patient> ruleResult: result) {
			System.out.println("No outcome patient Id " + ruleResult.getEntity().getPatientId());
		}
		assertEquals(1, result.size());
		Patient patient = result.get(0).getEntity();
		assertEquals(10000, patient.getId().longValue());
	}

	@Test
	public void testExposedInfantsWithSummaryPageNoEncounters() {
		List<RuleResult<Patient>> result = incompleteExposedInfantInformation.exposedInfantsWithSummaryPageNoEncounters();
		assertNotNull(result);
		assertEquals(1, result.size());
		Patient patient = result.get(0).getEntity();
		assertEquals(10001, patient.getId().longValue());
	}
	
	@Test
	public void testExposedInfantsWithNoMotherARTNumber() {
		List<RuleResult<Patient>> result = incompleteExposedInfantInformation.exposedInfantsWithNoMotherARTNumber();
		assertNotNull(result);
		assertEquals(1, result.size());
		Patient patient = result.get(0).getEntity();
		assertEquals(10001, patient.getId().longValue());
	}
}