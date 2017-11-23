package org.openmrs.module.aijar.htmlformentry;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.openmrs.Obs;
import org.openmrs.Patient;
import org.openmrs.PatientIdentifierType;
import org.openmrs.Person;
import org.openmrs.Relationship;
import org.openmrs.api.ConceptService;
import org.openmrs.api.PatientService;
import org.openmrs.api.PersonService;
import org.openmrs.api.context.Context;
import org.openmrs.module.aijar.api.AijarService;
import org.openmrs.module.aijar.metadata.core.PatientIdentifierTypes;
import org.openmrs.module.htmlformentry.CustomFormSubmissionAction;
import org.openmrs.module.htmlformentry.FormEntrySession;

/**
 * Action to link an exposed infant to the mother based on the mother's ART number provided
 */
public class MotherToBabyPairLinkingPostSubmissionAction implements CustomFormSubmissionAction {
	
	protected final Log log = LogFactory.getLog(getClass());
	
	private AijarService aijarService;
	private PersonService personService;
	
	public MotherToBabyPairLinkingPostSubmissionAction() {
		this.aijarService = Context.getService(AijarService.class);
		this.personService = Context.getPersonService();
	}
	
	@Override
	public void applyAction(FormEntrySession formEntrySession) {
		// first check whether the infant has a mother by looping through the parents
		Patient infant = formEntrySession.getEncounter().getPatient();
		if (!hasMother(infant.getPerson())) {
			// Find the mother using her ART number saved
			for (Obs obs: formEntrySession.getEncounter().getAllObs(false)) {
				if (obs.getConcept().getId() == 162874) {
					aijarService.linkExposedInfantToMotherViaARTNumber(infant, obs.getValueText());
				}
			}
		}
 	}
	
	private boolean hasMother(Person infant) {
		boolean hasMother = false;
		
		// find all parent relationships for the infant who is Person B
		List<Relationship> parents = personService.getRelationships(null, infant, personService.getRelationshipTypeByUuid("8d91a210-c2cc-11de-8d13-0010c6dffd0f"));
		
		if (parents.size() != 0) {
			for (Relationship parent: parents) {
				if (parent.getPersonA().getGender().equals("F")) {
					// mother found
					return true;
				}
			}
		}
		
		return hasMother;
	}
}
