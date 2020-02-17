/**
 * The contents of this file are subject to the OpenMRS Public License
 * Version 1.0 (the "License"); you may not use this file except in
 * compliance with the License. You may obtain a copy of the License at
 * http://license.openmrs.org
 * <p>
 * Software distributed under the License is distributed on an "AS IS"
 * basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See the
 * License for the specific language governing rights and limitations
 * under the License.
 * <p>
 * Copyright (C) OpenMRS, LLC.  All Rights Reserved.
 */
package org.openmrs.module.aijar.api.impl;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;
import java.util.Arrays;
import java.util.Date;
import java.util.Calendar;

import org.openmrs.*;
import org.openmrs.api.AdministrationService;
import org.openmrs.api.PatientService;
import org.openmrs.api.PersonService;
import org.openmrs.api.VisitService;
import org.openmrs.api.context.Context;
import org.openmrs.api.impl.BaseOpenmrsService;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.openmrs.module.aijar.api.AijarService;
import org.openmrs.module.aijar.api.db.AijarDAO;
import org.openmrs.module.aijar.metadata.core.Locations;
import org.openmrs.module.aijar.metadata.core.PatientIdentifierTypes;
import org.openmrs.notification.Alert;
import org.openmrs.util.OpenmrsUtil;
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
		List<PatientIdentifierType> artNumberPatientidentifierTypes = new ArrayList<>();
		artNumberPatientidentifierTypes.add(Context.getPatientService().getPatientIdentifierTypeByUuid(PatientIdentifierTypes.ART_PATIENT_NUMBER.uuid()));
		artNumberPatientidentifierTypes.add(Context.getPatientService().getPatientIdentifierTypeByUuid(PatientIdentifierTypes.HIV_CARE_NUMBER.uuid()));
		// find the mother by identifier
		List<Patient> mothers = patientService.getPatients(null, // name of the person
				motherARTNumber, //mother ART number
				artNumberPatientidentifierTypes, // ART Number and HIV Clinic number
				true); // match Identifier exactly
		if (mothers.size() != 0) {
			Person potentialMother = mothers.get(0).getPerson();
			// mothers have to be female and above 12 years of age
			if (potentialMother.getAge() != null && potentialMother.getAge() > 12 & potentialMother.getGender().equals("F")) {
				Relationship relationship = new Relationship();
				relationship.setRelationshipType(personService.getRelationshipTypeByUuid("8d91a210-c2cc-11de-8d13-0010c6dffd0f"));
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

	/**
	 * @see org.openmrs.module.aijar.api.AijarService#generatePatientUIC(org.openmrs.Patient)
	 */
	@Override
	public String generatePatientUIC(Patient patient) {
		String familyNameCode = "";
		String givenNameCode = "";
		String middleNameCode = "";
		String countryCode = "";
		String genderCode = "";
		Date dob = patient.getBirthdate();

		if (dob == null) {
			return null;
		}

		Calendar cal = Calendar.getInstance();
		cal.setTime(dob);
		String monthCode = "";
		String year = (cal.get(Calendar.YEAR) + "").substring(2, 4);


		if (cal.get(Calendar.MONTH) <= 8) {
			monthCode = "0" + (cal.get(Calendar.MONTH)+1);
		} else {
			monthCode = "" + (cal.get(Calendar.MONTH)+1);
		}

		if (patient.getGender().equals("F")) {
			genderCode = "2";
		} else {
			genderCode = "1";
		}

		if (patient.getPerson().getPersonAddress() != null && !patient.getPerson().getPersonAddress().getCountry().isEmpty()) {
			countryCode = patient.getPerson().getPersonAddress().getCountry().substring(0, 1);
		} else {
			countryCode = "X";
		}

		if (patient.getFamilyName()!=null&&!patient.getFamilyName().isEmpty()) {
			String firstLetter = replaceLettersWithNumber(patient.getFamilyName().substring(0, 1));
			String secondLetter = replaceLettersWithNumber(patient.getFamilyName().substring(1, 2));
			String thirdLetter = replaceLettersWithNumber(patient.getFamilyName().substring(2, 3));
			familyNameCode = firstLetter + secondLetter + thirdLetter;
		} else {
			familyNameCode = "X";
		}

		if (patient.getGivenName()!=null&& !patient.getGivenName().isEmpty()) {
			String firstLetter = replaceLettersWithNumber(patient.getGivenName().substring(0, 1));
			String secondLetter = replaceLettersWithNumber(patient.getGivenName().substring(1, 2));
			String thirdLetter = replaceLettersWithNumber(patient.getGivenName().substring(2, 3));
			givenNameCode = firstLetter + secondLetter + thirdLetter;
		} else {
			givenNameCode = "X";
		}

		if (patient.getMiddleName()!=null&&!patient.getMiddleName().isEmpty()) {
			middleNameCode = replaceLettersWithNumber(patient.getMiddleName().substring(0, 1));
		} else {
			middleNameCode = "X";
		}


		return countryCode + "-" + monthCode + year + "-" + genderCode + "-" + givenNameCode + familyNameCode + middleNameCode;
	}

	/**
	 * @see org.openmrs.module.aijar.api.AijarService#generateAndSaveUICForPatientsWithOut()
	 */
	@Override
	public void generateAndSaveUICForPatientsWithOut() {
		PatientService patientService = Context.getPatientService();
		List list = Context.getAdministrationService().executeSQL("select patient.patient_id from patient where patient_id NOT IN(select patient.patient_id from patient inner join patient_identifier pi on (patient.patient_id = pi.patient_id)  inner join patient_identifier_type pit on (pi.identifier_type = pit.patient_identifier_type_id) where pit.uuid='877169c4-92c6-4cc9-bf45-1ab95faea242')", true);
		PatientIdentifierType patientIdentifierType = patientService.getPatientIdentifierTypeByUuid("877169c4-92c6-4cc9-bf45-1ab95faea242");
		for (Object object : list) {
			Integer patientId = (Integer) ((ArrayList) object).get(0);
			Patient patient = patientService.getPatient(patientId);

			String uniqueIdentifierCode = generatePatientUIC(patient);

			if (uniqueIdentifierCode != null) {
				PatientIdentifier patientIdentifier = new PatientIdentifier();
				patientIdentifier.setIdentifier(uniqueIdentifierCode);
				patientIdentifier.setIdentifierType(patientIdentifierType);
				patientIdentifier.setLocation(Context.getLocationService().getLocationByUuid(Locations.PARENT.uuid()));
				patientIdentifier.setCreator(Context.getUserService().getUser(1));
				patientIdentifier.setPreferred(false);
				patientIdentifier.setDateCreated(new Date());
				patientIdentifier.setPatient(patient);
				try {
					patientService.savePatientIdentifier(patientIdentifier);
				}catch (Exception e){
					log.error("Failed to Save UIC for patient #"+patient.getPatientId(),e);
				}

			}
		}
	}

	/**
	 * This Method replaces letters with number position in the alphabet
	 * @param letter the alphabetical letter
	 * @return number that matches the alphabetical letter position
	 */
	private String replaceLettersWithNumber(String letter) {
		String numberToReturn = "X";

		switch (letter.toUpperCase()) {
			case "A":
				numberToReturn = "01";
				break;
			case "B":
				numberToReturn = "02";
				break;
			case "C":
				numberToReturn = "03";
				break;
			case "D":
				numberToReturn = "04";
				break;
			case "E":
				numberToReturn = "05";
				break;
			case "F":
				numberToReturn = "06";
				break;
			case "G":
				numberToReturn = "07";
				break;
			case "H":
				numberToReturn = "08";
				break;
			case "I":
				numberToReturn = "09";
				break;
			case "J":
				numberToReturn = "10";
				break;
			case "K":
				numberToReturn = "11";
				break;
			case "L":
				numberToReturn = "12";
				break;
			case "M":
				numberToReturn = "13";
				break;
			case "N":
				numberToReturn = "14";
				break;
			case "O":
				numberToReturn = "15";
				break;
			case "P":
				numberToReturn = "16";
				break;
			case "Q":
				numberToReturn = "17";
				break;
			case "R":
				numberToReturn = "18";
				break;
			case "S":
				numberToReturn = "19";
				break;
			case "T":
				numberToReturn = "20";
				break;
			case "U":
				numberToReturn = "21";
				break;
			case "V":
				numberToReturn = "22";
				break;
			case "W":
				numberToReturn = "23";
				break;
			case "X":
				numberToReturn = "24";
				break;
			case "Y":
				numberToReturn = "25";
				break;
			case "Z":
				numberToReturn = "26";
				break;

			default:
				numberToReturn = "X";
		}
		return numberToReturn;
	}
	/**
	 * @see org.openmrs.module.aijar.api.AijarService#stopActiveOutPatientVisits()
	 */
	public void stopActiveOutPatientVisits() {

		SimpleDateFormat formatter = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");

		SimpleDateFormat formatterExt = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

		String formattedDate = formatterExt.format(OpenmrsUtil.firstSecondOfDay(new Date()));

		//TODO Change AdministrationService to Autowired
		AdministrationService administrationService = Context.getAdministrationService();

		String visitTypeUUID =administrationService.getGlobalProperty("ugandaemr.autoCloseVisit.visitTypeUUID");

		VisitService visitService = Context.getVisitService();

		List activeVisitList = null;
		activeVisitList = administrationService.executeSQL("select visit.visit_id from visit inner join visit_type on (visit.visit_type_id = visit_type.visit_type_id)  where visit_type.uuid='"+visitTypeUUID+"' AND visit.date_stopped IS NULL AND  visit.date_started < '" + formattedDate + "'", true);

		for (Object object : activeVisitList) {
			ArrayList<Integer> integers = (ArrayList) object;
			Visit visit = visitService.getVisit(integers.get(0));
			try{
				visitService.endVisit(visit, OpenmrsUtil.getLastMomentOfDay(visit.getStartDatetime()));
			}catch (Exception e){
				log.error("Failed to auto close visit",e);
			}

		}
	}
}