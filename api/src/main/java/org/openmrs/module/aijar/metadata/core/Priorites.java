package org.openmrs.module.aijar.metadata.core;

import org.openmrs.module.patientflags.metadatadeploy.descriptor.PriorityDescriptor;

public class Priorites {

    public static PriorityDescriptor RED = new PriorityDescriptor() {
        @Override
        public String style() {
            return "color: red;";
        }

        @Override
        public Integer rank() {
            return 1;
        }

        @Override
        public String name() {
            return "red";
        }

        @Override
        public String description() {
            return "Action is overdue";
        }

        @Override
        public String uuid() {
            return "5d5baa1a-3534-452e-b7b8-ded8b780cdf5";
        }
    };

    public static PriorityDescriptor ORANGE = new PriorityDescriptor() {
        @Override
        public String style() {
            return "color: orange;";
        }

        @Override
        public Integer rank() {
            return 2;
        }

        @Override
        public String name() {
            return "orange";
        }

        @Override
        public String description() {
            return "Take action now";
        }

        @Override
        public String uuid() {
            return "c93bd09f-6d63-422f-818c-c8f52b5e235a";
        }
    };

    public static PriorityDescriptor GREEN = new PriorityDescriptor() {
        @Override
        public String style() {
            return "color: green;";
        }

        @Override
        public Integer rank() {
            return 3;
        }

        @Override
        public String name() {
            return "green";
        }

        @Override
        public String description() {
            return "Plan to take action";
        }

        @Override
        public String uuid() {
            return "26cc6e39-449f-4813-9350-3eaac66bfab2";
        }
    };
}
