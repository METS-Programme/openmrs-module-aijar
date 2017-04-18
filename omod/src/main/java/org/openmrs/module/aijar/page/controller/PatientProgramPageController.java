package org.openmrs.module.aijar.page.controller;

import java.util.List;

import org.openmrs.Patient;
import org.openmrs.PatientProgram;
import org.openmrs.api.ProgramWorkflowService;
import org.openmrs.module.appui.UiSessionContext;
import org.openmrs.ui.framework.annotation.SpringBean;
import org.openmrs.ui.framework.page.PageModel;
import org.springframework.web.bind.annotation.RequestParam;

public class PatientProgramPageController {
	
	public void controller(PageModel model, 
	                       @RequestParam(required = false, value = "patientId") Patient patient,
	                       @SpringBean("programWorkflowService") ProgramWorkflowService service,
	                       UiSessionContext emrContext) {

		emrContext.requireAuthentication();
		
		List<PatientProgram> programs = service.getPatientPrograms(patient, null, null, null, null, null, false);
		model.addAttribute("programs", programs);
	}
}
