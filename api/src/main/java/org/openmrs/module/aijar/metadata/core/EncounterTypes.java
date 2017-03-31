package org.openmrs.module.aijar.metadata.core;

import org.openmrs.module.metadatadeploy.descriptor.EncounterTypeDescriptor;

/**
 * Created by lubwamasamuel on 18/10/16.
 */
public class EncounterTypes {
    public static EncounterTypeDescriptor PNC_ENCOUNTER_TYPE = new EncounterTypeDescriptor() {
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
    };

    public static EncounterTypeDescriptor SMC_FOLLOW_UP_ENCOUNTER = new EncounterTypeDescriptor() {
        @Override
        public String name() {
            return "SMC FOLLOW UP - Encounter";
        }

        @Override
        public String description() {
            return "An encounter for SMC Follow up";
        }

        public String uuid() {
            return "d0f9e0b7-f336-43bd-bf50-0a7243857fa6";
        }
    };
}
