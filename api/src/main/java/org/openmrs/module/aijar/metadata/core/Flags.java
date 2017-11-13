package org.openmrs.module.aijar.metadata.core;

import org.apache.velocity.util.ArrayListWrapper;
import org.openmrs.module.patientflags.metadatadeploy.descriptor.FlagDescriptor;

import java.util.Arrays;
import java.util.List;

public class Flags {

    public static FlagDescriptor DUE_FOR_VIRAL_LOAD = new FlagDescriptor() {
        @Override
        public String criteria() {
            return "select e.patient_id from encounter e INNER JOIN encounter_type et ON e.encounter_type = et.encounter_type_id WHERE et.uuid = '8d5b27bc-c2cc-11de-8d13-0010c6dffd0f' AND e.patient_id NOT IN (SELECT o.person_id FROM obs o WHERE o.concept_id = 5096)";
        }

        @Override
        public String message() {
            return "Due for 1st Viral Load";
        }

        @Override
        public String priority() {
            return Priorites.GREEN.uuid();
        }

        @Override
        public List<String> tags() {
            return Arrays.asList(Tags.PATIENT_STATUS.uuid());
        }

        @Override
        public String name() {
            return "Due for 1st Viral Load";
        }

        @Override
        public String description() {
            return "Patients who are due for their first viral load after entrollment into HIV Care";
        }

        @Override
        public String uuid() {
            return "7376f82e-225c-4340-9a8d-22e679532f37";
        }
    };
}
