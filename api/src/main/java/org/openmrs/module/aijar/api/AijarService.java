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

import org.openmrs.Encounter;
import org.openmrs.Patient;
import org.openmrs.Person;
import org.openmrs.api.OpenmrsService;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Map;

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

	/**
	 * Transfer out Information for patient
	 * @param patient
	 * @return Map
	 */
	public Map transferredOut(Patient patient);


	/**
	 * Transfer In Information for patient
	 * @param patient
	 * @return Map
	 */
	public Map transferredIn(Patient patient);

	/**
	 * Check if Patient is transferred out. This method depends on transferredOut(Patient patient) method
	 * @param patient
	 * @return boolean
	 */
	public boolean isTransferredOut(Patient patient);


	/**
	 * Check if Patient is a transfer in. This method depends on transferredIn(Patient patient) method
	 * @param patient
	 * @return boolean
	 */
	public boolean isTransferredIn(Patient patient);

	/**
	 * Transfer Information for patient
	 * @param patient
	 * @return Map
	 */
	public List<Encounter> getTransferHistory(Patient patient);
}