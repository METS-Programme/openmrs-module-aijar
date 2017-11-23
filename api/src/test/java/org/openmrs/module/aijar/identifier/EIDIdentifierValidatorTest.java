package org.openmrs.module.aijar.identifier;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertTrue;

import java.util.Calendar;

import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.openmrs.patient.UnallowedIdentifierException;

import junitparams.JUnitParamsRunner;
import junitparams.Parameters;

/**
 * Created by ssmusoke on 23/02/2016.
 */
@RunWith(JUnitParamsRunner.class)
public class EIDIdentifierValidatorTest {

	private EIDIdentifierValidator eidIdentifierValidator;

	@Before
	public void initialize() {
		eidIdentifierValidator = new EIDIdentifierValidator();
	}

	@Test
	@Parameters
	public void isValid(String identifier,
	                    boolean expectedValidationResult,
	                    String message) {
		try {
			assertEquals(message, eidIdentifierValidator.isValid(identifier), expectedValidationResult);
		}
		catch (UnallowedIdentifierException e) {

			if (expectedValidationResult) {
				System.out.println(e.getMessage());
				// fail the test as this error is not expected
				assertFalse("message " + message + ": identifier " + identifier + " - exception " + e.toString(), true);
			} else {
				// expected error so pass the test
				assertTrue(true);
			}
		}

	}

	public Object[] parametersForIsValid() {
		int current_year = Calendar.getInstance().get(Calendar.YEAR) % 100;

		return new Object[] {
				"EXP/1234, true, Well formatted",
				"EXP12345, false, no forward slash",
				"EXP/12345, false, 5 digits instead of 4",
				"EXP/123, false, 3 digits instead of 4",
				"EXP/12, false, 2 digits instead of 4",
				"EXP/1, false, 1 digit instead of 4",
				"EXP/, false, 0 digits",
				"ABC/12345, false, suffix is not EXP",
				"01/16/001, true, Correct Birth Cohort in 2016",
				"11/15/071, true, Correct Birth Cohort in 2015",
				"03/14/987, false, invalid year 2014",
				"05/13/078, false, invalid year 2013",
				"05/" + (current_year + 1) + "/078, false, invalid year " + (current_year + 1),
				"00/16/001, false,  invalid month 00",
				"13/16/001, false, invalid month 13",
				"01/16/01, false, two digits for counter",
				"01/16/1, false, one digits",
				"01/16/, false, no digits",
				"01/16/000, false, 000 as the identifier",
				"01/00/01, false, invalid year 00",
				"1/01/001, false, one digit for month",
				"01/4/001, false, one digit for year"
		};
	}
	
}
