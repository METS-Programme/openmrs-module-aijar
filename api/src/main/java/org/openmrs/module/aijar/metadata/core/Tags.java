package org.openmrs.module.aijar.metadata.core;

import org.openmrs.module.patientflags.metadatadeploy.descriptor.TagDescriptor;

import java.util.Arrays;
import java.util.List;
import java.util.Set;

public class Tags {

    public static TagDescriptor PATIENT_STATUS = new TagDescriptor() {
        @Override
        public List<String> roles() {
            List<String> rolesList = Arrays.asList("System Developer"); // Roles use the name as the primary key
            return rolesList;
        }

        @Override
        public String name() {
            return "Patient Status";
        }

        @Override
        public String description() {
            return "The status of a patient displayed on the patient dashboard";
        }

        @Override
        public String uuid() {
            return "58199ad1-aecb-40f5-90b0-767982ff3e72";
        }
    };
}
