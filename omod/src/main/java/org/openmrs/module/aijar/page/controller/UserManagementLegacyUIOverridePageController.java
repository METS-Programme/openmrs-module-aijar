package org.openmrs.module.aijar.page.controller;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 * Created by ssmusoke on 11/05/2016.
 */
@Controller
public class UserManagementLegacyUIOverridePageController {
	protected final Log log = LogFactory.getLog(getClass());

	@RequestMapping({"admin/patients/index.htm", "/findPatient.htm"})
	public String overrideHomepage() {
		return "forward:/coreapps/findpatient/findPatient.page?app=coreapps.findPatient";
	}
}
