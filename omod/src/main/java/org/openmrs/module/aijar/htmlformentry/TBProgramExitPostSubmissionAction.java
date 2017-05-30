package org.openmrs.module.aijar.htmlformentry;

import org.openmrs.Concept;
import org.openmrs.Encounter;
import org.openmrs.Obs;
import org.openmrs.Patient;
import org.openmrs.PatientProgram;
import org.openmrs.Program;
import org.openmrs.api.APIException;
import org.openmrs.api.ProgramWorkflowService;
import org.openmrs.api.context.Context;
import org.openmrs.module.aijar.metadata.core.Programs;
import org.openmrs.module.htmlformentry.CustomFormSubmissionAction;
import org.openmrs.module.htmlformentry.FormEntryContext;
import org.openmrs.module.htmlformentry.FormEntrySession;
import org.openmrs.module.htmlformentry.FormEntryContext.Mode;

/**
 * Exits patients out of the TB program
 */
public class TBProgramExitPostSubmissionAction implements CustomFormSubmissionAction {
	
	public static final int TREATMENT_OUTCOME_CONCEPT_ID = 99423;
	public static final int TREATMENT_OUTCOME_DATE_CONCEPT_ID = 259787;
	
	@Override
	public void applyAction(FormEntrySession session) {
		
		//exit during enter or edit modes
		Mode mode = session.getContext().getMode();
		if (!(mode.equals(FormEntryContext.Mode.ENTER) || mode.equals(FormEntryContext.Mode.EDIT))) {
			return;
		}
		
		ProgramWorkflowService service = Context.getService(ProgramWorkflowService.class);
		Program tbProgram = service.getProgramByUuid(Programs.TB_PROGRAM.uuid());
		if (tbProgram == null) {
			throw new APIException("The TB Program does not exist. Please restore it if deleted");
		}
		Patient patient = session.getPatient();
		
		//exit if patient is enrolled and we have a treatment outcome
		for (PatientProgram patientProgram : service.getPatientPrograms(patient, tbProgram, null, null, null, null, false)) {
			if (!patientProgram.getActive()) {
				continue;
			}
			
			Obs obs = getTreatmentOutcomeObs(session.getEncounter());
			if (obs != null) {
				patientProgram.setDateCompleted(obs.getObsDatetime());
				patientProgram.setOutcome(obs.getValueCoded());
				obs = getTreatmentOutcomeDateObs(session.getEncounter());
				if (obs != null) {
					patientProgram.setDateCompleted(obs.getValueDate());
				}
				service.voidPatientProgram(patientProgram, "htmlformentry");
			}
		}
	}
	
	private Obs getTreatmentOutcomeDateObs(Encounter encounter) {
		Concept concept = Context.getConceptService().getConcept(TREATMENT_OUTCOME_DATE_CONCEPT_ID);
        return getObs(encounter, concept);
    }
	
	private Obs getTreatmentOutcomeObs(Encounter encounter) {
		Concept concept = Context.getConceptService().getConcept(TREATMENT_OUTCOME_CONCEPT_ID);
        return getObs(encounter, concept);
    }
	
	private Obs getObs(Encounter encounter, Concept concept) {
        for (Obs candidate : encounter.getObs()) {
            if (candidate.getConcept().equals(concept)) {
                return candidate;
            }
        }
        return null;
    }
}
