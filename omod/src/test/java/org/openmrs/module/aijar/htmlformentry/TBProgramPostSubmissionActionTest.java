package org.openmrs.module.aijar.htmlformentry;

import org.junit.After;
import org.junit.Assert;
import org.junit.Before;
import org.junit.Test;
import org.openmrs.Concept;
import org.openmrs.Encounter;
import org.openmrs.EncounterType;
import org.openmrs.Form;
import org.openmrs.Obs;
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

import javax.servlet.http.HttpServletRequest;
import java.util.Date;
import java.util.List;

import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.when;

/**
 * Tests patient enrollment into the TB program
 */
public class TBProgramPostSubmissionActionTest extends BaseModuleWebContextSensitiveTest {
	
	protected static final String UGANDAEMR_STANDARD_DATASET_XML = "org/openmrs/module/aijar/include/standardTestDataset.xml";
	
	private String xml = "<htmlform>\n"
			+ "Date: <encounterDate default='today'/>\n"
			+ "Location: <encounterLocation default='1'/>\n"
			+ "Provider: <encounterProvider role='Provider' />\n"	
			+ "<obs conceptId=\"e44c8c4c-db50-4d1e-9d6e-092d3b31cfd6\" answerConceptIds=\"5240,90306\" />\n"
			+ "<postSubmissionAction class='org.openmrs.module.aijar.htmlformentry.TBProgramPostSubmissionAction'/>\n"
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
	public void shouldEnrollPatientIntoTBProgramWhenNewTBFormIsSubmitted() throws Exception {
		Patient patient = new Patient(6);
		ProgramWorkflowService service = Context.getService(ProgramWorkflowService.class);
		Program tbProgram = service.getProgramByUuid(Programs.TB_PROGRAM.uuid());
		
		//should not be enrolled yet in the tb program
		List<PatientProgram> patientPrograms = service.getPatientPrograms(patient, tbProgram, null, null, null, null, false);
		Assert.assertEquals(0, patientPrograms.size());
			
		//prepare and submit an html form to enroll patient in tb program
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
        
        //should be enrolled in tb program
        patientPrograms = service.getPatientPrograms(patient, tbProgram, null, null, null, null, false);
		Assert.assertEquals(1, patientPrograms.size());
		Assert.assertNull(patientPrograms.get(0).getDateCompleted());
	}
	
	@Test
	public void shouldEnrollPatientInTBProgramOnlyWhenExpectedConditionsAreFullFilled() throws Exception {
		Patient patient = new Patient(2);
		Encounter encounter = new Encounter();
		encounter.setEncounterDatetime(new Date());
		
		TBProgramPostSubmissionAction postSubmissionAction = new TBProgramPostSubmissionAction();
		
		FormEntrySession formEntrySession = mock(FormEntrySession.class);
		FormEntryContext formEntryContext = mock(FormEntryContext.class);
		
		when(formEntrySession.getContext()).thenReturn(formEntryContext);
		when(formEntrySession.getPatient()).thenReturn(patient);
		when(formEntrySession.getEncounter()).thenReturn(encounter);
		
		ProgramWorkflowService programWorkflowService = Context.getService(ProgramWorkflowService.class);
		Program tbProgram = programWorkflowService.getProgramByUuid(Programs.TB_PROGRAM.uuid());
		
		List<PatientProgram> programs = programWorkflowService.getPatientPrograms(patient, tbProgram, null, null, null, null,
		    false);
		Assert.assertEquals(0, programs.size());
		
		//try enroll in vew mode
		when(formEntrySession.getContext().getMode()).thenReturn(FormEntryContext.Mode.VIEW);
		postSubmissionAction.applyAction(formEntrySession);
		programs = programWorkflowService.getPatientPrograms(patient, tbProgram, null, null, null, null, false);
		Assert.assertEquals(0, programs.size()); //should not enroll in view mode
		
		//try enroll in edit mode
		when(formEntrySession.getContext().getMode()).thenReturn(FormEntryContext.Mode.EDIT);
		postSubmissionAction.applyAction(formEntrySession);
		programs = programWorkflowService.getPatientPrograms(patient, tbProgram, null, null, null, null, false);
		Assert.assertEquals(1, programs.size()); //should enroll in edit mode
		Assert.assertNull(programs.get(0).getDateCompleted());
		
		//try enroll in enter mode
		when(formEntrySession.getContext().getMode()).thenReturn(FormEntryContext.Mode.ENTER);
		postSubmissionAction.applyAction(formEntrySession);
		programs = programWorkflowService.getPatientPrograms(patient, tbProgram, null, null, null, null, false);
		Assert.assertEquals(1, programs.size()); //should enroll in enter mode
		Assert.assertNull(programs.get(0).getDateCompleted());
		
		//try enroll again for the same patient and program in enter mode
		postSubmissionAction.applyAction(formEntrySession);
		programs = programWorkflowService.getPatientPrograms(patient, tbProgram, null, null, null, null, false);
		Assert.assertEquals(1, programs.size()); //should not do duplicate enrollment
		Assert.assertNull(programs.get(0).getDateCompleted());
		
		//should exit patient from program, if treatment outcome is entered
		Obs obs = new Obs();
		Concept concept = Context.getConceptService().getConceptByUuid(TBProgramPostSubmissionAction.TREATMENT_OUTCOME_CONCEPT_UUID);
		obs.setConcept(concept);
		encounter.addObs(obs);
		new TBProgramPostSubmissionAction().applyAction(formEntrySession);
		programs = programWorkflowService.getPatientPrograms(patient, tbProgram, null, null, null, null, false);
		Assert.assertEquals(1, programs.size()); //should have exited program
		Assert.assertNotNull(programs.get(0).getDateCompleted());
	}
	
