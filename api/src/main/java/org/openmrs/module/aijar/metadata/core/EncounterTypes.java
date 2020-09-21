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

    public static EncounterTypeDescriptor OPD_ENCOUNTER = new EncounterTypeDescriptor() {
        @Override
        public String name() {
            return "OPD Encounter";
        }

        @Override
        public String description() {
            return "Outpatient Clinical Ecnounter";
        }

        public String uuid() {
            return "ee4780f5-b5eb-423b-932f-00b5879df5ab";
        }
    };

    public static EncounterTypeDescriptor TB_SUMMARY_ENCOUNTER = new EncounterTypeDescriptor() {
        @Override
        public String name() {
            return "TB Summary (Enrollment)";
        }

        @Override
        public String description() {
            return "An encounter for the initial visit to the TB clinic";
        }

        public String uuid() {
            return "334bf97e-28e2-4a27-8727-a5ce31c7cd66";
        }
    };

    public static EncounterTypeDescriptor TB_FOLLOWUP_ENCOUNTER = new EncounterTypeDescriptor() {
        @Override
        public String name() {
            return "TB Encounter (Followup)";
        }

        @Override
        public String description() {
            return "An encounter for a return visit to the TB clinic";
        }

        public String uuid() {
            return "455bad1f-5e97-4ee9-9558-ff1df8808732";
        }
    };


    public static EncounterTypeDescriptor DR_TB_SUMMARY_ENCOUNTER = new EncounterTypeDescriptor() {
        @Override
        public String name() {
            return "DR TB Summary (Enrollment)";
        }

        @Override
        public String description() {
            return "An encounter for the initial visit to the Drug Resistance TB Program";
        }

        public String uuid() {
            return "0271ee3d-f274-49d1-b376-c842f075413f";
        }
    };

    public static EncounterTypeDescriptor DR_TB_FOLLOWUP_ENCOUNTER = new EncounterTypeDescriptor() {
        @Override
        public String name() {
            return "DR TB Encounter (Followup)";
        }

        @Override
        public String description() {
            return "An encounter for a return visit to the Drug Resistance TB Program";
        }

        public String uuid() {
            return "41f8609d-e13b-4dff-8379-47ac5876512e";
        }
    };


    public static EncounterTypeDescriptor VIRAL_LOAD_NON_SUPPRESSED  = new EncounterTypeDescriptor() {
        @Override
        public String name() {
            return "Viral Load Non Suppressed Encounter";
        }

        @Override
        public String description() {
            return "Viral Load Non Suppressed Follow up";
        }

        public String uuid() {
            return "38cb2232-30fc-4b1f-8df1-47c795771ee9";
        }
    };

    public static EncounterTypeDescriptor APPOINTMENT_FOLLOW_UP = new EncounterTypeDescriptor() {
        @Override
        public String name() {
            return "Appointment Follow-up ";
        }

        @Override
        public String description() {
            return "Followup actions for patients especially after missing a facility visit";
        }

        public String uuid() {
            return "dc551efc-024d-4c40-aeb8-2147c4033778";
        }
    };

    public static EncounterTypeDescriptor TRIAGE = new EncounterTypeDescriptor() {
        @Override
        public String name() {
            return "Triage";
        }

        @Override
        public String description() {
            return "This is a form to capture information on triage. It include Vitals, global security indicators etc....";
        }

        public String uuid() {
            return "0f1ec66d-61db-4575-8248-94e10a88178f";
        }
    };

    public static EncounterTypeDescriptor MEDICATION_DISPENSE = new EncounterTypeDescriptor() {
        @Override
        public String name() {
            return "Medication Dispense";
        }

        @Override
        public String description() {
            return "This encounter type is for dispensing of medication at facility";
        }

        public String uuid() {
            return "22902411-19c1-4a02-b19a-bf1a9c24fd51";
        }
    };

    public static EncounterTypeDescriptor MISSED_APPOINTMENT_TRACKING = new EncounterTypeDescriptor() {
        @Override
        public String name() {
            return "Missed Appointment Tracking";
        }

        @Override
        public String description() {
            return "This encounter type is for tracking followup for missed appointments";
        }

        public String uuid() {
            return "791faefd-36b8-482f-ab78-20c297b03851";
        }
    };

    public static EncounterTypeDescriptor TRANSFER_IN = new EncounterTypeDescriptor() {
        @Override
        public String name() {
            return "Transfer In";
        }

        @Override
        public String description() {
            return "Transfer in encounter";
        }

        public String uuid() {
            return "3e8354f7-31b3-4862-a52e-ff41a1ee60af";
        }
    };

    public static EncounterTypeDescriptor TRANSFER_OUT = new EncounterTypeDescriptor() {
        @Override
        public String name() {
            return "Transfer Out";
        }

        @Override
        public String description() {
            return "Transfer out encounter";
        }

        public String uuid() {
            return "e305d98a-d6a2-45ba-ba2a-682b497ce27c";
        }
    };
}
