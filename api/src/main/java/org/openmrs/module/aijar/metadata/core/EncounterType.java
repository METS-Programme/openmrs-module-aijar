package org.openmrs.module.aijar.metadata.core;

import org.openmrs.module.metadatadeploy.descriptor.EncounterTypeDescriptor;

/**
 * Created by lubwamasamuel on 18/10/16.
 */
public class EncounterType {
    public static EncounterTypeDescriptor PCN_ENCOUNTER_TYPE = new EncounterTypeDescriptor() {
        @Override
        public String name() {
            return "PNC - Encounter";
        }

        @Override
        public String description() {
            return "An encounter when a patient gets PNC services";
        }

        public String uuid() {
            return "fa6f3ff5-b784-43fb-ab35-a08ab7dbf074";
        }

        /*public String format() {
            return "[X][X][X][\\/][0-9][0-9][0-9][0-9][0-9]";
        }*/

        public String formatDescription() {
            return " The first three letters of the facility, followed by / then 5 numbers with no spaces";
        }
    };
}
