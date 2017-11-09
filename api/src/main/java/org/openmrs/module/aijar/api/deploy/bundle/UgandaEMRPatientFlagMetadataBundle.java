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
        install(Flags.DUE_FOR_VIRAL_LOAD);
    }
}
