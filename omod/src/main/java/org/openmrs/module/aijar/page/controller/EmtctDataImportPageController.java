package org.openmrs.module.aijar.page.controller;

import au.com.bytecode.opencsv.CSVReader;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.openmrs.Encounter;
import org.openmrs.api.ConceptService;
import org.openmrs.api.EncounterService;
import org.openmrs.ui.framework.UiUtils;
import org.openmrs.ui.framework.page.PageModel;
import org.openmrs.ui.framework.page.PageRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import java.io.FileReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Iterator;
import java.util.List;

/**
 * Data import from the EMTCT module
 */
@Controller
public class EmtctDataImportPageController {

    @Autowired
    EncounterService encounterService;

    @Autowired
    ConceptService conceptService;

    protected final Log log = LogFactory.getLog(getClass());

    public void get(PageModel model,
                      UiUtils ui,
                      PageRequest pageRequest) {

    }

    @ResponseBody
    public String importData(MultipartHttpServletRequest request) {
        Iterator<String> fileNameIterator = request.getFileNames(); // Looping through the uploaded file names

        String results = "Nothing here yet";
        while (fileNameIterator.hasNext()) {
            String uploadedFileName = fileNameIterator.next();
            MultipartFile multipartFile = request.getFile(uploadedFileName);

            // process the file
            try {
                CSVReader reader = new CSVReader(new InputStreamReader(multipartFile.getInputStream()));
                List<String[]> lines = reader.readAll();
                List<Encounter> encounters = generateFollowUpEncounterFromEMTCTEcounterFromData(lines);

            } catch (IOException ioe) {
                log.error(ioe.getMessage(), ioe);
                throw new RuntimeException("Unable to process uploaded file ", ioe);
            }

            //


        }

        return results;
    }

    public List<Encounter> generateFollowUpEncounterFromEMTCTEcounterFromData(List<String[]> lines) throws IOException {
        List<Encounter> encounters = new ArrayList<Encounter>();

        for(String[] row : lines){
            Encounter e = new Encounter();
            e.setEncounterType(encounterService.getEncounterTypeByUuid("dc551efc-024d-4c40-aeb8-2147c4033778"));
            System.out.println("Printing values for ");
            System.out.println(Arrays.toString(row));
            // TODO: Daniel how do I create an Obs to add to an encounter, the order of the elements in the row are as follows
            // 0 -
            // 1 - Encounter and visit date
            // 2 - Type of care - ConceptID - 160530 Coded as EID - 160526, ANC - 160446, ART - 160524 (there are multiple selections allowed)
            // 3 - Outcome Concept ID Coded 165104 as 165106 - SMS Message Delivered, 165105 - SMS Message not delivered

            encounters.add(e);
        }


        return encounters;
    }
}
