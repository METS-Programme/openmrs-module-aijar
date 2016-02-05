package org.openmrs.module.aijar.metadata.core;

import org.openmrs.module.metadatadeploy.descriptor.EncounterTypeDescriptor;

/**
 * Constants for all the defined encounter types
 * <p/>
 * Created by ssmusoke on 06/01/2016.
 */
public class EncounterTypes {

    public static EncounterTypeDescriptor SUMMARY_PAGE = new EncounterTypeDescriptor() {
        @Override
        public String name() {
            return "ART Card - Summary";
        }

        @Override
        public String description() {
            return "Outpatient Adult & Children Initial Visit";
        }

        public String uuid() {
            return "8d5b27bc-c2cc-11de-8d13-0010c6dffd0f";
        }
    };

    public static EncounterTypeDescriptor ENCOUNTER_PAGE = new EncounterTypeDescriptor() {
        @Override
        public String name() {
            return "ART Card - Encounter";
        }

        @Override
        public String description() {
            return "Outpatient Adult & Child Return Visit";
        }

        public String uuid() {
            return "8d5b2be0-c2cc-11de-8d13-0010c6dffd0f";
        }
    };

    public static EncounterTypeDescriptor LAB_ENCOUNTER = new EncounterTypeDescriptor() {
        @Override
        public String name() {
            return "LAB ENCOUNTER";
        }

        @Override
        public String description() {
            return "Lab Encounter";
        }

        public String uuid() {
            return "214e27a1-606a-4b1e-a96e-d736c87069d5";
        }
    };

    public static EncounterTypeDescriptor HEALTH_EDUCATION = new EncounterTypeDescriptor() {
        @Override
        public String name() {
            return "ART Card - Health Education";
        }

        @Override
        public String description() {
            return "An Health education encounter created when a patient gets health education";
        }

        public String uuid() {
            return "6d88e370-f2ba-476b-bf1b-d8eaf3b1b67e";
        }
    };

    public static EncounterTypeDescriptor SMC_SUMMARY = new EncounterTypeDescriptor() {
        @Override
        public String name() {
            return "SMC - Summary";
        }

        @Override
        public String description() {
            return "An encounter when a patient gets SMC services";
        }

        public String uuid() {
            return "244da86d-f80e-48fe-aba9-067f241905ee";
        }
    };

}
