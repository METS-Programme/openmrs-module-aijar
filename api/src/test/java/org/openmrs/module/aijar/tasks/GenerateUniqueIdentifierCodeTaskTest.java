package org.openmrs.module.aijar.tasks;

import org.junit.Test;

/**
 * Test for generating the UIC task for patients without the UIC
 */
import java.util.Date;
import java.util.List;

import org.junit.Assert;
import org.junit.Before;
import org.openmrs.Encounter;
import org.openmrs.Patient;
import org.openmrs.PatientProgram;
import org.openmrs.Program;
import org.openmrs.api.ProgramWorkflowService;
import org.openmrs.api.context.Context;
import org.openmrs.module.aijar.api.AijarService;
import org.openmrs.module.aijar.metadata.core.Programs;
import org.openmrs.test.BaseModuleContextSensitiveTest;

public class GenerateUniqueIdentifierCodeTaskTest extends BaseModuleContextSensitiveTest {

    protected static final String UGANDAEMR_STANDARD_DATASET_XML = "org/openmrs/module/aijar/include/standardTestDataset.xml";
    private AijarService aijarService  = Context.getService(AijarService.class);

    @Before
    public void setup() throws Exception {
        executeDataSet(UGANDAEMR_STANDARD_DATASET_XML);
    }

    @Test
    public void shouldGenerateUICForPatientWithoutUIC() {
        /* patient without UIC
        * this is supposed to generate ids for all patients in dataset except patient with id 100000 */
        aijarService.generateUICForPatientsWithout();

    }

    @Test
    public void shouldGenerateUICForPatient() {

        /* patient with UIC
        * this is not supposed to generate for all patient except 100000 */
        aijarService.generateUICForPatientsWithout();

    }
}