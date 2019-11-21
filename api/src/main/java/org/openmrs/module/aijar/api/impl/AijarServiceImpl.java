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

import java.util.*;

import org.openmrs.Patient;
import org.openmrs.Person;
import org.openmrs.Relationship;
import org.openmrs.User;
import org.openmrs.EncounterType;
import org.openmrs.Encounter;
import org.openmrs.Obs;
import org.openmrs.Concept;
import org.openmrs.api.EncounterService;
import org.openmrs.api.PatientService;
import org.openmrs.api.PersonService;
import org.openmrs.api.context.Context;
import org.openmrs.api.impl.BaseOpenmrsService;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.openmrs.module.aijar.AijarConstants;
import org.openmrs.module.aijar.api.AijarService;
import org.openmrs.module.aijar.api.db.AijarDAO;
import org.openmrs.module.aijar.metadata.core.PatientIdentifierTypes;
import org.openmrs.notification.Alert;
import org.openmrs.parameter.EncounterSearchCriteria;
import org.openmrs.parameter.EncounterSearchCriteriaBuilder;
import org.springframework.beans.factory.annotation.Autowired;

import static org.openmrs.module.aijar.AijarConstants.*;
import static org.openmrs.module.aijar.metadata.core.EncounterTypes.TRANSFER_IN;
import static org.openmrs.module.aijar.metadata.core.EncounterTypes.TRANSFER_OUT;

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
                Arrays.asList(Context.getPatientService().getPatientIdentifierTypeByUuid(PatientIdentifierTypes.HIV_CARE_NUMBER.uuid())), // ART Number Identifier type
                true); // match Identifier exactly
        if (mothers.size() != 0) {
            Person potentialMother = mothers.get(0).getPerson();
            // mothers have to be female and above 12 years of age
            if (potentialMother.getAge() > 12 & potentialMother.getGender().equals("F")) {
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
     * @see org.openmrs.module.aijar.api.AijarService#transferredOut(org.openmrs.Patient,java.util.Date)
     */
    @Override
    public Map transferredOut(Patient patient, Date date) {
        Map map = new HashMap();
        EncounterService encounterService = Context.getEncounterService();
        List<EncounterType> encounterTypes = encounterService.findEncounterTypes(TRANSFER_OUT.name());

        EncounterSearchCriteria encounterSearchCriteria = new EncounterSearchCriteriaBuilder().setPatient(patient).setIncludeVoided(false).setEncounterTypes(encounterTypes).setFromDate(date).createEncounterSearchCriteria();

        List<Encounter> encounters = encounterService.getEncounters(encounterSearchCriteria);

        Collections.reverse(encounters);
        if (encounters.size() > 0) {
            Encounter encounter = encounters.get(0);
            if (encounters.get(0).getEncounterType() == Context.getEncounterService().getEncounterType(TRANSFER_OUT.name())) {
                List<Encounter> encounters1 = new ArrayList<>();
                List<Concept> transferOutPlaceConceptList = new ArrayList<>();
                transferOutPlaceConceptList.add(Context.getConceptService().getConcept(AijarConstants.TRANSFER_OUT_PLACE_CONCEPT_ID));
                encounters1.add(encounter);
                map.put(PATIENT_TRANSERRED_OUT, true);
                map.put(PATIENT_TRANSFERED_OUT_DATE, encounter.getEncounterDatetime());
                List<Person> people = new ArrayList<>();
                people.add(patient.getPerson());
                List<Obs> obsList = Context.getObsService().getObservations(people, encounters, transferOutPlaceConceptList, null, null, null, null, 1, null, null, null, false);
                if (obsList.size() > 0) {
                    map.put(PATIENT_TRANSFERED_OUT_LOCATION, obsList.get(0).getValueText());
                }
            } else {
                map.put(PATIENT_TRANSERRED_OUT, false);
            }
        } else {
            map.put(PATIENT_TRANSERRED_OUT, false);
        }
        return map;
    }

    /**
     * @see org.openmrs.module.aijar.api.AijarService#transferredIn(org.openmrs.Patient,java.util.Date)
     */
    @Override
    public Map transferredIn(Patient patient, Date date) {
        Map map = new HashMap();

        EncounterService encounterService = Context.getEncounterService();

        Collection<EncounterType> encounterTypes = encounterService.findEncounterTypes(TRANSFER_IN.name());

        EncounterSearchCriteria encounterSearchCriteria = new EncounterSearchCriteriaBuilder().setPatient(patient).setIncludeVoided(false).setEncounterTypes(encounterTypes).setFromDate(date).createEncounterSearchCriteria();

        List<Encounter> encounters = encounterService.getEncounters(encounterSearchCriteria);

        if (encounters.size() > 0) {
            map.put(PATIENT_TRANSERRED_IN, true);
            List<Concept> transferInPlaceConceptList = new ArrayList<>();
            List<Person> people = new ArrayList<>();
            people.add(patient.getPerson());
            transferInPlaceConceptList.add(Context.getConceptService().getConcept(TRANSFER_IN_FROM_PLACE_CONCEPT_ID));
            List<Obs> obsList = Context.getObsService().getObservations(people, encounters, transferInPlaceConceptList, null, null, null, null, 1, null, null, null, false);
            if (obsList.size() > 0) {
                map.put(PATIENT_TRANSFERED_IN_LOCATION, obsList.get(0).getValueText());
                map.put(PATIENT_TRANSFERED_IN_DATE, obsList.get(0).getEncounter().getEncounterDatetime());
            } else {
                map.put(PATIENT_TRANSFERED_IN_DATE, encounters.get(0).getEncounterDatetime());
            }
        } else {
            map.put(PATIENT_TRANSERRED_IN, false);
        }
        return map;
    }

    public boolean isTransferredOut(Patient patient, Date date) {
        return (boolean) transferredOut(patient, date).get(PATIENT_TRANSERRED_OUT);
    }

    @Override
    public boolean isTransferredIn(Patient patient, Date date) {
        return (boolean) transferredOut(patient, date).get(PATIENT_TRANSERRED_OUT);
    }

    @Override
    public List<Encounter> getTransferHistory(Patient patient) {
        Map map = new HashMap();

        EncounterService encounterService = Context.getEncounterService();

        Collection<EncounterType> encounterTypes = encounterService.findEncounterTypes(TRANSFER_IN.name());
        encounterTypes.addAll(encounterService.findEncounterTypes(TRANSFER_OUT.name()));

        EncounterSearchCriteria encounterSearchCriteria = new EncounterSearchCriteriaBuilder().setPatient(patient).setIncludeVoided(false).setEncounterTypes(encounterTypes).createEncounterSearchCriteria();

        List<Encounter> encounters = encounterService.getEncounters(encounterSearchCriteria);

        return encounters;
    }
}