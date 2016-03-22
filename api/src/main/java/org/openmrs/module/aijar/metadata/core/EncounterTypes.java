package org.openmrs.module.aijar.metadata.core;

import org.openmrs.module.metadatadeploy.descriptor.EncounterTypeDescriptor;

/**
 * Constants for all the defined encounter types
 * <p/>
 * Created by ssmusoke on 06/01/2016.
 */
public class EncounterTypes {

    public static EncounterTypeDescriptor ART_SUMMARY_PAGE = new EncounterTypeDescriptor() {
        @Override
        public String name() {
            return "ART Card - Summary";
        }

        @Override
        public String description() {
            return "Outpatient Adult Initial Visit";
        }

        public String uuid() {
            return "8d5b27bc-c2cc-11de-8d13-0010c6dffd0f";
        }
    };

    public static EncounterTypeDescriptor EID_SUMMARY_PAGE = new EncounterTypeDescriptor() {
        @Override
        public String name() {
            return "EID Card - Summary";
        }

        @Override
        public String description() {
            return "Outpatient Children Initial Visit";
        }

        public String uuid() {
            return "9fcfcc91-ad60-4d84-9710-11cc25258719";
        }
    };

    public static EncounterTypeDescriptor ART_ENCOUNTER_PAGE = new EncounterTypeDescriptor() {
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

    public static EncounterTypeDescriptor EID_ENCOUNTER_PAGE = new EncounterTypeDescriptor() {
        @Override
        public String name() {
            return "EID Card - Encounter";
        }

        @Override
        public String description() {
            return "Outpatient Child Return Visit";
        }

        public String uuid() {
            return "4345dacb-909d-429c-99aa-045f2db77e2b";
        }
    };

    public static EncounterTypeDescriptor LAB_ENCOUNTER = new EncounterTypeDescriptor() {
        @Override
        public String name() {
            return "LAB Encounter";
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
            return "ART Card - Health Education Encounter";
        }

        @Override
        public String description() {
            return "An Health education encounter created when a patient gets health education";
        }

        public String uuid() {
            return "6d88e370-f2ba-476b-bf1b-d8eaf3b1b67e";
        }
    };

    public static EncounterTypeDescriptor MATERNITY = new EncounterTypeDescriptor() {
        @Override
        public String name() {
            return "Maternity - Encounter";
        }

        @Override
        public String description() {
            return "When a mother comes to a health facility to deliver";
        }

        public String uuid() {
            return "a9f11592-22e7-45fc-904d-dfe24cb1fc67";
        }
    };

    public static EncounterTypeDescriptor SMC_SUMMARY = new EncounterTypeDescriptor() {

        @Override
        public String name() {
            return "SMC - Encounter";
        }

        @Override
        public String description() {
            return "An encounter when a patient gets SMC services";
        }

        public String uuid() {
            return "244da86d-f80e-48fe-aba9-067f241905ee";
        }
    };

    public static EncounterTypeDescriptor ANC_ENCOUNTER = new EncounterTypeDescriptor() {

        @Override
        public String name() {
            return "ANC - Encounter";
        }

        @Override
        public String description() {
            return "An encounter when a patient gets ANC services";
        }

        public String uuid() {
            return "044daI6d-f80e-48fe-aba9-037f241905Pe";
        }
    };

    public static EncounterTypeDescriptor HCT_ENCOUNTER = new EncounterTypeDescriptor() {
        @Override
        public String name() { return "HTC - Encounter";  }

        @Override
        public String description() {  return "An encounter when a patient gets HCT services";  }

        public String uuid() { return "264daIZd-f80e-48fe-nba9-P37f2W1905Pv"; }
    };
}
