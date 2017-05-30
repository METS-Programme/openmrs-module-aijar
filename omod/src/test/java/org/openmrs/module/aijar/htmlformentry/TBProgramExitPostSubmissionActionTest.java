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

public class TBProgramExitPostSubmissionActionTest extends BaseModuleWebContextSensitiveTest {
	
	protected static final String UGANDAEMR_STANDARD_DATASET_XML = "org/openmrs/module/aijar/include/standardTestDataset.xml";
	
	private String xml = "<htmlform>\n"
			+ "Date: <encounterDate default='today'/>\n"
			+ "Location: <encounterLocation default='1'/>\n"
			+ "Provider: <encounterProvider role='Provider' />\n"	
			+ "<obs conceptId=\"99423\" answerConceptIds=\"5240,90306\" />\n"
			+ "<postSubmissionAction class='org.openmrs.module.aijar.htmlformentry.TBProgramExitPostSubmissionAction'/>\n"
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
	public void shouldNotExitPatientFromTBProgramWhenNewTBFormIsSubmitted() throws Exception {
		Patient patient = new Patient(7);
		ProgramWorkflowService service = Context.getService(ProgramWorkflowService.class);
		Program tbProgram = service.getProgramByUuid(Programs.TB_PROGRAM.uuid());
		
		//should be enrolled in the tb program
		List<PatientProgram> patientPrograms = service.getPatientPrograms(patient, tbProgram, null, null, null, null, false);
		Assert.assertEquals(1, patientPrograms.size());
			
		//prepare and submit an html form to exit patient from tb program
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
        when(request.getParameter("w8")).thenReturn(TBProgramExitPostSubmissionAction.TREATMENT_OUTCOME_CONCEPT_ID + "");
        session.getSubmissionController().handleFormSubmission(session, request);
        
        session.applyActions();
        
        //should still be enrolled in tb program
        patientPrograms = service.getPatientPrograms(patient, tbProgram, null, null, null, null, false);
		Assert.assertEquals(1, patientPrograms.size());
	}
	
	@Test
	public void shouldExitPatientFromTBProgramWhenEditedFormIsSubmittedWithTreatmentOutcome() throws Exception {
		Patient patient = new Patient(7);
		ProgramWorkflowService service = Context.getService(ProgramWorkflowService.class);
		Program tbProgram = service.getProgramByUuid(Programs.TB_PROGRAM.uuid());
		
		//should be enrolled in the tb program
		List<PatientProgram> patientPrograms = service.getPatientPrograms(patient, tbProgram, null, null, null, null, false);
		Assert.assertEquals(1, patientPrograms.size());
		
		//prepare and submit an html form to exit patient from tb program
		HtmlForm htmlForm = new HtmlForm();
		htmlForm.setXmlData(xml);
		Form form = new Form(1);
		form.setEncounterType(new EncounterType(1));
		htmlForm.setForm(form);
		Encounter encounter = new Encounter();
		encounter.setDateCreated(new Date());
		encounter.setEncounterDatetime(new Date());
		FormEntrySession session = new FormEntrySession(patient, encounter, FormEntryContext.Mode.EDIT, htmlForm, new MockHttpSession());
        
        //getHtmlToDisplay() is called to generate necessary tag handlers and cache the form
        session.getHtmlToDisplay();
        
        //prepareForSubmit is called to set patient and encounter if specified in tags
        session.prepareForSubmit();
        
        HttpServletRequest request = mock(MockHttpServletRequest.class);
        when(request.getParameter("w1")).thenReturn("2017-04-01");
        when(request.getParameter("w8")).thenReturn(TBProgramExitPostSubmissionAction.TREATMENT_OUTCOME_CONCEPT_ID + "");
        session.getSubmissionController().handleFormSubmission(session, request);
        
        session.applyActions();
        
        //should not be enrolled in tb program
        patientPrograms = service.getPatientPrograms(patient, tbProgram, null, null, null, null, false);
		Assert.assertEquals(0, patientPrograms.size());
	}
	
	@Test
	public void shouldNotExitPatientFromTBProgramWhenEditedFormIsSubmittedWithoutTreatmentOutcome() throws Exception {
		Patient patient = new Patient(7);
		ProgramWorkflowService service = Context.getService(ProgramWorkflowService.class);
		Program tbProgram = service.getProgramByUuid(Programs.TB_PROGRAM.uuid());
		
		//should be enrolled in the tb program
		List<PatientProgram> patientPrograms = service.getPatientPrograms(patient, tbProgram, null, null, null, null, false);
		Assert.assertEquals(1, patientPrograms.size());
		
		//prepare and submit an html form to exit patient from tb program
		HtmlForm htmlForm = new HtmlForm();
		htmlForm.setXmlData(xml);
		Form form = new Form(1);
		form.setEncounterType(new EncounterType(1));
		htmlForm.setForm(form);
		Encounter encounter = new Encounter();
		encounter.setDateCreated(new Date());
		encounter.setEncounterDatetime(new Date());
		FormEntrySession session = new FormEntrySession(patient, encounter, FormEntryContext.Mode.EDIT, htmlForm, new MockHttpSession());
        
        //getHtmlToDisplay() is called to generate necessary tag handlers and cache the form
        session.getHtmlToDisplay();
        
        //prepareForSubmit is called to set patient and encounter if specified in tags
        session.prepareForSubmit();
        
        HttpServletRequest request = mock(MockHttpServletRequest.class);
        when(request.getParameter("w1")).thenReturn("2017-04-01");
        when(request.getParameter("w8")).thenReturn(null); //no outcome
        session.getSubmissionController().handleFormSubmission(session, request);
        
        session.applyActions();
        
        //should still be enrolled in tb program
        patientPrograms = service.getPatientPrograms(patient, tbProgram, null, null, null, null, false);
		Assert.assertEquals(1, patientPrograms.size());
	}
}
