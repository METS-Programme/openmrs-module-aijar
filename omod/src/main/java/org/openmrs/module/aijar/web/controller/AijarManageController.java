/**
 * The contents of this file are subject to the OpenMRS Public License
 * Version 1.0 (the "License"); you may not use this file except in
 * compliance with the License. You may obtain a copy of the License at
 * http://license.openmrs.org
 *
 * Software distributed under the License is distributed on an "AS IS"
 * basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See the
 * License for the specific language governing rights and limitations
 * under the License.
 *
 * Copyright (C) OpenMRS, LLC.  All Rights Reserved.
 */
package org.openmrs.module.aijar.web.controller;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.openmrs.module.aijar.api.reporting.builder.common.SetupMissedAppointmentsReport;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.view.RedirectView;

/**
 * The main controller.
 */
@Controller
public class AijarManageController {
	
	protected final Log log = LogFactory.getLog(getClass());
	
	@RequestMapping(value = "/module/aijar/manageReports", method = RequestMethod.GET)
	public void manage(ModelMap model) {
	}
	
	@RequestMapping("/module/aijar/register_missedAppointmentsReport")
	public ModelAndView registerMissedAppointmentsList() throws Exception {
		new SetupMissedAppointmentsReport().setup();
		return new ModelAndView(new RedirectView("manageReports.form"));
	}
	
	@RequestMapping("/module/aijar/remove_missedAppointmentsReport")
	public ModelAndView removeMissedAppointmentsList() throws Exception {
		new SetupMissedAppointmentsReport().delete();
		return new ModelAndView(new RedirectView("manageReports.form"));
	}
}
