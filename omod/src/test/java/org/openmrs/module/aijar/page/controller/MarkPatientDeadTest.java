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
    Date date = new Date();


    @Before
    public void setRequirementsForTest() {
        patient = Context.getPatientService().getPatient(2);
        concept = Context.getConceptService().getConcept("unknown");
    }


    private Date modifyPatientBirthDate(int daysOff,Date date){
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
        markPatientDeadPageController.post(concept.getUuid(), true, date, patient.getUuid().toString());
        Assert.assertEquals(patient.getDead(), true);
        Assert.assertEquals(patient.getCauseOfDeath(), concept);
    }

    /**
     * This tests if the patient is marked as dead when date is null
     */
    @Test
    public void shouldNotMarkPatientDeadWhenDateIsNull() {
        MarkPatientDeadPageController markPatientDeadPageController = new MarkPatientDeadPageController();
        markPatientDeadPageController.post(concept.getUuid(), true, null, patient.getUuid().toString());
        Assert.assertEquals(patient.getDead(), false);
        Assert.assertNotEquals(patient.getCauseOfDeath(), concept);
    }


    /**
     * This tests if the patient is marked as dead when cause of death is null
     */
    @Test
    public void shouldNotMarkPatientDeadWhenCauseOfDeathIsNull() {
        MarkPatientDeadPageController markPatientDeadPageController = new MarkPatientDeadPageController();
        markPatientDeadPageController.post("null", true, date, patient.getUuid().toString());
        Assert.assertEquals(patient.getDead(), false);
        Assert.assertNotEquals(patient.getCauseOfDeath(), concept);
    }

    /**
     * This tests if the patient is marked as dead when checkbox dead is not checked ie false
     */
    @Test
    public void shouldNotMarkPatientDeadWhenDeadIsFalse() {
        MarkPatientDeadPageController markPatientDeadPageController = new MarkPatientDeadPageController();
        markPatientDeadPageController.post(concept.getUuid(), false, date, patient.getUuid().toString());
        Assert.assertEquals(patient.getDead(), false);
        Assert.assertNotEquals(patient.getCauseOfDeath(), concept);
    }



    /**
     * This tests if the patient is marked as dead when patient is null
     */
    @Test
    public void shouldNotMarkPatientDeadWhenDPatientIsNull() {
        MarkPatientDeadPageController markPatientDeadPageController = new MarkPatientDeadPageController();
        Assert.assertEquals(markPatientDeadPageController.post("null", false, null, null),null);
    }


    /**
     * This tests if the patient is marked as dead when checkbox dead is not checked ie false
     */
    @Test
    public void shouldNotMarkPatientDeadWhenNoParameter() {
        MarkPatientDeadPageController markPatientDeadPageController = new MarkPatientDeadPageController();
        Assert.assertEquals(markPatientDeadPageController.post("null", false, null, null),null);
    }

    /**
     * This tests if the patient is marked as dead when checkbox dead is not checked ie false
     */
    @Test
    public void deathDateShouldNotBeLessThanBirthDate() {
        MarkPatientDeadPageController markPatientDeadPageController = new MarkPatientDeadPageController();
        markPatientDeadPageController.post(concept.getUuid(), true, modifyPatientBirthDate(-30,patient.getBirthdate()), patient.getUuid().toString());
        Assert.assertNull(patient.getDeathDate());
    }


    /**
     * This tests if the death Death is not greater than today's Date
     */
    @Test
    public void deathDateShouldNotBeGreaterThanToday() {
        MarkPatientDeadPageController markPatientDeadPageController = new MarkPatientDeadPageController();
        markPatientDeadPageController.post(concept.getUuid(), true, modifyPatientBirthDate(30,date), patient.getUuid().toString());
        Assert.assertNull(patient.getDeathDate());
    }
}
