package org.openmrs.module.aijar.fragment;

import org.junit.After;
import org.junit.Assert;
import org.junit.Before;
import org.junit.Test;
import org.openmrs.Concept;
import org.openmrs.Patient;
import org.openmrs.api.context.Context;
import org.openmrs.module.aijar.fragment.controller.PatientStabilityFragmentController;
import org.openmrs.web.test.BaseModuleWebContextSensitiveTest;

import java.util.Date;

public class PatientStabilityFragmentControllerTest extends BaseModuleWebContextSensitiveTest {

    protected static final String UGANDAEMR_DSDM_DATASET_XML = "org/openmrs/module/aijar/include/dsdmTestDataSet.xml";

    @Before
    public void setup() throws Exception {
        executeDataSet(UGANDAEMR_DSDM_DATASET_XML);
    }

    @After
    public void cleanup() throws Exception {
        deleteAllData();
    }

    @Test
    public void testDateSubtraction() {
        PatientStabilityFragmentController patientStabilityFragmentController = new PatientStabilityFragmentController();

        patientStabilityFragmentController.getDateBefore(new Date(), -12,0);
    }

    @Test
    public void testGetArtStartDate() {
        Patient patient = new Patient(1393);
        PatientStabilityFragmentController patientStabilityFragmentController = new PatientStabilityFragmentController();
        Date artStartDate = patientStabilityFragmentController.getArtStartDate(patient);
        Assert.assertNotNull(artStartDate);
        Assert.assertEquals(artStartDate.toString(),"2013-02-06 00:00:00.0");
    }
}
