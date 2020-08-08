/**
 * The contents of this file are subject to the OpenMRS Public License
 * Version 1.0 (the "License"); you may not use this file except in
 * compliance with the License. You may obtain a copy of the License at
 * http://license.openmrs.org
 *
 * Software distributed under the License is distributed on an "AS IS"
 * basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See the
 * License for the specific language governing rights and limitations
 * under the License.
 *
 * Copyright (C) OpenMRS, LLC.  All Rights Reserved.
 */

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

        @Override
        public String outcomesConceptUuid() {
            return "e44c8c4c-db50-4d1e-9d6e-092d3b31cfd6";
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


    public static ProgramDescriptor FBIM_PROGRAM = new ProgramDescriptor() {

        @Override
        public String conceptUuid() {
            return "733144c0-c321-11e8-a355-529269fb1459";
        }

        @Override
        public String name() {
            return "FBIM";
        }

        @Override
        public String description() {
            return "Facility Based Individual Management a DSDM model for patients that need extra management at the health centre";
        }

        @Override
        public String uuid() {
            return "de5d54ae-c304-11e8-9ad0-529269fb1459";
        }
    };

    public static ProgramDescriptor FTR_PROGRAM = new ProgramDescriptor() {

        @Override
        public String conceptUuid() {
            return "73313f20-c321-11e8-a355-529269fb1459";
        }

        @Override
        public String name() {
            return "FTR";
        }

        @Override
        public String description() {
            return "Fast Track Drug Refill is a DSDM Model for patients who only pick drugs at the health centre";
        }

        @Override
        public String uuid() {
            return "de5d5896-c304-11e8-9ad0-529269fb1459";
        }
    };

    public static ProgramDescriptor FBG_PROGRAM = new ProgramDescriptor() {

        @Override
        public String conceptUuid() {
            return "73313c96-c321-11e8-a355-529269fb1459";
        }

        @Override
        public String name() {
            return "FGB";
        }

        @Override
        public String description() {
            return "Facility Based Groups a DSDM for stable or unstable clients who need peer support";
        }

        @Override
        public String uuid() {
            return "de5d5b34-c304-11e8-9ad0-529269fb1459";
        }
    };

    public static ProgramDescriptor CCLAD_PROGRAM = new ProgramDescriptor() {

        @Override
        public String conceptUuid() {
            return "733139e4-c321-11e8-a355-529269fb1459";
        }

        @Override
        public String name() {
            return "CCLAD";
        }

        @Override
        public String description() {
            return "Community Client Led ART Delivery is a DSDM  Model with client lead groups with rotation drug pickup by client them selves and distribution";
        }

        @Override
        public String uuid() {
            return "de5d5da0-c304-11e8-9ad0-529269fb1459";
        }
    };

    public static ProgramDescriptor CDDP_PROGRAM = new ProgramDescriptor() {

        @Override
        public String conceptUuid() {
            return "73313728-c321-11e8-a355-529269fb1459";
        }

        @Override
        public String name() {
            return "CDDP";
        }

        @Override
        public String description() {
            return " Community Drug Distribution Point DSDM Model in community where patients pick drugs from a distribution point in community set by their health centre";
        }

        @Override
        public String uuid() {
            return "de5d6034-c304-11e8-9ad0-529269fb1459";
        }
    };
}

