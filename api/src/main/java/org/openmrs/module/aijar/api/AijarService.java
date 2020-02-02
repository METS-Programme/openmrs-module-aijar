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
package org.openmrs.module.aijar.api;

import org.openmrs.Patient;
import org.openmrs.Person;
import org.openmrs.annotation.Authorized;
import org.openmrs.api.OpenmrsService;
import org.openmrs.util.OpenmrsConstants;
import org.openmrs.util.PrivilegeConstants;
import org.springframework.transaction.annotation.Transactional;

import java.util.Date;


/**
 * This service exposes module's core functionality. It is a Spring managed bean which is configured in moduleApplicationContext.xml.
 * <p>
 * It can be accessed only via Context:<br>
 * <code>
 * Context.getService(aijarService.class).someMethod();
 * </code>
 *
 * @see org.openmrs.api.context.Context
 */
@Transactional
public interface AijarService extends OpenmrsService {

	/*
	 * Link the infant with the A
	 *
	 */
	public void linkExposedInfantToMotherViaARTNumber(Patient infant, String motherARTNumber);
	public void linkExposedInfantToMotherViaARTNumber(Person infant, String motherARTNumber);
	public void setAlertForAllUsers(String alertMessage);

	/*
	 * This method generates Unique identification Code
	 * for all patients that do not have that id
	 * It is generated based on the person demographics
	 * submitted during patient registration
	 * This has been designed to run as an automatic task
	 * that run once a day for any patient that may not have the UIC already existing */

	/**
	 * Generates a patients UIC (Unique Identifier Code) out of patient demographics
	 * @param patient the patient to be generated a UIC for
	 * @return String the UIC that has been generated
	 */
	public String generatePatientUIC(Patient patient);

	/**
	 * This method when called generates and saves UIC (Unique Identifier Code) for all patients who dont have the UIC
	 */
	public void generateAndSaveUICForPatientsWithOut();

	/**
	 * This Method stops all active out patient visits
	 */
	public void stopActiveOutPatientVisits();

}