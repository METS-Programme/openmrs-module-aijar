package org.openmrs.module.aijar.page.controller;

import au.com.bytecode.opencsv.CSVReader;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.openmrs.ui.framework.UiUtils;
import org.openmrs.ui.framework.page.PageModel;
import org.openmrs.ui.framework.page.PageRequest;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import java.io.FileReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.Iterator;

/**
 * Data import from the EMTCT module
 */
@Controller
public class EmtctDataImportPageController {

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
                results = importEMTCTData(new CSVReader(new InputStreamReader(multipartFile.getInputStream())));
            } catch (IOException ioe) {
                log.error(ioe.getMessage(), ioe);
                throw new RuntimeException("Unable to process uploaded file ", ioe);
            }

            //


        }

        return results;
    }

    public String importEMTCTData(CSVReader reader) {


        return "done";
    }
}
