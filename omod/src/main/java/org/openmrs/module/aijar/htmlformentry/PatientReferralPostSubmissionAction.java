package org.openmrs.module.aijar.htmlformentry;

import org.openmrs.api.context.Context;
import org.openmrs.module.aijar.api.AijarService;
import org.openmrs.module.htmlformentry.CustomFormSubmissionAction;
import org.openmrs.module.htmlformentry.FormEntrySession;

public class PatientReferralPostSubmissionAction implements CustomFormSubmissionAction {
    @Override
    public void applyAction(FormEntrySession formEntrySession) {
        AijarService aijarService=Context.getService(AijarService.class);
        if (formEntrySession.getEncounter().getEncounterType() == Context.getEncounterService().getEncounterTypeByUuid("3e8354f7-31b3-4862-a52e-ff41a1ee60af")) {
            aijarService.createPatientHIVSummaryEncounterOnTransferIn(formEntrySession);
        }

    }



}
