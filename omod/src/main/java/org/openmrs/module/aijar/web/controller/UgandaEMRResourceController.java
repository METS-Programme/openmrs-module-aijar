package org.openmrs.module.aijar.web.controller;

import org.openmrs.module.aijar.AijarConstants;
import org.openmrs.module.webservices.rest.web.RestConstants;
import org.openmrs.module.webservices.rest.web.v1_0.controller.MainResourceController;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/rest/" + RestConstants.VERSION_1 + "/" + AijarConstants.UGANDAEMR_MODULE_ID)
public class UgandaEMRResourceController extends MainResourceController{
    @Override
    public String getNamespace() {
        return RestConstants.VERSION_1 + "/" + AijarConstants.UGANDAEMR_MODULE_ID;
    }
}