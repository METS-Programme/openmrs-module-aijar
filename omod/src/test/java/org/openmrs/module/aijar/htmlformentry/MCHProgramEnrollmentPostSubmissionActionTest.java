package org.openmrs.module.aijar.htmlformentry;

import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.when;

import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.junit.After;
import org.junit.Assert;
import org.junit.Before;
import org.junit.Test;
import org.openmrs.Encounter;
import org.openmrs.EncounterType;
import org.openmrs.Form;
import org.openmrs.Patient;
import org.openmrs.PatientProgram;
import org.openmrs.Program;
import org.openmrs.api.ProgramWorkflowService;
import org.openmrs.api.context.Context;
import org.openmrs.module.aijar.metadata.core.Programs;
import org.openmrs.module.htmlformentry.FormEntryContext;
import org.openmrs.module.htmlformentry.FormEntrySession;
import org.openmrs.module.htmlformentry.HtmlForm;
import org.openmrs.web.test.BaseModuleWebContextSensitiveTest;
import org.springframework.mock.web.MockHttpServletRequest;
import org.springframework.mock.web.MockHttpSession;

/**
 * Tests patient enrollment into the MCH program
 */
public class MCHProgramEnrollmentPostSubmissionActionTest extends BaseModuleWebContextSensitiveTest {
	
	protected static final String UGANDAEMR_STANDARD_DATASET_XML = "org/openmrs/module/aijar/include/standardTestDataset.xml";

	private String xml = "<htmlform>\n"
			+ "Date: <encounterDate default='today'/>\n"
			+ "Location: <encounterLocation default='1'/>\n"
			+ "Provider: <encounterProvider role='Provider' />\n"	
			+ "<obs conceptId=\"4\" />\n"
			+ "<postSubmissionAction class='org.openmrs.module.aijar.htmlformentry.MCHProgramEnrollmentPostSubmissionAction'/>\n"
			+ "<submit/>"
			+ "</htmlform>";
	
	@Before
	public void setup() throws Exception {
		executeDataSet(UGANDAEMR_STANDARD_DATASET_XML);
	}
	
	@After
	public void cleanup() throws Exception {
		deleteAllData();
	}
	
	@Test
	public void shouldEnrollPatientIntoMCHProgramWhenNewANCFormIsSubmitted() throws Exception {
		Patient patient = new Patient(6);
		ProgramWorkflowService service = Context.getService(ProgramWorkflowService.class);
		Program mchProgram = service.getProgramByUuid(Programs.MCH_PROGRAM.uuid());
		
		//should not be enrolled yet in the mch program
		List<PatientProgram> patientPrograms = service.getPatientPrograms(patient, mchProgram, null, null, null, null, false);
		Assert.assertEquals(0, patientPrograms.size());
			
		//prepare and submit an html form to enroll patient in mch program
		HtmlForm htmlForm = new HtmlForm();
		htmlForm.setXmlData(xml);
		Form form = new Form(1);
		form.setEncounterType(new EncounterType(1));
		htmlForm.setForm(form);
		FormEntrySession session = new FormEntrySession(patient, null, FormEntryContext.Mode.ENTER, htmlForm, new MockHttpSession());
        
        //getHtmlToDisplay() is called to generate necessary tag handlers and cache the form
        session.getHtmlToDisplay();
        
        //prepareForSubmit is called to set patient and encounter if specified in tags
        session.prepareForSubmit();
        
        HttpServletRequest request = mock(MockHttpServletRequest.class);
        when(request.getParameter("w1")).thenReturn("2017-04-01");
        session.getSubmissionController().handleFormSubmission(session, request);
        
        session.applyActions();
        
        //should be enrolled in mch program
        patientPrograms = service.getPatientPrograms(patient, mchProgram, null, null, null, null, false);
		Assert.assertEquals(1, patientPrograms.size());
		Assert.assertNull(patientPrograms.get(0).getDateCompleted());
	}
	
	@Test
	public void shouldEnrollPatientInMCHProgramOnlyWhenExpectedConditionsAreFullFilled() {
		
		Patient patient = new Patient(2);
		Encounter encounter = new Encounter();
		encounter.setEncounterDatetime(new Date());
		
		MCHProgramEnrollmentPostSubmissionAction postSubmissionAction = new MCHProgramEnrollmentPostSubmissionAction();
		
		FormEntrySession formEntrySession = mock(FormEntrySession.class);
		FormEntryContext formEntryContext = mock(FormEntryContext.class);
		
		when(formEntrySession.getContext()).thenReturn(formEntryContext);
		when(formEntrySession.getPatient()).thenReturn(patient);
		when(formEntrySession.getEncounter()).thenReturn(encounter);
		
		ProgramWorkflowService programWorkflowService = Context.getService(ProgramWorkflowService.class);
		Program mchProgram = programWorkflowService.getProgramByUuid(Programs.MCH_PROGRAM.uuid());
		
		List<PatientProgram> programs = programWorkflowService.getPatientPrograms(patient, mchProgram, null, null, null,
		    null, false);
		Assert.assertEquals(0, programs.size());
		
		//try enroll in vew mode
		when(formEntrySession.getContext().getMode()).thenReturn(FormEntryContext.Mode.VIEW);
		postSubmissionAction.applyAction(formEntrySession);
		programs = programWorkflowService.getPatientPrograms(patient, mchProgram, null, null, null, null, false);
		Assert.assertEquals(0, programs.size()); //should not enroll in view mode
		
		//try enroll in edit mode
		when(formEntrySession.getContext().getMode()).thenReturn(FormEntryContext.Mode.EDIT);
		postSubmissionAction.applyAction(formEntrySession);
		programs = programWorkflowService.getPatientPrograms(patient, mchProgram, null, null, null, null, false);
		Assert.assertEquals(0, programs.size()); //should not enroll in edit mode
		
		//try enroll in enter mode
		when(formEntrySession.getContext().getMode()).thenReturn(FormEntryContext.Mode.ENTER);
		postSubmissionAction.applyAction(formEntrySession);
		programs = programWorkflowService.getPatientPrograms(patient, mchProgram, null, null, null, null, false);
		Assert.assertEquals(1, programs.size()); //should enroll in enter mode
		Assert.assertNull(programs.get(0).getDateCompleted());
		
		//try enroll again for the same patient and program in enter mode
		postSubmissionAction.applyAction(formEntrySession);
		programs = programWorkflowService.getPatientPrograms(patient, mchProgram, null, null, null, null, false);
		Assert.assertEquals(1, programs.size()); //should not do duplicate enrollment
		Assert.assertNull(programs.get(0).getDateCompleted());
	}
}
