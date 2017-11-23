/**
 * The contents of this file are subject to the OpenMRS Public License
 * Version 1.0 (the "License"); you may not use this file except in
 * compliance with the License. You may obtain a copy of the License at
 * http://license.openmrs.org
 *
 * Software distributed under the License is distributed on an "AS IS"
 * basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See the
 * License for the specific language governing rights and limitations
 * under the License.
 *
 * Copyright (C) OpenMRS, LLC.  All Rights Reserved.
 */
package org.openmrs.module.aijar.api.impl;

import java.util.Arrays;
import java.util.List;

import org.openmrs.Patient;
import org.openmrs.Person;
import org.openmrs.Relationship;
import org.openmrs.User;
import org.openmrs.api.PatientService;
import org.openmrs.api.PersonService;
import org.openmrs.api.context.Context;
import org.openmrs.api.impl.BaseOpenmrsService;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.openmrs.module.aijar.api.AijarService;
import org.openmrs.module.aijar.api.db.AijarDAO;
import org.openmrs.module.aijar.metadata.core.PatientIdentifierTypes;
import org.openmrs.notification.Alert;
import org.springframework.beans.factory.annotation.Autowired;

/**
 * It is a default implementation of {@link AijarService}.
 */
public class AijarServiceImpl extends BaseOpenmrsService implements AijarService {
	
	protected final Log log = LogFactory.getLog(this.getClass());
	
	private AijarDAO dao;
	
	@Autowired
	private PatientService patientService;
	
	@Autowired
	private PersonService personService;
	
	/**
     * @param dao the dao to set
     */
    public void setDao(AijarDAO dao) {
	    this.dao = dao;
    }
    
    /**
     * @return the dao
     */
    public AijarDAO getDao() {
	    return dao;
    }
	
	@Override
	public void linkExposedInfantToMotherViaARTNumber(Person infant, String motherARTNumber) {
    	log.debug("Linking infant with ID " + infant.getPersonId() + " to mother with ART Number " + motherARTNumber);
		// find the mother by identifier
		List<Patient> mothers = patientService.getPatients(null, // name of the person
				motherARTNumber, //mother ART number
				Arrays.asList(Context.getPatientService().getPatientIdentifierTypeByUuid(
						PatientIdentifierTypes.HIV_CARE_NUMBER.uuid())), // ART Number Identifier type
				true); // match Identifier exactly
		if (mothers.size() != 0) {
			Person potentialMother = mothers.get(0).getPerson();
			// mothers have to be female and above 12 years of age
			if (potentialMother.getAge() > 12 & potentialMother.getGender().equals("F")) {
				Relationship relationship = new Relationship();
				relationship.setRelationshipType(
						personService.getRelationshipTypeByUuid("8d91a210-c2cc-11de-8d13-0010c6dffd0f"));
				relationship.setPersonA(potentialMother);
				relationship.setPersonB(infant);
				personService.saveRelationship(relationship);
				log.debug("Infant with ID " + infant.getPersonId() + " linked to mother with ID " + potentialMother.getPersonId());
			}
		}
	}
	
	@Override
	public void linkExposedInfantToMotherViaARTNumber(Patient infant, String motherARTNumber) {
    	linkExposedInfantToMotherViaARTNumber(infant.getPerson(), motherARTNumber);
	}
	public void setAlertForAllUsers(String alertMessage) {
		List<User> userList = Context.getUserService().getAllUsers();
		Alert alert = new Alert();
		for (User user : userList) {
			alert.addRecipient(user);
		}
		alert.setText(alertMessage);
		Context.getAlertService().saveAlert(alert);
	}
}