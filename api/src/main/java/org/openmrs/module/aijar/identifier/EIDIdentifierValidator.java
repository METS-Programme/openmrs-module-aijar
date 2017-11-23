package org.openmrs.module.aijar.identifier;

import java.util.Calendar;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.openmrs.patient.IdentifierValidator;
import org.openmrs.patient.UnallowedIdentifierException;

/**
 * Validate the Exposed Infant Diagnosis and Birth Cohort Number identifiers
 *
 * <ol>
 * <li>EXP Number format EXP12345</li>
 * <li>New Birth Cohort number MM/YY/XXX - 2 digits of the month, two digits of the year, and 3 numbers </li>
 * </ol>
 *
 *
 * Created by ssmusoke on 23/02/2016.
 */
public class EIDIdentifierValidator implements IdentifierValidator {
	
	/**
	 * @return The name of this validator
	 */
	public String getName() {
		return "Exposed Infant (EXP) Number validtor ";
	}

	/**
	 * @param identifier The Identifier to check.
	 * @return Whether this identifier is valid according to the validator.
	 * @throws UnallowedIdentifierException if the identifier contains unallowed characters or is
	 *                                      otherwise not appropriate for this validator.
	 */
	public boolean isValid(String identifier) throws UnallowedIdentifierException {
		// check the EXP number first
		String exp_regex = "[E][X][P][\\/][0-9][0-9][0-9][0-9]";

		Pattern pattern = Pattern.compile(exp_regex);
		Matcher matcher = pattern.matcher(identifier);
		if (matcher.matches()) {
			return true;
		}

		// validate the identifier as Birth Cohort Number
		return validateBirthCohortFormat(identifier);
	}

	/**
	 * @param validIdentifier The identifier prior to being given a check digit or other form
	 *                        of validation.
	 * @return The identifier after the check digit or other form of validation has been applied.
	 * @throws UnallowedIdentifierException if the identifier contains unallowed characters or is
	 *                                      otherwise not appropriate for this validator.
	 */
	public String getValidIdentifier(String validIdentifier) throws UnallowedIdentifierException {
		if (validIdentifier != null) {
			validIdentifier = validIdentifier.toUpperCase().trim();
		}
		return validIdentifier;
	}

	/**
	 * Validate the Birth Cohort identifier
	 *
	 * @param identifier
	 * @return whether the birth cohort identifier value is valid or not
	 * @throws UnallowedIdentifierException
	 */
	public boolean validateBirthCohortFormat(String identifier) throws UnallowedIdentifierException {
		// check that the length is 9
		if (identifier.length() < 9) {
			throw new UnallowedIdentifierException("The identifier is less than 9 characters including slashes");
		}
		if (identifier.length() > 9) {
			throw new UnallowedIdentifierException("The identifier is more than 9 characters");
		}
		// slashes at position 3 and 6
		if (identifier.charAt(2) != '/') {
			throw new UnallowedIdentifierException("Missing / at index 3");
		}
		if (identifier.charAt(5) != '/') {
			throw new UnallowedIdentifierException("Missing / at index 6");
		}
		// the first 2 digits are valid months
		int months = Integer.parseInt(identifier.substring(0, 2));
		if (months < 1) {
			throw new UnallowedIdentifierException("The months '" + months + "'  in the first two digits of the identifier "
					+ "are "
					+ "invalid");
		}
		if (months > 12) {
			throw new UnallowedIdentifierException("The months '" + months + "' in the first two digits of the identifier "
					+ "are "
					+ "invalid");
		}

		// position 4 and 5 are years greater than 14 (2014)
		int years = Integer.parseInt(identifier.substring(3, 5));
		// get the 2 digit representation of the current year
		int current_year = Calendar.getInstance().get(Calendar.YEAR) % 100;
		if (years < 15) {
			throw new UnallowedIdentifierException("The year '" + years + "' in the identifier is less than 15");
		}
		if (years > current_year) {
			throw new UnallowedIdentifierException("The year '" + years + "' in the identifier is greater than the "
					+ "current year");
		}
		// the last 3 digits are a valid number greater than 0
		int counter = Integer.parseInt(identifier.substring(6));
		if (counter > 0) {
			return true;
		} else {
			throw new UnallowedIdentifierException("The counter in the identifier is not 3 digits");
		}
	}

	/**
	 * @return A string containing all the characters allowed in this type of identifier validation.
	 */
	public String getAllowedCharacters() {
		return "0123456789EXP/";
	}
}
