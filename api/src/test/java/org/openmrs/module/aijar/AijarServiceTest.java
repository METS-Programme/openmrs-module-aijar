package org.openmrs.module.aijar;

import org.junit.Test;

/**
 * Test for generating the UIC task for patients without the UIC
 */
import java.util.Date;
import java.util.List;

import org.junit.Assert;
import org.junit.Before;
import org.openmrs.*;
import org.openmrs.api.PatientService;
import org.openmrs.api.ProgramWorkflowService;
import org.openmrs.api.context.Context;
import org.openmrs.module.aijar.api.AijarService;
import org.openmrs.module.aijar.metadata.core.Programs;
import org.openmrs.test.BaseModuleContextSensitiveTest;
import org.springframework.beans.factory.annotation.Autowired;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotNull;

public class AijarServiceTest extends BaseModuleContextSensitiveTest {

    protected static final String UGANDAEMR_STANDARD_DATASET_XML = "org/openmrs/module/aijar/include/standardTestDataset.xml";


    @Before
    public void setup() throws Exception {
        executeDataSet(UGANDAEMR_STANDARD_DATASET_XML);
    }

    @Test
    public void generateAndSaveUICForPatientsWithOut_shouldGenerateUICForPatientWithoutUIC() {
        AijarService aijarService = Context.getService(AijarService.class);

        List listBeforeGeneration = Context.getAdministrationService().executeSQL("select * from patient inner join patient_identifier pi on (patient.patient_id = pi.patient_id)  inner join patient_identifier_type pit on (pi.identifier_type = pit.patient_identifier_type_id) where pit.uuid='877169c4-92c6-4cc9-bf45-1ab95faea242'", true);

        Assert.assertEquals(0, listBeforeGeneration.size());

        aijarService.generateAndSaveUICForPatientsWithOut();

        List listAfterGeneration = Context.getAdministrationService().executeSQL("select * from patient inner join patient_identifier pi on (patient.patient_id = pi.patient_id)  inner join patient_identifier_type pit on (pi.identifier_type = pit.patient_identifier_type_id) where pit.uuid='877169c4-92c6-4cc9-bf45-1ab95faea242'", true);

        Assert.assertNotEquals(0,listAfterGeneration.size());
    }

    @Test
    public void generatePatientUIC_shouldGenerateUIC() {
        AijarService aijarService = Context.getService(AijarService.class);
        PatientService patientService = Context.getPatientService();
        Patient patient = patientService.getPatient(10003);

        String uniqueIdentifierCode= null;
        uniqueIdentifierCode = aijarService.generatePatientUIC(patient);

        assertEquals("X-0117-1-01140411011213",uniqueIdentifierCode);
//        assertEquals("X-1017-1-10011311092319",uniqueIdentifierCode); for patient 10001

    }

    @Test
    public void isTransferredIn_ShouldReturnFalseWhenPatientIsNotTransferIn() {
        AijarService aijarService=Context.getService(AijarService.class);
        Patient patient=Context.getPatientService().getPatient(10008);
        Assert.assertFalse(aijarService.isTransferredIn(patient,new Date()));

    }

    @Test
    public void isTransferredOut_ShouldReturnFalseWhenPatientIsNotTransferredOut() {
        AijarService aijarService=Context.getService(AijarService.class);
        Patient patient=Context.getPatientService().getPatient(10008);
        Assert.assertFalse(aijarService.isTransferredIn(patient,new Date()));
    }



}