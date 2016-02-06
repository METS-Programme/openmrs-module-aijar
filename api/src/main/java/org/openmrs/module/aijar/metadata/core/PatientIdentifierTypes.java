package org.openmrs.module.aijar.metadata.core;

import org.openmrs.module.idgen.validator.LuhnModNIdentifierValidator;
import org.openmrs.module.metadatadeploy.descriptor.PatientIdentifierTypeDescriptor;
import org.openmrs.patient.IdentifierValidator;
import org.openmrs.module.idgen.validator.LuhnMod30IdentifierValidator;

/**
 * Constants for defined patient identifier types
 * <p/>
 * Created by ssmusoke on 06/01/2016.
 */
public class PatientIdentifierTypes {

    public static PatientIdentifierTypeDescriptor HIV_CARE_NUMBER = new PatientIdentifierTypeDescriptor() {
        @Override
        public String name() {
            return "Clinic Number";
        }

        @Override
        public String description() {
            return "This is the patient's identifier used at the treating facility";
        }

        public String uuid() {
            return "e1731641-30ab-102d-86b0-7a5022ba4115";
        }

        public String format() {
            return "[X][X][X][\\/][0-9][0-9][0-9][0-9][0-9]";
        }

        public String formatDescription() {
            return " The first three letters of the facility, followed by / then 5 numbers with no spaces";
        }
    };


    public static PatientIdentifierTypeDescriptor EXPOSED_INFANT_NUMBER = new PatientIdentifierTypeDescriptor() {
        @Override
        public String name() {
            return "Exposed Infant Number";
        }

        @Override
        public String description() {
            return "This is the exposed infant clinic number used at the treating facility";
        }

        public String uuid() {
            return "2c5b695d-4bf3-452f-8a7c-fe3ee3432ffe";
        }

        public String format() {
            return "[E][X][P][\\/][0-9][0-9][0-9][0-9]";
        }

        public String formatDescription() {
            return " EXP/ followed by 4 numbers with no spaces";
        }
    };


    public static PatientIdentifierTypeDescriptor OPENMRS_ID = new PatientIdentifierTypeDescriptor() {
        @Override
        public String name() {
            return "OpenMRS ID";
        }

        @Override
        public boolean required() {
            return true;
        }

        @Override
        public String description() {
            return "OpenMRS patient identifier, with check-digit";
        }

        public String uuid() {
            return "05a29f94-c0ed-11e2-94be-8c13b969e334";
        }

        public Class<? extends IdentifierValidator> validator() {
            return LuhnMod30IdentifierValidator.class;
        }
    };

    public static PatientIdentifierTypeDescriptor OLD_OPENMRS_IDENTIFICATION_NUMBER = new PatientIdentifierTypeDescriptor() {
        @Override
        public String name() {
            return "Old Identification Number";
        }

        @Override
        public String description() {
            return "Number given out prior to the OpenMRS system (No check digit)";
        }

        public String uuid() {
            return "8d79403a-c2cc-11de-8d13-0010c6dffd0f";
        }
    };

    public static PatientIdentifierTypeDescriptor OPENMRS_IDENTIFICATION_NUMBER = new PatientIdentifierTypeDescriptor() {
        @Override
        public String name() {
            return "OpenMRS Identification Number";
        }

        @Override
        public String description() {
            return "Unique number used in OpenMRS";
        }

        public String uuid() {
            return "8d793bee-c2cc-11de-8d13-0010c6dffd0f";
        }

        public Class<? extends IdentifierValidator> validator() {
            return LuhnModNIdentifierValidator.class;
        }
    };

    public static PatientIdentifierTypeDescriptor ANC_NUMBER = new PatientIdentifierTypeDescriptor() {
        @Override
        public String name() { return "ANC Number"; }

        @Override
        public String description() { return "Number given to patient for ANC Services"; }

        public String uuid() {
            return "d435f50c-3af1-4b2b-adfa-96f27f8a041f";
        }

        public String format() {
            return "[A][N][C][\\/][0-9][0-9][0-9][0-9][0-9]";
        }

        public String formatDescription() {return " ANC/ followed by 4 numbers with no spaces";}

    };
}
