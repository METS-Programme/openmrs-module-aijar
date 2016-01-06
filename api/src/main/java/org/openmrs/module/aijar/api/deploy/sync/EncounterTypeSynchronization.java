package org.openmrs.module.aijar.api.deploy.sync;

import org.openmrs.EncounterType;
import org.openmrs.api.EncounterService;
import org.openmrs.module.metadatadeploy.sync.ObjectSynchronization;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.List;

/**
 * Created by ssmusoke on 06/01/2016.
 */
@Component
public class EncounterTypeSynchronization implements ObjectSynchronization<EncounterType> {
    @Autowired
    private EncounterService encounterService;

    /**
     * Fetches all existing encounter types
     *
     * @return the existing encounter types
     */
    public List<EncounterType> fetchAllExisting() {
        return encounterService.getAllEncounterTypes(true);
    }

    /**
     * Gets the synchronization key of the given object
     *
     * @param obj the object
     * @return the synchronization key
     */
    public Object getObjectSyncKey(EncounterType obj) {
        return obj.getUuid();
    }

    /**
     * Compares two objects and returns true if an update is required because there are differences
     *
     * @param incoming the incoming object
     * @param existing the existing object
     * @return true is there are differences
     */
    public boolean updateRequired(EncounterType incoming, EncounterType existing) {
        return true; // Always update existing object (not very efficient, but is what we want to do)
    }
}
