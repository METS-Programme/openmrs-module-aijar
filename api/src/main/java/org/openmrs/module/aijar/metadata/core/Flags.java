package org.openmrs.module.aijar.metadata.core;

import org.openmrs.module.patientflags.metadatadeploy.descriptor.FlagDescriptor;

import java.util.Arrays;
import java.util.List;

public class Flags {

    public static FlagDescriptor DUE_FOR_FIRST_VIRAL_LOAD = new FlagDescriptor() {
        @Override
        public String criteria() {
            return "SELECT p.patient_id FROM patient p " +
                    "INNER JOIN obs o ON p.patient_id = o.person_id " +
                    "INNER JOIN encounter e ON o.encounter_id = e.encounter_id" +
                    "INNER JOIN encounter_type et ON e.encounter_type = et.encounter_type_id " +
                    "WHERE ((o.concept_id = 99161 AND o.voided = FALSE AND e.voided = FALSE AND ((CURRENT_DATE() BETWEEN DATE_ADD(o.value_datetime, INTERVAL 5 MONTH) AND DATE_ADD(o.value_datetime, INTERVAL 6 MONTH)) AND et.uuid='8d5b27bc-c2cc-11de-8d13-0010c6dffd0f'))) AND o.person_id NOT IN (SELECT oo.person_id FROM obs oo WHERE oo.concept_id = 1305 AND oo.voided = FALSE)";
        }

        @Override
        public String message() {
            return "Due for 1st Viral in the next month";
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
            return "Patients who are due for their first viral load after enrollment into HIV Care";
        }

        @Override
        public String uuid() {
            return "7376f82e-225c-4340-9a8d-22e679532f37";
        }
    };

    public static FlagDescriptor OVERDUE_FOR_FIRST_VIRAL_LOAD = new FlagDescriptor() {
        @Override
        public String criteria() {
            return "SELECT p.patient_id, DATE_FORMAT(DATE_ADD(o.value_datetime, INTERVAL 6 MONTH), '%d.%b.%Y') FROM patient p INNER JOIN obs o ON p.patient_id = o.person_id WHERE o.concept_id = 99161 AND o.voided = FALSE AND CURRENT_DATE() >= DATE_ADD(o.value_datetime, INTERVAL 6 MONTH) AND o.person_id NOT IN (SELECT oo.person_id FROM obs oo WHERE oo.concept_id = 1305 AND oo.voided = FALSE)";
        }

        @Override
        public String message() {
            return "Viral Load Overdue from ${1}";
        }

        @Override
        public String priority() {
            return Priorites.RED.uuid();
        }

        @Override
        public List<String> tags() {
            return Arrays.asList(Tags.PATIENT_STATUS.uuid());
        }

        @Override
        public String name() {
            return "Overdue for viral load";
        }

        @Override
        public String description() {
            return "Patients who are overdue for their first viral load after enrollment into HIV Care";
        }

        @Override
        public String uuid() {
            return "6ce583d1-a4d7-41a6-902f-9a5debea1ec7";
        }
    };

    public static FlagDescriptor UPCOMING_APPOINTMENT = new FlagDescriptor() {
        @Override
        public String criteria() {
            return "SELECT p.patient_id, DATE_FORMAT(MAX(o.value_datetime), '%d.%b.%Y') FROM patient p INNER JOIN obs o ON p.patient_id = o.person_id WHERE o.concept_id = 5096 AND o.voided = FALSE  GROUP BY o.person_id HAVING MAX(o.value_datetime) >= CURRENT_DATE()";
        }

        @Override
        public String message() {
            return "Upcoming appointment on ${1}";
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
            return "Upcoming appointment";
        }

        @Override
        public String description() {
            return "Patients who have an upcoming appointment";
        }

        @Override
        public String uuid() {
            return "1cbc86cf-8a5a-4402-b56a-6489aa4d4f2d";
        }
    };

    public static FlagDescriptor MISSED_APPOINTMENT = new FlagDescriptor() {
        @Override
        public String criteria() {
            return "SELECT p.patient_id, DATE_FORMAT(MAX(o.value_datetime), '%d.%b.%Y') FROM patient p INNER JOIN obs o ON p.patient_id = o.person_id WHERE o.concept_id = 5096 AND o.voided = FALSE GROUP BY o.person_id HAVING MAX(o.value_datetime) BETWEEN DATE_SUB(CURRENT_DATE(), INTERVAL 29 DAY) AND DATE_SUB(CURRENT_DATE(), INTERVAL 7 DAY)";
        }

        @Override
        public String message() {
            return "Missed appointment on ${1}";
        }

        @Override
        public String priority() {
            return Priorites.ORANGE.uuid();
        }

        @Override
        public List<String> tags() {
            return Arrays.asList(Tags.PATIENT_STATUS.uuid());
        }

        @Override
        public String name() {
            return "Missed appointment";
        }

        @Override
        public String description() {
            return "Patients who have missed appointment - this is between 7 to 29 days";
        }

        @Override
        public String uuid() {
            return "a248d8ca-9e60-4a54-a417-fcf00302fdb2";
        }
    };

    public static FlagDescriptor PATIENT_LOST = new FlagDescriptor() {
        @Override
        public String criteria() {
            return "SELECT p.patient_id, DATE_FORMAT(MAX(o.value_datetime), '%d.%b.%Y') FROM patient p INNER JOIN obs o ON p.patient_id = o.person_id WHERE o.concept_id = 5096 AND o.voided = FALSE GROUP BY o.person_id HAVING MAX(o.value_datetime) BETWEEN DATE_SUB(CURRENT_DATE(), INTERVAL 89 DAY) AND DATE_SUB(CURRENT_DATE(), INTERVAL 30 DAY)";
        }

        @Override
        public String message() {
            return "Lost since ${1}";
        }

        @Override
        public String priority() {
            return Priorites.RED.uuid();
        }

        @Override
        public List<String> tags() {
            return Arrays.asList(Tags.PATIENT_STATUS.uuid());
        }

        @Override
        public String name() {
            return "Lost";
        }

        @Override
        public String description() {
            return "Patients who have missed appointment - this is between 30 to 89 days";
        }

        @Override
        public String uuid() {
            return "4d10da66-1ede-4a92-aa71-a8dedb13a0ba";
        }
    };

    public static FlagDescriptor PATIENT_LOST_TO_FOLLOWUP = new FlagDescriptor() {
        @Override
        public String criteria() {
            return "SELECT p.patient_id, DATE_FORMAT(MAX(o.value_datetime), '%d.%b.%Y') FROM patient p INNER JOIN obs o ON p.patient_id = o.person_id WHERE o.concept_id = 5096 AND o.voided = FALSE GROUP BY o.person_id HAVING MAX(o.value_datetime) <= DATE_SUB(CURRENT_DATE(), INTERVAL 90 DAY)";
        }

        @Override
        public String message() {
            return "Lost to follow-up since ${1}";
        }

        @Override
        public String priority() {
            return Priorites.RED.uuid();
        }

        @Override
        public List<String> tags() {
            return Arrays.asList(Tags.PATIENT_STATUS.uuid());
        }

        @Override
        public String name() {
            return "Lost to Followup ";
        }

        @Override
        public String description() {
            return "Patients who have spent more than 90 days since their expected return date";
        }

        @Override
        public String uuid() {
            return "5a1f8283-9d5a-4efe-89a3-5634e01c8083";
        }
    };
}
