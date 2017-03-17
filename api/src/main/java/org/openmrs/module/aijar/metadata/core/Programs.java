package org.openmrs.module.aijar.metadata.core;

import org.openmrs.module.metadatadeploy.descriptor.ProgramDescriptor;

/**Contains all the programs that are needed for ugandaEMR to function
 * Created by codehub on 3/13/17.
 */

public class Programs {

    public static ProgramDescriptor TB_PROGRAM = new ProgramDescriptor() {

        @Override
        public String conceptUuid() {
            return "160541AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA";
        }

        @Override
        public String name() {
            return "TB Program";
        }

        @Override
        public String description() {
            return "Program where TB patients are treated and monitored";
        }

        @Override
        public String uuid() {
            return "9dc21a72-0971-11e7-8037-507b9dc4c741";
        }
    };

    public static ProgramDescriptor HIV_PROGRAM = new ProgramDescriptor() {

        @Override
        public String conceptUuid() {
            return "160631AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA";
        }

        @Override
        public String name() {
            return "HIV Program";
        }

        @Override
        public String description() {
            return "Program where HIV patients are treated and monitored";
        }

        @Override
        public String uuid() {
            return "18c6d4aa-0a36-11e7-8dbb-507b9dc4c741";
        }
    };

    public static ProgramDescriptor MCH_PROGRAM = new ProgramDescriptor() {

        @Override
        public String conceptUuid() {
            return "159937AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA";
        }

        @Override
        public String name() {
            return "MCH Program";
        }

        @Override
        public String description() {
            return "The program which deals with the health issues of mother and children.";
        }

        @Override
        public String uuid() {
            return "5e8c094c-0a36-11e7-b779-507b9dc4c741";
        }
    };

    public static ProgramDescriptor NUTRITION_PROGRAM = new ProgramDescriptor() {

        @Override
        public String conceptUuid() {
            return "160552AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA";
        }

        @Override
        public String name() {
            return "Nutrition Program";
        }

        @Override
        public String description() {
            return "Provide nutrition and lifestyle advice to help others be healthy.";
        }

        @Override
        public String uuid() {
            return "8c563776-0a36-11e7-9661-507b9dc4c741";
        }
    };

}
