package org.openmrs.module.aijar.api.impl;

import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import org.openmrs.Patient;
import org.openmrs.api.PatientService;
import org.openmrs.api.context.Context;
import org.openmrs.module.aijar.api.AijarService;
import org.openmrs.test.BaseModuleContextSensitiveTest;

import java.util.List;

import static org.junit.Assert.*;

public class AijarServiceImplTest extends BaseModuleContextSensitiveTest {
    protected static final String UGANDAEMR_STANDARD_DATASET_XML = "org/openmrs/module/aijar/include/standardTestDataset.xml";


    @Before
    public void setUp() throws Exception {
        executeDataSet(UGANDAEMR_STANDARD_DATASET_XML);
    }


    @Test
    public void generatePatientUIC_shouldGenerateUIC() {
        AijarService aijarService = Context.getService(AijarService.class);
        PatientService patientService = Context.getPatientService();
        Patient patient = patientService.getPatient(10003);

        String uniqueIdentifierCode= null;
        uniqueIdentifierCode = aijarService.generatePatientUIC(patient);

        assertNotNull(uniqueIdentifierCode);

    }
}