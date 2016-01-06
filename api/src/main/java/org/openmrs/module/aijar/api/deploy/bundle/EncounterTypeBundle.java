package org.openmrs.module.aijar.api.deploy.bundle;

import org.openmrs.module.aijar.api.deploy.source.EncounterTypeCsvSource;
import org.openmrs.module.aijar.api.deploy.sync.EncounterTypeSynchronization;
import org.openmrs.module.metadatadeploy.bundle.AbstractMetadataBundle;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

/**
 * Created by ssmusoke on 06/01/2016.
 */
@Component
public class EncounterTypeBundle extends AbstractMetadataBundle {

    @Autowired
    private EncounterTypeSynchronization encounterTypeSync;

    public void install() throws Exception {
        // TODO: Carry out additional tests to verify that changes to the name and description are propagated to the database
        sync(new EncounterTypeCsvSource("metadata/encountertypes.csv"), encounterTypeSync);
    }
}