	@Test
	public void shouldExitPatientFromTBProgramWhenNewTBFormIsSubmittedWithTreatmentOutcome() throws Exception {
		Patient patient = new Patient(7);
		ProgramWorkflowService service = Context.getService(ProgramWorkflowService.class);
		Program tbProgram = service.getProgramByUuid(Programs.TB_PROGRAM.uuid());
		
		//should be enrolled in the tb program
		List<PatientProgram> patientPrograms = service.getPatientPrograms(patient, tbProgram, null, null, null, null, false);
		Assert.assertEquals(1, patientPrograms.size());
		Assert.assertNull(patientPrograms.get(0).getDateCompleted());
			
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
        when(request.getParameter("w8")).thenReturn(TBProgramPostSubmissionAction.TREATMENT_OUTCOME_CONCEPT_UUID);
        session.getSubmissionController().handleFormSubmission(session, request);
        
        session.applyActions();
        
        //should not be enrolled in tb program
        patientPrograms = service.getPatientPrograms(patient, tbProgram, null, null, null, null, false);
		Assert.assertEquals(1, patientPrograms.size());
		Assert.assertNotNull(patientPrograms.get(0).getDateCompleted());
	}
	
	@Test
	public void shouldExitPatientFromTBProgramWhenEditedFormIsSubmittedWithTreatmentOutcome() throws Exception {
		Patient patient = new Patient(7);
		ProgramWorkflowService service = Context.getService(ProgramWorkflowService.class);
		Program tbProgram = service.getProgramByUuid(Programs.TB_PROGRAM.uuid());
		
		//should be enrolled in the tb program
		List<PatientProgram> patientPrograms = service.getPatientPrograms(patient, tbProgram, null, null, null, null, false);
		Assert.assertEquals(1, patientPrograms.size());
		Assert.assertNull(patientPrograms.get(0).getDateCompleted());
		
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
        when(request.getParameter("w8")).thenReturn(TBProgramPostSubmissionAction.TREATMENT_OUTCOME_CONCEPT_UUID);
        session.getSubmissionController().handleFormSubmission(session, request);
        
        session.applyActions();
        
        //should not be enrolled in tb program
        patientPrograms = service.getPatientPrograms(patient, tbProgram, null, null, null, null, false);
		Assert.assertEquals(1, patientPrograms.size());
		Assert.assertNotNull(patientPrograms.get(0).getDateCompleted());
	}
	
	@Test
	public void shouldNotExitPatientFromTBProgramWhenNewTBFormIsSubmittedWithoutTreatmentOutcome() throws Exception {
		Patient patient = new Patient(7);
		ProgramWorkflowService service = Context.getService(ProgramWorkflowService.class);
		Program tbProgram = service.getProgramByUuid(Programs.TB_PROGRAM.uuid());
		
		//should be enrolled in the tb program
		List<PatientProgram> patientPrograms = service.getPatientPrograms(patient, tbProgram, null, null, null, null, false);
		Assert.assertEquals(1, patientPrograms.size());
		Assert.assertNull(patientPrograms.get(0).getDateCompleted());
			
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
        when(request.getParameter("w8")).thenReturn(null); //no outcome
        session.getSubmissionController().handleFormSubmission(session, request);
        
        session.applyActions();
        
        //should still be enrolled in tb program
        patientPrograms = service.getPatientPrograms(patient, tbProgram, null, null, null, null, false);
		Assert.assertEquals(1, patientPrograms.size());
		Assert.assertNull(patientPrograms.get(0).getDateCompleted());
	}
	
	@Test
	public void shouldNotExitPatientFromTBProgramWhenEditedFormIsSubmittedWithoutTreatmentOutcome() throws Exception {
		Patient patient = new Patient(7);
		ProgramWorkflowService service = Context.getService(ProgramWorkflowService.class);
		Program tbProgram = service.getProgramByUuid(Programs.TB_PROGRAM.uuid());
		
		//should be enrolled in the tb program
		List<PatientProgram> patientPrograms = service.getPatientPrograms(patient, tbProgram, null, null, null, null, false);
		Assert.assertEquals(1, patientPrograms.size());
		Assert.assertNull(patientPrograms.get(0).getDateCompleted());
		
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
		Assert.assertNull(patientPrograms.get(0).getDateCompleted());
	}
	
	@Test
	public void shouldEnrollAndExitPatientFromTBProgramWhenNewTBFormIsSubmittedWithTreatmentOutcome() throws Exception {
		Patient patient = new Patient(2);
		ProgramWorkflowService service = Context.getService(ProgramWorkflowService.class);
		Program tbProgram = service.getProgramByUuid(Programs.TB_PROGRAM.uuid());
		
		//should not be enrolled in the tb program
		List<PatientProgram> patientPrograms = service.getPatientPrograms(patient, tbProgram, null, null, null, null, false);
		Assert.assertEquals(0, patientPrograms.size());
			
		//prepare and submit an html form to enroll and exit patient from tb program
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
        when(request.getParameter("w8")).thenReturn(TBProgramPostSubmissionAction.TREATMENT_OUTCOME_CONCEPT_UUID);
        session.getSubmissionController().handleFormSubmission(session, request);
        
        session.applyActions();
        
		//should have enrolled and exited from tb program
        patientPrograms = service.getPatientPrograms(patient, tbProgram, null, null, null, null, false);
		Assert.assertEquals(1, patientPrograms.size());
		Assert.assertNotNull(patientPrograms.get(0).getDateCompleted());
	}
}
