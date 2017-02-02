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
    
    public static EncounterTypeDescriptor TB_Summary = new EncounterTypeDescriptor() {

		@Override
		public String uuid() {
			return "334bf97e-28e2-4a27-8727-a5ce31c7cd66";
		}

		@Override
		public String description() {
			// TODO Auto-generated method stub
			return "An encounter for the initial visit to the TB clinic";
		}

		@Override
		public String name() {
			return "TB Enrollment(Summary)";
		}
    	
    };

    public static EncounterTypeDescriptor TB_Encounter = new EncounterTypeDescriptor() {

		@Override
		public String uuid() {
			return "455bad1f-5e97-4ee9-9558-ff1df8808732";
		}

		@Override
		public String description() {
			// TODO Auto-generated method stub
			return "An encounter for a return visit to the TB clinic";
		}

		@Override
		public String name() {
			return "TB Followup (Encounter)";
		}
    	
    };

    public static EncounterTypeDescriptor TB_Discontinuation = new EncounterTypeDescriptor() {

		@Override
		public String uuid() {
			return "4cc49b5d-b523-4c0c-992e-17fbc35b60de";
		}

		@Override
		public String description() {
			return "An encounter for a patient discontinued from the TB program";
		}

		@Override
		public String name() {
			return "TB Discontinuation";
		}
    	
    };
}
