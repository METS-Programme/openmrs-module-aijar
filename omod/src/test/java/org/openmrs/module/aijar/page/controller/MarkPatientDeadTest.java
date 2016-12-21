package org.openmrs.module.aijar.page.controller;

import org.junit.Test;
import org.openmrs.Patient;
import org.openmrs.api.PatientService;
import org.openmrs.api.context.Context;
import org.openmrs.api.impl.PatientServiceImpl;
import org.openmrs.module.aijar.page.UgandaEMRLoginPageRequestMapper;
import org.openmrs.module.metadatadeploy.api.MetadataDeployService;
import org.openmrs.module.metadatadeploy.api.impl.MetadataDeployServiceImpl;
import org.openmrs.ui.framework.page.PageRequest;
import org.openmrs.ui.framework.session.Session;
import org.openmrs.web.test.BaseModuleWebContextSensitiveTest;
import org.openmrs.web.test.BaseWebContextSensitiveTest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mock.web.MockHttpServletRequest;
import org.springframework.mock.web.MockHttpServletResponse;
import org.springframework.mock.web.MockHttpSession;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.util.Date;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertTrue;

/**
 * Created by lubwamasamuel on 19/15/2016.
 */
public class MarkPatientDeadTest extends BaseWebContextSensitiveTest {

    @Test
    public void markPatientDead() {
        MarkPatientDeadPageController markPatientDeadPageController = new MarkPatientDeadPageController();
        Date date = new Date();
        PatientService patientService = new PatientServiceImpl();
        Patient patient = new Patient();
        patient = patientService.getPatient(2);
        markPatientDeadPageController.post("unknown", true, date, patient.getUuid().toString());

    }
}
