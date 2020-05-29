package org.openmrs.module.aijar.metadata.core;

import org.openmrs.module.patientflags.metadatadeploy.descriptor.FlagDescriptor;

import java.util.Arrays;
import java.util.List;

public class Flags {

    public static FlagDescriptor DUE_FOR_FIRST_VIRAL_LOAD = new FlagDescriptor() {
        @Override
        public String criteria() {
            return "SELECT p.patient_id, DATE_FORMAT(DATE_ADD(o.value_datetime, INTERVAL 6 MONTH), '%d.%b.%Y') FROM patient p \n" +
                    " INNER JOIN obs o ON p.patient_id = o.person_id  INNER JOIN encounter e ON o.encounter_id = e.encounter_id  \n" +
                    " INNER JOIN encounter_type et ON e.encounter_type = et.encounter_type_id \n" +
                    " INNER JOIN person pp ON pp.person_id=p.patient_id  WHERE  pp.dead =false \n" +
                    "  AND ((o.concept_id = 99161 AND o.voided = FALSE AND e.voided = FALSE AND ((CURRENT_DATE() BETWEEN DATE_ADD(o.value_datetime, INTERVAL 5 MONTH) AND DATE_ADD(o.value_datetime, INTERVAL 6 MONTH)) AND et.uuid='8d5b27bc-c2cc-11de-8d13-0010c6dffd0f'))) AND o.person_id \n" +
                    "  NOT IN (SELECT oo.person_id FROM obs oo WHERE oo.concept_id = 1305 AND oo.voided = FALSE)\n" +
                    " AND p.patient_id NOT IN (select o.person_id from obs o where concept_id=90306 and o.voided=FALSE)";
        }

        @Override
        public String message() {
            return "Due for 1st Viral on ${1}";
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
            return "SELECT p.patient_id, DATE_FORMAT(DATE_ADD(o.value_datetime, INTERVAL 6 MONTH), '%d.%b.%Y') FROM patient p\n" +
                    "                     INNER JOIN obs o ON p.patient_id = o.person_id\n" +
                    "                     INNER JOIN person pp ON pp.person_id = p.patient_id WHERE pp.dead = FALSE \n" +
                    "                     AND  o.concept_id = 99161 AND o.voided = FALSE AND CURRENT_DATE() >= DATE_ADD(o.value_datetime, INTERVAL 6 MONTH)\n" +
                    "                     AND o.person_id NOT IN (SELECT oo.person_id FROM obs oo WHERE oo.concept_id = 1305 AND oo.voided = FALSE)\n" +
                    "                     AND p.patient_id NOT IN (SELECT oo.person_id FROM obs oo WHERE oo.concept_id = 90306 AND oo.voided = FALSE)";
        }

        @Override
        public String message() {
            return "First Viral Load Overdue from ${1}";
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
            return "Overdue for First Viral Load";
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

    public static FlagDescriptor DUE_FOR_ROUTINE_VIRAL_LOAD = new FlagDescriptor() {
        @Override
        public String criteria() {
            return "SELECT p.patient_id, DATE_FORMAT(IF(TIMESTAMPDIFF(YEAR, pe.birthdate, CURDATE()) < 16, DATE_ADD(MAX(o.value_datetime), INTERVAL 6 MONTH), DATE_ADD(MAX(o.value_datetime), INTERVAL 12 MONTH)), '%d.%b.%Y') FROM patient p\n" +
                    "INNER JOIN obs o ON p.patient_id = o.person_id \n" +
                    "INNER JOIN person pe ON o.person_id = pe.person_id \n" +
                    "WHERE pe.dead=FALSE\n" +
                    "AND o.concept_id = 163023 AND o.voided = FALSE \n" +
                    "GROUP BY pe.person_id, pe.birthdate \n" +
                    "HAVING DATEDIFF(IF(TIMESTAMPDIFF(YEAR, pe.birthdate, CURDATE()) < 16, DATE_ADD(MAX(o.value_datetime), INTERVAL 6 MONTH), DATE_ADD(MAX(o.value_datetime), INTERVAL 12 MONTH)), CURRENT_DATE()) BETWEEN 0 AND 30\n" +
                    "AND p.patient_id NOT IN (SELECT oo.person_id FROM obs oo WHERE oo.concept_id = 90306 AND oo.voided = FALSE)";
        }

        @Override
        public String message() {
            return "Due for Routine Viral Load on ${1}";
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
            return "Due for Routine Viral Load";
        }

        @Override
        public String description() {
            return "Patients who are due for their routine viral load";
        }

        @Override
        public String uuid() {
            return "5bc66261-7ad6-4c66-97d9-eb3c511a9274";
        }
    };

    public static FlagDescriptor OVERDUE_FOR_ROUTINE_VIRAL_LOAD = new FlagDescriptor() {
        @Override
        public String criteria() {
            return "SELECT p.patient_id, DATE_FORMAT(IF(TIMESTAMPDIFF(YEAR, pe.birthdate, CURDATE()) < 16, DATE_ADD(MAX(o.value_datetime), INTERVAL 6 MONTH), DATE_ADD(MAX(o.value_datetime), INTERVAL 12 MONTH)), '%d.%b.%Y') FROM patient p \n" +
                    "INNER JOIN obs o ON p.patient_id = o.person_id\n" +
                    "INNER JOIN person pe ON o.person_id = pe.person_id \n" +
                    " WHERE pe.dead=FALSE\n" +
                    "AND  o.concept_id = 163023 AND o.voided = FALSE\n" +
                    "GROUP BY pe.person_id, pe.birthdate \n" +
                    "HAVING CURRENT_DATE() > IF(TIMESTAMPDIFF(YEAR, pe.birthdate, CURDATE()) < 16, DATE_ADD(MAX(o.value_datetime), INTERVAL 6 MONTH), DATE_ADD(MAX(o.value_datetime), INTERVAL 12 MONTH))\n" +
                    "AND p.patient_id NOT IN (SELECT oo.person_id FROM obs oo WHERE oo.concept_id = 90306 AND oo.voided = FALSE)";
        }

        @Override
        public String message() {
            return "Overdue for Routine Viral Load from ${1}";
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
            return "Overdue for Routine Viral Load";
        }

        @Override
        public String description() {
            return "Patients who are overdue for their routine viral load";
        }

        @Override
        public String uuid() {
            return "ffa7a845-bcdd-4727-a68a-3bad8c09692d";
        }
    };

    public static FlagDescriptor UPCOMING_APPOINTMENT = new FlagDescriptor() {
        @Override
        public String criteria() {
            return "SELECT p.patient_id, DATE_FORMAT(MAX(o.value_datetime), '%d.%b.%Y') FROM patient p \n" +
                    "INNER JOIN obs o ON p.patient_id = o.person_id \n" +
                    "INNER JOIN person pe on pe.person_id=p.patient_id\n" +
                    " WHERE pe.dead=FALSE\n" +
                    "AND  o.concept_id = 5096 AND o.voided = FALSE  GROUP BY o.person_id HAVING MAX(o.value_datetime) >= CURRENT_DATE()\n" +
                    "AND p.patient_id NOT IN (SELECT oo.person_id FROM obs oo WHERE oo.concept_id = 90306 AND oo.voided = FALSE)";
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
            return "SELECT p.patient_id, DATE_FORMAT(MAX(o.value_datetime), '%d.%b.%Y') \n" +
                    "FROM patient p\n" +
                    " INNER JOIN obs o ON p.patient_id = o.person_id \n" +
                    " INNER JOIN person pe on pe.person_id=p.patient_id\n" +
                    " WHERE pe.dead=FALSE\n" +
                    " AND o.concept_id = 5096 AND o.voided = FALSE GROUP BY o.person_id \n" +
                    " HAVING MAX(o.value_datetime) BETWEEN DATE_SUB(CURRENT_DATE(), INTERVAL 29 DAY) AND DATE_SUB(CURRENT_DATE(), INTERVAL 7 DAY)\n" +
                    " AND p.patient_id NOT IN (SELECT oo.person_id FROM obs oo WHERE oo.concept_id = 90306 AND oo.voided = FALSE)";
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
            return "SELECT p.patient_id, DATE_FORMAT(DATE_ADD(MAX(o.value_datetime), INTERVAL 30 DAY), '%d.%b.%Y') FROM patient p\n" +
                    "   INNER JOIN obs o ON p.patient_id = o.person_id\n" +
                    "   INNER JOIN person pe on pe.person_id=p.patient_id\n" +
                    "   WHERE pe.dead=FALSE \n" +
                    "    AND o.concept_id = 5096 AND o.voided = FALSE GROUP BY o.person_id \n" +
                    "   HAVING MAX(o.value_datetime) BETWEEN DATE_SUB(CURRENT_DATE(), INTERVAL 89 DAY) AND DATE_SUB(CURRENT_DATE(), INTERVAL 30 DAY)\n" +
                    "   AND p.patient_id NOT IN (SELECT oo.person_id FROM obs oo WHERE oo.concept_id = 90306 AND oo.voided = FALSE)";
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
            return "SELECT p.patient_id, DATE_FORMAT(DATE_ADD(MAX(o.value_datetime), INTERVAL 90 DAY), '%d.%b.%Y') FROM patient p\n" +
                    " INNER JOIN obs o ON p.patient_id = o.person_id \n" +
                    "INNER JOIN person pp ON pp.person_id=p.patient_id \n" +
                    "WHERE  pp.dead =false  AND o.concept_id = 5096 AND  o.voided = FALSE GROUP BY o.person_id \n" +
                    "HAVING MAX(o.value_datetime) <= DATE_SUB(CURRENT_DATE(), INTERVAL 90 DAY)\n" +
                    "AND p.patient_id NOT IN (select o.person_id from obs o where concept_id=90306 and o.voided=false)";
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

    public static FlagDescriptor DUE_FOR_FIRST_DNA_PCR = new FlagDescriptor() {
        @Override
        public String criteria() {
            return "SELECT p.patient_id , DATE_FORMAT(DATE_ADD(pe.birthdate, INTERVAL 6 WEEK), '%d.%b.%Y') FROM patient p  \n" +
                    " INNER JOIN obs o ON p.patient_id = o.person_id   \n" +
                    " INNER JOIN person pe ON p.patient_id = pe.person_id \n" +
                    " INNER JOIN encounter e ON o.encounter_id = e.encounter_id \n" +
                    " INNER JOIN encounter_type et ON e.encounter_type = et.encounter_type_id \n" +
                    " WHERE pe.dead=FALSE \n" +
                    " AND (TIMESTAMPDIFF(WEEK, pe.birthdate, CURDATE()) BETWEEN 6 AND 9) AND et.uuid='9fcfcc91-ad60-4d84-9710-11cc25258719'\n" +
                    " AND p.patient_id NOT IN (SELECT ee.patient_id FROM encounter ee INNER JOIN encounter_type ete ON ee.encounter_type = ete.encounter_type_id WHERE ete.uuid = '8d5b27bc-c2cc-11de-8d13-0010c6dffd0f' AND ee.voided = FALSE)  GROUP BY p.patient_id \n" +
                    " HAVING p.patient_id NOT IN (SELECT oo.person_id FROM obs oo WHERE oo.concept_id = 99606 AND oo.voided = FALSE)\n" +
                    "AND p.patient_id NOT IN (SELECT oo.person_id FROM obs oo WHERE oo.concept_id = 90306 AND oo.voided = FALSE) ";
        }

        @Override
        public String message() {
            return "Due for 1st DNA PCR on ${1}";
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
            return "Due for 1st DNA PCR";
        }

        @Override
        public String description() {
            return "Exposed infants who are due for their first DNA PCR, between 6 to 9 weeks";
        }

        @Override
        public String uuid() {
            return "e8141fdf-4359-461d-840a-216442d45392";
        }
    };

    public static FlagDescriptor OVERDUE_FOR_FIRST_DNA_PCR = new FlagDescriptor() {
        @Override
        public String criteria() {
            return "SELECT p.patient_id , DATE_FORMAT(DATE_ADD(pe.birthdate, INTERVAL 6 WEEK), '%d.%b.%Y') FROM patient p \n" +
                    "  INNER JOIN obs o ON p.patient_id = o.person_id   \n" +
                    "  INNER JOIN person pe ON p.patient_id = pe.person_id \n" +
                    "    INNER JOIN encounter e ON o.encounter_id = e.encounter_id  \n" +
                    "     INNER JOIN encounter_type et ON e.encounter_type = et.encounter_type_id \n" +
                    "WHERE pe.dead=FALSE \n" +
                    "       AND (TIMESTAMPDIFF(WEEK, pe.birthdate, CURDATE()) BETWEEN 10 AND 24) AND et.uuid='9fcfcc91-ad60-4d84-9710-11cc25258719'   AND p.patient_id \n" +
                    " NOT IN (SELECT ee.patient_id FROM encounter ee INNER JOIN encounter_type ete ON ee.encounter_type = ete.encounter_type_id WHERE ete.uuid = '8d5b27bc-c2cc-11de-8d13-0010c6dffd0f' AND ee.voided = FALSE)  GROUP BY p.patient_id  HAVING p.patient_id NOT IN (SELECT oo.person_id FROM obs oo WHERE oo.concept_id = 99606 AND oo.voided = FALSE)\n" +
                    " AND p.patient_id NOT IN (SELECT oo.person_id FROM obs oo WHERE oo.concept_id = 90306 AND oo.voided = FALSE)";
        }

        @Override
        public String message() {
            return "Overdue for 1st DNA PCR from ${1}";
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
            return "Overdue for 1st DNA PCR";
        }

        @Override
        public String description() {
            return "Exposed infants who are overdue for their first DNA PCR who are aged between 10 to 24 weeks";
        }

        @Override
        public String uuid() {
            return "162e4459-24b9-4a0e-ae10-08413d48aecb";
        }
    };

    public static FlagDescriptor DUE_FOR_SECOND_DNA_PCR = new FlagDescriptor() {
        @Override
        public String criteria() {
            return "SELECT p.patient_id , DATE_FORMAT(DATE_ADD(pe.birthdate, INTERVAL 9 MONTH), '%d.%b.%Y') FROM patient p  \n" +
                    " INNER JOIN obs o ON p.patient_id = o.person_id   INNER JOIN person pe ON p.patient_id = pe.person_id  \n" +
                    "  INNER JOIN encounter e ON o.encounter_id = e.encounter_id   INNER JOIN encounter_type et ON e.encounter_type = et.encounter_type_id \n" +
                    "  WHERE pe.dead=FALSE  \n" +
                    "    AND (TIMESTAMPDIFF(MONTH, pe.birthdate, CURDATE()) BETWEEN 9 AND 10) AND et.uuid='9fcfcc91-ad60-4d84-9710-11cc25258719'        \n" +
                    "     AND p.patient_id NOT IN (SELECT ee.patient_id FROM encounter ee INNER JOIN encounter_type ete ON ee.encounter_type = ete.encounter_type_id \n" +
                    "     WHERE ete.uuid = '8d5b27bc-c2cc-11de-8d13-0010c6dffd0f' AND ee.voided = FALSE)  GROUP BY p.patient_id  \n" +
                    "     HAVING p.patient_id NOT IN (SELECT oo.person_id FROM obs oo WHERE oo.concept_id = 99436 AND oo.voided = FALSE)\n" +
                    "   AND p.patient_id NOT IN (SELECT oo.person_id FROM obs oo WHERE oo.concept_id = 90306 AND oo.voided = FALSE)";
        }

        @Override
        public String message() {
            return "Due for 2nd DNA PCR on ${1}";
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
            return "Due for 2nd DNA PCR";
        }

        @Override
        public String description() {
            return "Exposed infants who are due for their second DNA PCR aged between 13 and 14 months";
        }

        @Override
        public String uuid() {
            return "4e0527ed-1a5f-4c83-b372-031829eb334b";
        }
    };

    public static FlagDescriptor OVERDUE_FOR_SECOND_DNA_PCR = new FlagDescriptor() {
        @Override
        public String criteria() {
            return "SELECT p.patient_id , DATE_FORMAT(DATE_ADD(pe.birthdate, INTERVAL 9 MONTH), '%d.%b.%Y') FROM patient p  \n" +
                    " INNER JOIN obs o ON p.patient_id = o.person_id   INNER JOIN person pe ON p.patient_id = pe.person_id  \n" +
                    "  INNER JOIN encounter e ON o.encounter_id = e.encounter_id   INNER JOIN encounter_type et ON e.encounter_type = et.encounter_type_id \n" +
                    "  WHERE pe.dead=FALSE   \n" +
                    "   AND  (TIMESTAMPDIFF(MONTH, pe.birthdate, CURDATE()) BETWEEN 11 AND 13) AND et.uuid='9fcfcc91-ad60-4d84-9710-11cc25258719'     \n" +
                    "       AND p.patient_id NOT IN (SELECT ee.patient_id FROM encounter ee INNER JOIN encounter_type ete ON ee.encounter_type = ete.encounter_type_id \n" +
                    "       WHERE ete.uuid = '8d5b27bc-c2cc-11de-8d13-0010c6dffd0f' AND ee.voided = FALSE)  GROUP BY p.patient_id  \n" +
                    "    HAVING p.patient_id NOT IN (SELECT oo.person_id FROM obs oo WHERE oo.concept_id = 99436 AND oo.voided = FALSE)\n" +
                    "    AND p.patient_id NOT IN (SELECT oo.person_id FROM obs oo WHERE oo.concept_id = 90306 AND oo.voided = FALSE)";
        }

        @Override
        public String message() {
            return "Overdue for 2nd DNA PCR from ${1}";
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
            return "Overue for 2nd DNA PCR";
        }

        @Override
        public String description() {
            return "Exposed infants who are overdue for their second DNA PCR who are between 15 and 17 months since Rapid Test is due at 18 months";
        }

        @Override
        public String uuid() {
            return "356357b4-c285-4a92-82b2-ddcfe6cdf3f4";
        }
    };

    public static FlagDescriptor DUE_FOR_THIRD_DNA_PCR = new FlagDescriptor() {
        @Override
        public String criteria() {
            return "SELECT p.patient_id , DATE_FORMAT(DATE_ADD(pe.birthdate, INTERVAL 13 MONTH), '%d.%b.%Y') FROM patient p  \n" +
                    " INNER JOIN obs o ON p.patient_id = o.person_id   INNER JOIN person pe ON p.patient_id = pe.person_id  \n" +
                    "  INNER JOIN encounter e ON o.encounter_id = e.encounter_id   INNER JOIN encounter_type et ON e.encounter_type = et.encounter_type_id \n" +
                    "  WHERE pe.dead=FALSE  \n" +
                    "    AND (TIMESTAMPDIFF(MONTH, pe.birthdate, CURDATE()) BETWEEN 13 AND 14) AND et.uuid='9fcfcc91-ad60-4d84-9710-11cc25258719'        \n" +
                    "     AND p.patient_id NOT IN (SELECT ee.patient_id FROM encounter ee INNER JOIN encounter_type ete ON ee.encounter_type = ete.encounter_type_id \n" +
                    "     WHERE ete.uuid = '8d5b27bc-c2cc-11de-8d13-0010c6dffd0f' AND ee.voided = FALSE)  GROUP BY p.patient_id  \n" +
                    "     HAVING p.patient_id NOT IN (SELECT oo.person_id FROM obs oo WHERE oo.concept_id = 99436 AND oo.voided = FALSE)\n" +
                    "   AND p.patient_id NOT IN (SELECT oo.person_id FROM obs oo WHERE oo.concept_id = 90306 AND oo.voided = FALSE)";
        }

        @Override
        public String message() {
            return "Due for 3rd DNA PCR on ${1}";
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
            return "Due for 3rd DNA PCR";
        }

        @Override
        public String description() {
            return "Exposed infants who are due for their third DNA PCR aged between 13 and 14 months";
        }

        @Override
        public String uuid() {
            return "636a9bd2-9f13-45ca-886b-9380a959965";
        }
    };


    public static FlagDescriptor OVERDUE_FOR_THIRD_DNA_PCR = new FlagDescriptor() {
        @Override
        public String criteria() {
            return "SELECT p.patient_id , DATE_FORMAT(DATE_ADD(pe.birthdate, INTERVAL 13 MONTH), '%d.%b.%Y') FROM patient p\n" +
                    "                      INNER JOIN obs o ON p.patient_id = o.person_id   INNER JOIN person pe ON p.patient_id = pe.person_id\n" +
                    "                     INNER JOIN encounter e ON o.encounter_id = e.encounter_id   INNER JOIN encounter_type et ON e.encounter_type = et.encounter_type_id\n" +
                    "                      WHERE pe.dead=FALSE\n" +
                    "                       AND  (TIMESTAMPDIFF(MONTH, pe.birthdate, CURDATE()) BETWEEN 15 AND 17) AND et.uuid='9fcfcc91-ad60-4d84-9710-11cc25258719'\n" +
                    "                      AND p.patient_id NOT IN (SELECT ee.patient_id FROM encounter ee INNER JOIN encounter_type ete ON ee.encounter_type = ete.encounter_type_id\n" +
                    "                     WHERE ete.uuid = '8d5b27bc-c2cc-11de-8d13-0010c6dffd0f' AND ee.voided = FALSE)  GROUP BY p.patient_id\n" +
                    "                     HAVING p.patient_id NOT IN (SELECT oo.person_id FROM obs oo WHERE oo.concept_id = 99436 AND oo.voided = FALSE)\n" +
                    "                     AND p.patient_id NOT IN (SELECT oo.person_id FROM obs oo WHERE oo.concept_id = 90306 AND oo.voided = FALSE)";
        }

        @Override
        public String message() {
            return "OverDue for 3rd DNA PCR on ${1}";
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
            return "OverDue for 3rd DNA PCR";
        }

        @Override
        public String description() {
            return "Exposed infants who are overdue for their third DNA PCR, 6 weeks after breastfeeding and having taken a 2nd DNA PCR";
        }

        @Override
        public String uuid() {
            return "65f4da17-5fa3-497e-848f-cc515b69ff81";
        }
    };

    public static FlagDescriptor DUE_FOR_RAPID_TEST = new FlagDescriptor() {
        @Override
        public String criteria() {
            return "SELECT p.patient_id , DATE_FORMAT(DATE_ADD(pe.birthdate, INTERVAL 18 MONTH), '%d.%b.%Y') FROM patient p \n" +
                    "  INNER JOIN obs o ON p.patient_id = o.person_id   INNER JOIN person pe ON p.patient_id = pe.person_id   \n" +
                    "  INNER JOIN encounter e ON o.encounter_id = e.encounter_id   INNER JOIN encounter_type et ON e.encounter_type = et.encounter_type_id \n" +
                    "  WHERE pe.dead=FALSE    \n" +
                    "  AND TIMESTAMPDIFF(MONTH, pe.birthdate, CURDATE()) = 18 AND et.uuid='9fcfcc91-ad60-4d84-9710-11cc25258719'         \n" +
                    "  AND p.patient_id NOT IN (SELECT ee.patient_id FROM encounter ee INNER JOIN encounter_type ete ON ee.encounter_type = ete.encounter_type_id \n" +
                    "  WHERE ete.uuid = '8d5b27bc-c2cc-11de-8d13-0010c6dffd0f' AND ee.voided = FALSE)  GROUP BY p.patient_id  \n" +
                    "  HAVING p.patient_id NOT IN (SELECT oo.person_id FROM obs oo WHERE oo.concept_id = 162879 AND oo.voided = FALSE)\n" +
                    "   AND p.patient_id NOT IN (SELECT oo.person_id FROM obs oo WHERE oo.concept_id = 90306 AND oo.voided = FALSE)";
        }

        @Override
        public String message() {
            return "Due for Rapid Test from ${1}";
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
            return "Due for Rapid Test";
        }

        @Override
        public String description() {
            return "Exposed infants who are due for an 18 month rapid test";
        }

        @Override
        public String uuid() {
            return "f3fb9704-5460-4041-9e77-6d5e9e34c202";
        }
    };

    public static FlagDescriptor OVERDUE_FOR_RAPID_TEST = new FlagDescriptor() {
        @Override
        public String criteria() {
            return "SELECT p.patient_id , DATE_FORMAT(DATE_ADD(pe.birthdate, INTERVAL 18 MONTH), '%d.%b.%Y') FROM patient p \n" +
            "  INNER JOIN obs o ON p.patient_id = o.person_id   INNER JOIN person pe ON p.patient_id = pe.person_id \n" +
                    "    INNER JOIN encounter e ON o.encounter_id = e.encounter_id   INNER JOIN encounter_type et ON e.encounter_type = et.encounter_type_id \n" +
                    "    WHERE pe.dead=FALSE   \n" +
                    "      AND (TIMESTAMPDIFF(MONTH, pe.birthdate, CURDATE()) BETWEEN 19 AND 24) AND et.uuid='9fcfcc91-ad60-4d84-9710-11cc25258719'      \n" +
                    "         AND p.patient_id NOT IN (SELECT ee.patient_id FROM encounter ee \n" +
                    "         INNER JOIN encounter_type ete ON ee.encounter_type = ete.encounter_type_id \n" +
                    "         WHERE ete.uuid = '8d5b27bc-c2cc-11de-8d13-0010c6dffd0f' AND ee.voided = FALSE)  GROUP BY p.patient_id \n" +
                    "          HAVING p.patient_id NOT IN (SELECT oo.person_id FROM obs oo WHERE oo.concept_id = 162879 AND oo.voided = FALSE)\n" +
                    "       AND p.patient_id NOT IN (SELECT oo.person_id FROM obs oo WHERE oo.concept_id = 90306 AND oo.voided = FALSE) ";
        }

        @Override
        public String message() {
            return "Overdue for Rapid Test from ${1}";
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
            return "Overdue for Rapid Test";
        }

        @Override
        public String description() {
            return "Exposed infants who are overdue for an 18 month rapid test but not older than 24 months by which a final outcome is expected";
        }

        @Override
        public String uuid() {
            return "d144893e-b17b-4b77-916e-d3d2b3733378";
        }
    };

    public static FlagDescriptor HAS_DETECTABLE_VIRAL_LOAD = new FlagDescriptor() {
        @Override
        public String criteria() {
            return "SELECT non_suppressed.patient_id, non_suppressed.value_numeric, DATE_FORMAT((non_suppressed.obs_datetime), '%d. %b. %Y')\n" +
                    " FROM (SELECT person_id, MAX(obs_datetime) as dt FROM obs b\n" +
                    "        WHERE b.concept_id = 856 AND b.voided = 0 group by person_id) latest_vl\n" +
                    "      INNER JOIN (SELECT c.person_id as patient_id, obs_datetime, value_numeric\n" +
                    "                  FROM obs c WHERE c.concept_id = 856 AND c.voided = 0 AND c.value_numeric > 1) non_suppressed\n" +
                    "      ON (latest_vl.person_id = non_suppressed.patient_id and latest_vl.dt = non_suppressed.obs_datetime)\n" +
                    "      INNER JOIN person pe ON pe.person_id = non_suppressed.patient_id WHERE pe.dead=FALSE\n" +
                    "      AND non_suppressed.patient_id NOT IN (SELECT oo.person_id FROM obs oo WHERE oo.concept_id = 90306 AND oo.voided = FALSE)";
        }

        @Override
        public String message() {
            return "Detectable Viral Load of ${1} from ${2} may be due for IAC";
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
            return "Un-supressed Viral Load";
        }

        @Override
        public String description() {
            return "Patients who are have un-supressed viral load";
        }

        @Override
        public String uuid() {
            return "151801e2-0742-457f-8610-95530a4db232";
        }
    };

    public static FlagDescriptor PATIENT_TRANSFERED_OUT = new FlagDescriptor() {
        @Override
        public String criteria() {
            return "Select p.patient_id,ooo.value_text ,DATE_FORMAT(oo.value_datetime,'%d. %b. %Y')\n" +
                    "from obs o   INNER JOIN obs oo ON o.person_id=oo.person_id\n" +
                    "INNER JOIN patient p on p.patient_id =o.person_id\n" +
                    " INNER JOIN obs ooo ON o.person_id = ooo.person_id  WHERE o.concept_id =90306  AND o.voided= FALSE \n" +
                    " and oo.concept_id =99165  AND oo.voided = FALSE AND ooo.voided = FALSE  and ooo.concept_id = 90211";
        }

        @Override
        public String message() {
            return "Patient Transfered Out to ${1} on ${2}";
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
            return "Transfered Out Patient";
        }

        @Override
        public String description() {
            return "Patients who are transfered Out to Another Facility";
        }

        @Override
        public String uuid() {
            return "c5cae7e7-d6e3-4d5f-b684-ea888b5a8a7c";
        }
    };
}
