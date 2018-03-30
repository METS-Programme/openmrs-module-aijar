package org.openmrs.module.aijar.page.controller;

import au.com.bytecode.opencsv.CSVReader;
import org.junit.Before;
import org.junit.Test;
import org.openmrs.Encounter;
import org.openmrs.EncounterType;
import org.openmrs.Patient;
import org.openmrs.api.EncounterService;
import org.openmrs.parameter.EncounterSearchCriteria;
import org.openmrs.web.test.BaseModuleWebContextSensitiveTest;
import org.springframework.beans.factory.annotation.Autowired;

import java.io.FileReader;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.List;

import static org.junit.Assert.assertEquals;

/**
 * Tests importation of data from the EMTCT module
 */
public class EmtctDataImportPageControllerTest extends BaseModuleWebContextSensitiveTest  {

    @Autowired
    private EmtctDataImportPageController controller;

    @Autowired
    private EncounterService encounterService;


    @Before
    public void setup() throws Exception {
        executeDataSet("org/openmrs/module/aijar/include/standardTestDataset.xml");
    }

    @Test
    public void shouldCreateObsFromUploadedFile() throws Exception {
        CSVReader reader = new CSVReader(new InputStreamReader(this.getClass().getClassLoader().getResourceAsStream("org/openmrs/module/aijar/include/emtctmoduleimport.csv")));

        List<EncounterType> encounterTypes = new ArrayList<EncounterType>();
        encounterTypes.add(encounterService.getEncounterTypeByUuid("dc551efc-024d-4c40-aeb8-2147c4033778")); // Followup Visit Encounter Type

        controller.importEMTCTData(reader);

        // check that there followup encounters for the patients included in the file
        Patient infant = new Patient(10008);
        EncounterSearchCriteria infantSearch = new EncounterSearchCriteria(infant, null, null, null, null, null, encounterTypes, null, null, null, false);
        List<Encounter> infantEncounters = encounterService.getEncounters(infantSearch);
        assertEquals(1, infantEncounters.size());


        Patient mother = new Patient(7);
        EncounterSearchCriteria patientSearch = new EncounterSearchCriteria(mother, null, null, null, null, null, encounterTypes, null, null, null, false);
        List<Encounter> motherEncounters = encounterService.getEncounters(patientSearch);
        assertEquals(1, infantEncounters.size());


        assertEquals(reader.readAll().size(), 3);
    }
}
