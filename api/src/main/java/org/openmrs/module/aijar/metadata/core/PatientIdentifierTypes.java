package org.openmrs.module.aijar.metadata.core;

import org.openmrs.module.idgen.validator.LuhnMod30IdentifierValidator;
import org.openmrs.module.idgen.validator.LuhnModNIdentifierValidator;
import org.openmrs.module.metadatadeploy.descriptor.PatientIdentifierTypeDescriptor;
import org.openmrs.patient.IdentifierValidator;

/**
 * Constants for defined patient identifier types
 * <p/>
 * Created by ssmusoke on 06/01/2016.
 */
public class PatientIdentifierTypes {

    public static PatientIdentifierTypeDescriptor HIV_CARE_NUMBER = new PatientIdentifierTypeDescriptor() {
        @Override
        public String name() {
            return "HIV Clinic No.";
        }

        @Override
        public String description() {
            return "This is the patient's identifier used at the treating facility";
        }

        public String uuid() {
            return "e1731641-30ab-102d-86b0-7a5022ba4115";
        }

        /*public String format() {
            return "[X][X][X][\\/][0-9][0-9][0-9][0-9][0-9]";
        }*/

        public String formatDescription() {
            return " The first three letters of the facility, followed by / then 5 numbers with no spaces";
        }
    };
    
    public static PatientIdentifierTypeDescriptor ART_PATIENT_NUMBER = new PatientIdentifierTypeDescriptor() {
        @Override
        public String name() {
            return "ART Patient No.";
        }
        
        @Override
        public String description() {
            return "This is the ART number that is given to clients who have started ART";
        }
        
        public String uuid() {
            return "3c76abfd-5e2d-4194-b0d4-00b73c7fc1ac";
        }
        
        public String formatDescription() {
            return " No specific format required as it varies from facility to facility";
        }
    };

    public static PatientIdentifierTypeDescriptor EXPOSED_INFANT_NUMBER = new PatientIdentifierTypeDescriptor() {
        @Override
        public String name() {
            return "Exposed Infant No.";
        }

        @Override
        public String description() {
            return "This is the exposed infant clinic number used at the treating facility";
        }

        public String uuid() {
            return "2c5b695d-4bf3-452f-8a7c-fe3ee3432ffe";
        }

        public String formatDescription() {
            return "Either EXP/ followed by 4 numbers with no spaces for the EXP number or 01/16/001 (month/year/ "
                    + "number) for "
                    + "the Birth "
                    + "Cohort number";
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

    public static PatientIdentifierTypeDescriptor IPD_NUMBER = new PatientIdentifierTypeDescriptor() {
        @Override
        public String name() {
            return "InPatient Department No.";
        }

        @Override
        public String description() {
            return "This is the unique serial number given to the mother during her stay in the maternity ward";
        }

        public String uuid() {
            return "a6217c17-5012-4514-b9f2-5d02d3d04c44";
        }

        public String formatDescription() {
            return "Begins with 1 at the beginning of the financial year (July)";
        }
    };

    public static PatientIdentifierTypeDescriptor ANC_NUMBER = new PatientIdentifierTypeDescriptor() {
        @Override
        public String name() {
            return "Antenatal Care No.";
        }

        @Override
        public String description() {
            return "This is the unique serial number given to the mother during antenatal visits";
        }

        public String uuid() {
            return "b0cc255e-ef57-4266-839e-0df7f5099eb9";
        }

        public String formatDescription() {
            return "Begins with 1 at the beginning of the financial year (July)";
        }
    };

    public static PatientIdentifierTypeDescriptor PNC_NUMBER = new PatientIdentifierTypeDescriptor() {
        @Override
        public String name() {
            return "Postnatal Care No.";
        }

        @Override
        public String description() {
            return "This is the unique serial number given to the child during postnatal visits";
        }

        public String uuid() {
            return "758ef6e4-9ceb-4137-bc8d-9246dc7b41fe";
        }

        public String formatDescription() {
            return "Begins with 1 at the beginning of the financial year (July)";
        }
    };

    public static PatientIdentifierTypeDescriptor HCT_NUMBER = new PatientIdentifierTypeDescriptor() {
        @Override
        public String name() {
            return "HCT No.";
        }

        @Override
        public String description() {
            return "This is the unique serial number given to a client during HCT visits";
        }

        public String uuid() { return "c9e42035-7112-45b3-bfcf-4b37e1091dd4"; }
        
        public String formatDescription() {
            return "Begins with 1 at the beginning of the financial year (July), has 4 "
                    + "digits followed by a / then 2 digits for the year";
        }
    };

	public static PatientIdentifierTypeDescriptor DISTRICT_TB_NUMBER = new PatientIdentifierTypeDescriptor() {

		@Override
		public String name() {
			return "TB No.";
		}

		@Override
		public String description() {
			return "The district tuberculosis number assigned to a case";
		}

		public String uuid() {
			return "8110f2d2-1f98-4c38-aef3-11b19bb0a589";
		}

		public String formatDescription() {
			return " The first three letters of the district, followed by / then 3 digits of the case number then / then "
					+ "two digits for the year";
		}
	};

    public static PatientIdentifierTypeDescriptor NATIONAL_ID = new PatientIdentifierTypeDescriptor() {

        @Override
        public String name() {
            return "National ID No.";
        }

        @Override
        public String description() {
            return "The Uganda National ID number";
        }

        public String uuid() {
            return "f0c16a6d-dc5f-4118-a803-616d0075d282";
        }
        
    };

    public static PatientIdentifierTypeDescriptor RESEARCH_PATIENT_ID = new PatientIdentifierTypeDescriptor() {

        @Override
        public String name() {
            return "Research Identifier";
        }

        @Override
        public String description() {
            return "An identifier used for patients within research settings";
        }

        public String uuid() {
            return "20653abb-689c-4975-bbfa-00de7b507a95";
        }
    };
    
    public static PatientIdentifierTypeDescriptor SMC_CLIENT_NUMBER = new PatientIdentifierTypeDescriptor() {
        
        @Override
        public String name() {
            return "Safe Male Circumcision Client Number";
        }
        
        @Override
        public String description() {
            return "An identifier used for patients who undergo safe male circumcision";
        }
        
        public String uuid() {
            return "37601abe-2ee0-4493-8ac7-22b4972190cf";
        }
    };

	public static PatientIdentifierTypeDescriptor UNIT_TB_NUMBER = new PatientIdentifierTypeDescriptor() {

		@Override
		public String name() {
			return "Unit TB No.";
		}

		@Override
		public String description() {
			return "The patient identifier assigned to a tuberculosis case by the Health unit providing care";
		}

		public String uuid() {
			return "8fd5e225-f91a-44af-ba04-3b41428d2164";
		}

		public String formatDescription() {
			return " The first 3 digits of the case number then / then "
					+ "two digits for the year";
		}
	};    

	public static PatientIdentifierTypeDescriptor HSD_TB_NUMBER = new PatientIdentifierTypeDescriptor() {

		@Override
		public String name() {
			return "Health Sub-District TB No.";
		}

		@Override
		public String description() {
			return "The patient identifier assigned to a tuberculosis case by a health sub-district focal person "
					+ "when being registered in the HSD register";
		}

		public String uuid() {
			return "2a6f1f82-2b70-4a51-8507-3a849bc637c3";
		}

		public String formatDescription() {
			return "";
		}
	};    	
	
}
