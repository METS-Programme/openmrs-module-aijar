package org.openmrs.module.aijar.api.deploy.bundle;

import org.openmrs.module.aijar.metadata.core.Flags;
import org.openmrs.module.aijar.metadata.core.Priorites;
import org.openmrs.module.aijar.metadata.core.Tags;
import org.openmrs.module.metadatadeploy.bundle.AbstractMetadataBundle;
import org.openmrs.module.patientflags.metadatadeploy.bundle.PatientFlagMetadataBundle;
import org.springframework.stereotype.Component;


/**
 * Installs metadata for Patient Flags
 */
@Component
public class UgandaEMRPatientFlagMetadataBundle extends PatientFlagMetadataBundle {

    /**
     * @see AbstractMetadataBundle#install()
     */
    public void install() throws Exception {
        // Tags
        log.info("Installing Patient flag tags");
        install(Tags.PATIENT_STATUS);

        // Priorites
        log.info("Installing patient flag priorities");
        install(Priorites.GREEN);
        install(Priorites.RED);
        install(Priorites.ORANGE);

        // Flags
        log.info("Installing flags");
        install(Flags.DUE_FOR_FIRST_VIRAL_LOAD);
        install(Flags.OVERDUE_FOR_FIRST_VIRAL_LOAD);
        install(Flags.MISSED_APPOINTMENT);
        install(Flags.UPCOMING_APPOINTMENT);
        install(Flags.PATIENT_LOST);
        install(Flags.PATIENT_LOST_TO_FOLLOWUP);
        install(Flags.DUE_FOR_ROUTINE_VIRAL_LOAD);
        install(Flags.OVERDUE_FOR_ROUTINE_VIRAL_LOAD);
        install(Flags.DUE_FOR_FIRST_DNA_PCR);
        install(Flags.OVERDUE_FOR_FIRST_DNA_PCR);
        install(Flags.DUE_FOR_SECOND_DNA_PCR);
        install(Flags.OVERDUE_FOR_SECOND_DNA_PCR);
        install(Flags.DUE_FOR_RAPID_TEST);
        install(Flags.OVERDUE_FOR_RAPID_TEST);
        install(Flags.HAS_UNSUPRESSED_VIRAL_LOAD);
    }
}
