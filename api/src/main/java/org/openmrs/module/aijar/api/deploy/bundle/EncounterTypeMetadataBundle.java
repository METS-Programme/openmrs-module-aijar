package org.openmrs.module.aijar.api.deploy.bundle;

import org.openmrs.module.aijar.metadata.core.EncounterTypes;
import org.openmrs.module.metadatadeploy.bundle.AbstractMetadataBundle;
import org.openmrs.module.metadatadeploy.descriptor.EncounterTypeDescriptor;
import org.springframework.stereotype.Component;

import static org.openmrs.module.metadatadeploy.bundle.CoreConstructors.encounterType;

/**
 * Created by ssmusoke on 06/01/2016.
 */
@Component
public class EncounterTypeMetadataBundle extends AbstractMetadataBundle {

    public void install() throws Exception {
        install(EncounterTypes.SUMMARY_PAGE);
        install(EncounterTypes.ENCOUNTER_PAGE);
        install(EncounterTypes.LAB_ENCOUNTER);
        install(EncounterTypes.HEALTH_EDUCATION);
        install(EncounterTypes.SMC_SUMMARY);
    }

    protected void install(EncounterTypeDescriptor d) {
        install(encounterType(d.name(), d.description(), d.uuid()));
    }
}
