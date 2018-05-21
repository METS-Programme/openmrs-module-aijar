package org.openmrs.module.aijar.identifier;

import junitparams.JUnitParamsRunner;
import junitparams.Parameters;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.openmrs.patient.UnallowedIdentifierException;

import static org.junit.Assert.*;

/**
 * Test NIN Validation Rule
 */
@RunWith(JUnitParamsRunner.class)
public class NINIdentifierValidatorTest {

    private NINIdentifierValidator ninIdentifierValidator;

    @Before
    public void initialize() {
        ninIdentifierValidator = new NINIdentifierValidator();
    }

    @Test
    @Parameters
    public void isValid(String identifier, boolean expectedValidationResult, String message) {
        try {
            assertEquals(message, ninIdentifierValidator.isValid(identifier), expectedValidationResult);
        } catch (UnallowedIdentifierException e) {

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
        return new Object[]{
                "CF8905210H3W5K, true, Well formatted female",
                "CM8905210H3W5K, true, Well formatted male",
                "CM8905210H3W5, false, Less than 14 characters",
                "CM8905210H3W5K7, false, More than 14 characters",
                "5M8905210H3W5K, false, Does not begin with alpha",
                "!M8905210H3W5K, false, Does not begin with alpha",
                "CX8905210H3W5K, false, Second character must be F or M",
                "CM8F05210H3W5K, false, Characters after first two must be 5 digits",
                ", true, Can be an empty string"
        };
    }

}
