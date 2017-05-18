package org.openmrs.module.aijar.htmlformentry;

import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.when;

import java.text.SimpleDateFormat;
import java.util.List;

import org.junit.Assert;
import org.junit.Before;
import org.junit.Test;
import org.openmrs.Encounter;
import org.openmrs.Relationship;
import org.openmrs.api.PatientService;
import org.openmrs.api.context.Context;
import org.openmrs.module.aijar.htmlformenry.MotherToBabyPairLinkingPostSubmissionAction;
import org.openmrs.module.htmlformentry.FormEntryContext;
import org.openmrs.module.htmlformentry.FormEntrySession;
import org.openmrs.module.htmlformentry.FormSubmissionActions;
import org.openmrs.web.test.BaseModuleWebContextSensitiveTest;

/**
 * Test class for Mother to Baby Pair Linking
 */
public class MotherToBabyPairLinkingPostSubmissionActionTest extends BaseModuleWebContextSensitiveTest {
	private FormEntrySession mockFormEntrySession;
	
	private FormEntryContext mockFormEntryContext;
	
	private FormSubmissionActions mockFormSubmissionActions;
	
	private MotherToBabyPairLinkingPostSubmissionAction motherToBabyPairLinkingPostSubmissionAction;
	
	private PatientService mockPatientService;
	
	@Before
	public void setup() throws Exception {
		executeDataSet("org/openmrs/module/aijar/include/standardTestDataset.xml");
		executeDataSet("org/openmrs/module/aijar/include/exposedInfantData.xml");
		mockFormEntrySession = mock(FormEntrySession.class);
		mockFormEntryContext = mock(FormEntryContext.class);
		mockFormSubmissionActions = mock(FormSubmissionActions.class);
		mockPatientService = mock(PatientService.class);
		motherToBabyPairLinkingPostSubmissionAction = new MotherToBabyPairLinkingPostSubmissionAction();
		
		when(mockFormEntrySession.getSubmissionActions()).thenReturn(mockFormSubmissionActions);
		when(mockFormEntrySession.getContext()).thenReturn(mockFormEntryContext);
		when(mockFormEntrySession.getContext().getMode()).thenReturn(FormEntryContext.Mode.ENTER);
		
	}
	
	@Test
	public void shouldLinkBabyToMotherWithValidARTNumber() throws Exception {
		Encounter e = Context.getEncounterService().getEncounter(10005);
		when(mockFormEntrySession.getEncounter()).thenReturn(e);
		
		motherToBabyPairLinkingPostSubmissionAction.applyAction(mockFormEntrySession);
		
		List<Relationship> parents = Context.getPersonService().getRelationshipsByPerson(e.getPatient().getPerson());
		
		
		Assert.assertEquals("Infant linked to mother via ART number", parents.size(), 1);
		Assert.assertEquals("Mother ID is 7", 10007, parents.get(0).getPersonA().getPersonId().longValue() );
	}
	
	@Test
	public void shouldNotLinkBabyToMotherAgainIfAlreadyDone() throws Exception {
		Assert.assertTrue(true);
	}
	
	@Test
	public void shouldNotLinkBabyIfARTNumberBelongsToMan() throws Exception {
		Assert.assertTrue(true);
	}
	
	@Test
	public void shouldNotLinkBabyIfARTNumberIsForPersonBelow12Years() throws Exception {
		Assert.assertTrue(true);
	}
	
	@Test
	public void shouldNotLinkBabyIfARTNumberIsNotEntered() throws Exception {
		Encounter e = Context.getEncounterService().getEncounter(10001);
		when(mockFormEntrySession.getEncounter()).thenReturn(e);
		
		motherToBabyPairLinkingPostSubmissionAction.applyAction(mockFormEntrySession);
		
		List<Relationship> parents = Context.getPersonService().getRelationshipsByPerson(e.getPatient().getPerson());
		
		
		Assert.assertEquals("Infant with no mother ART number should not be linked", parents.size(), 0);
	}
	
	@Test
	public void shouldNotLinkBabyIfARTNumberDoesNotBelongToAnyPatientInSystem() throws Exception {
		Encounter e = Context.getEncounterService().getEncounter(10003);
		when(mockFormEntrySession.getEncounter()).thenReturn(e);
		
		motherToBabyPairLinkingPostSubmissionAction.applyAction(mockFormEntrySession);
		
		List<Relationship> parents = Context.getPersonService().getRelationshipsByPerson(e.getPatient().getPerson());
		
		
		Assert.assertEquals("Infant with ART number not belonging to anyone in the system should not be linked", parents.size(), 0);
	}
	
}
