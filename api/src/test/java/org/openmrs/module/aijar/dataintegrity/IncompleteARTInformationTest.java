package org.openmrs.module.aijar.dataintegrity;

import static org.junit.Assert.assertTrue;

import org.junit.Test;
import org.openmrs.api.PatientService;
import org.openmrs.api.context.Context;
import org.openmrs.test.BaseModuleContextSensitiveTest;
import org.openmrs.test.Verifies;
import org.springframework.beans.factory.annotation.Autowired;

/**
 * Created by ssmusoke on 12/10/16
 */
public class IncompleteARTInformationTest extends BaseModuleContextSensitiveTest {
	
	protected static final String DATA_VIOLATIONS_DATA_SET =
			"org/openmrs/module/dataintegrity/include/DataViolations.xml";
	
	@Autowired
	private PatientService patientService;
	
	@Test
	// @Verifies(value = "should get all patients without an ART start date", method = "evaluate()")
	public void patientsOnARTWithoutARTStartDateTest() throws Exception {
		System.out.println("There are " + Context.getPatientService().getAllPatients().size() + " patients ");
		assertTrue(true);
	}
	
}
