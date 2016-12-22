package org.openmrs.module.aijar.page.controller;

import java.util.Date;

import org.junit.Before;
import org.junit.Test;
import org.openmrs.Concept;
import org.openmrs.Patient;
import org.openmrs.api.ConceptService;
import org.openmrs.api.PatientService;
import org.openmrs.api.context.Context;
import org.openmrs.api.impl.PatientServiceImpl;
import org.openmrs.web.test.BaseModuleWebContextSensitiveTest;
import org.openmrs.web.test.BaseWebContextSensitiveTest;

/**
 * Created by lubwamasamuel on 19/15/2016.
 */
public class MarkPatientDeadTest extends BaseModuleWebContextSensitiveTest {


    @Test
    public void shouldMarkPatientDeadSuccessfully() {
        MarkPatientDeadPageController markPatientDeadPageController = new MarkPatientDeadPageController();
        Date date = new Date();
        PatientService patientService = Context.getPatientService();
        Patient patient = new Patient();
        Concept concept=new Concept();
        concept=Context.getConceptService().getConcept("unknown");
        patient = patientService.getPatient(2);
        markPatientDeadPageController.post(concept.getUuid(), true, date, patient.getUuid().toString());
        assert patient.getDead().equals(true);
        assert patient.getCauseOfDeath().equals(concept);
    }
}
