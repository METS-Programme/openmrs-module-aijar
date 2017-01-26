package org.openmrs.module.aijar.page.controller;

import org.junit.Assert;
import org.junit.Before;
import org.junit.Test;
import org.openmrs.Concept;
import org.openmrs.Patient;
import org.openmrs.api.context.Context;
import org.openmrs.web.test.BaseModuleWebContextSensitiveTest;

import java.util.Calendar;
import java.util.Date;

/**
 * Created by lubwamasamuel on 19/15/2016.
 */
public class MarkPatientDeadTest extends BaseModuleWebContextSensitiveTest {

    Patient patient = new Patient();
    Concept concept = new Concept();
    Date dateOfDeath = new Date();


    @Before
    public void setRequirementsForTest() {
        patient = Context.getPatientService().getPatient(2);
        concept = Context.getConceptService().getConcept("unknown");
    }


    private Date modifyDate(int daysOff, Date date) {
        Calendar cal = Calendar.getInstance();
        cal.setTime(date);
        cal.add(Calendar.DATE, daysOff);
        Date modifiedDated = cal.getTime();
        return modifiedDated;
    }

    /**
     * This tests if the patient is marked as dead when given the right params
     */
    @Test
    public void shouldMarkPatientDeadSuccessfully() {
        MarkPatientDeadPageController markPatientDeadPageController = new MarkPatientDeadPageController();
        markPatientDeadPageController.post(concept.getUuid(), true, dateOfDeath, patient.getUuid());
        Assert.assertEquals(patient.getDead(), true);
        Assert.assertEquals(patient.getCauseOfDeath(), concept);
    }

    /**
     * This tests scenarios where date of death is not given.
     */
    @Test
    public void shouldNotMarkPatientDeadWhenDateIsNull() {
        MarkPatientDeadPageController markPatientDeadPageController = new MarkPatientDeadPageController();
        markPatientDeadPageController.post(concept.getUuid(), true, null, patient.getUuid());
        Assert.assertEquals(patient.getDeathDate(), null);
    }


    /**
     * This is to test scenarios where a cause of death is not given.
     */
    @Test
    public void shouldNotMarkPatientDeadWhenCauseOfDeathIsNull() {
        MarkPatientDeadPageController markPatientDeadPageController = new MarkPatientDeadPageController();
        markPatientDeadPageController.post("", true, dateOfDeath, patient.getUuid());
        Assert.assertEquals(patient.getDead(), false);
        Assert.assertNotEquals(patient.getCauseOfDeath(), concept);
    }

    /**
     * This tests if the patient is marked as dead when checkbox dead is not checked ie false
     */
    @Test
    public void shouldNotMarkPatientDeadWhenDeadIsFalse() {
        MarkPatientDeadPageController markPatientDeadPageController = new MarkPatientDeadPageController();
        markPatientDeadPageController.post(concept.getUuid(), false, dateOfDeath, patient.getUuid());
        Assert.assertEquals(patient.getDead(), false);
        Assert.assertNotEquals(patient.getCauseOfDeath(), concept);
    }


    /**
     * This tests scenarios when date of death is less than birth date
     */
    @Test
    public void deathDateShouldNotBeLessThanBirthDate() {
        MarkPatientDeadPageController markPatientDeadPageController = new MarkPatientDeadPageController();
        markPatientDeadPageController.post(concept.getUuid(), true, modifyDate(-30, patient.getBirthdate()), patient.getUuid());
        Assert.assertNull(patient.getDeathDate());
    }

    /**
     * This tests scenarios when date of death is greater than today
     */
    @Test
    public void deathDateShouldNotBeGreaterThanToday() {
        MarkPatientDeadPageController markPatientDeadPageController = new MarkPatientDeadPageController();
        markPatientDeadPageController.post(concept.getUuid(), true, modifyDate(30,dateOfDeath), patient.getUuid());
        Assert.assertNull(patient.getDeathDate());
    }

}