package org.openmrs.module.aijar.identifier;

import org.openmrs.patient.IdentifierValidator;
import org.openmrs.patient.UnallowedIdentifierException;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * Validate the NIN
 * <p>
 * <ol>
 * <li>NIN format CM131521234X</li>
 * </ol>
 * <p>
 * <p>
 */
public class NINIdentifierValidator implements IdentifierValidator {

    /**
     * @return The name of this validator
     */
    public String getName() {
        return "National ID Validator validator ";
    }

    /**
     * @param identifier The Identifier to check.
     * @return Whether this identifier is valid according to the validator.
     * @throws UnallowedIdentifierException if the identifier contains unallowed characters or is
     *                                      otherwise not appropriate for this validator.
     */
    public boolean isValid(String identifier) throws UnallowedIdentifierException {
        // check the NIN number first
        String exp_regex = "^$|^[A-Z][FM]\\d{5}([A-Z0-9]){7}$";
        Pattern pattern = Pattern.compile(exp_regex);
        Matcher matcher = pattern.matcher(identifier);
        return matcher.matches();

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
     * @return A string containing all the characters allowed in this type of identifier validation.
     */
    public String getAllowedCharacters() {
        return "0123456789ABCDEFGHIJKLMNOPQRSTUVWYZ";
    }
}
