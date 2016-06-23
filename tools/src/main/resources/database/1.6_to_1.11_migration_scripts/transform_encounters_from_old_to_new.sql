/*!40101 SET @OLD_CHARACTER_SET_CLIENT = @@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS = @@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION = @@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE = @@TIME_ZONE */;
/*!40103 SET TIME_ZONE = '+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS = @@UNIQUE_CHECKS, UNIQUE_CHECKS = 0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS = @@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS = 0 */;
/*!40101 SET @OLD_SQL_MODE = @@SQL_MODE, SQL_MODE = 'NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES = @@SQL_NOTES, SQL_NOTES = 0 */;

TRUNCATE openmrs_backup.form_field;
TRUNCATE openmrs_backup.htmlformentry_html_form;
DELETE FROM openmrs_backup.form
WHERE form_id NOT IN (SELECT DISTINCT form_id
                      FROM openmrs_backup.encounter);
DELETE FROM openmrs_backup.encounter_type
WHERE encounter_type_id NOT IN (SELECT DISTINCT encounter_type
                                FROM openmrs_backup.encounter);
-- ART SUMMARY
UPDATE openmrs_backup.encounter_type
SET encounter_type_id = 50
WHERE encounter_type_id = (SELECT encounter_type_id
                           FROM openmrs.encounter_type
                           WHERE locate('art', name) > 0 AND locate('summary', name) > 0);
UPDATE openmrs_backup.form
SET form_id = 50
WHERE form_id = (SELECT form_id
                 FROM openmrs.form
                 WHERE locate('art', name) > 0 AND locate('card', name) > 0 AND locate('summary', name) > 0);
UPDATE openmrs_backup.encounter
SET encounter_type = (SELECT encounter_type_id
                      FROM openmrs.encounter_type
                      WHERE locate('art', name) > 0 AND locate('summary', name) > 0), form_id = (SELECT form_id
                                                                                                 FROM openmrs.form
                                                                                                 WHERE
                                                                                                   locate('art', name) > 0
                                                                                                   AND
                                                                                                   locate('card', name) > 0
                                                                                                   AND
                                                                                                   locate('summary', name) >
                                                                                                   0)
WHERE encounter_type IN (SELECT encounter_type_id
                         FROM openmrs_backup.encounter_type
                         WHERE locate('summary', name) > 0 AND locate('page', name) > 0);
UPDATE openmrs_backup.encounter_type
SET encounter_type_id = (SELECT encounter_type_id
                         FROM openmrs.encounter_type
                         WHERE locate('art', name) > 0 AND locate('summary', name) > 0)
WHERE locate('summary', name) > 0 AND locate('page', name) > 0;
UPDATE openmrs_backup.form
SET form_id                                                                                                                = (SELECT
                                                                                                                                form_id
                                                                                                                              FROM
                                                                                                                                openmrs.form
                                                                                                                              WHERE
                                                                                                                                locate(
                                                                                                                                    'art',
                                                                                                                                    name)
                                                                                                                                >
                                                                                                                                0
                                                                                                                                AND
                                                                                                                                locate(
                                                                                                                                    'card',
                                                                                                                                    name)
                                                                                                                                >
                                                                                                                                0
                                                                                                                                AND
                                                                                                                                locate(
                                                                                                                                    'summary',
                                                                                                                                    name)
                                                                                                                                >
                                                                                                                                0),
  encounter_type                                                                                                           = (SELECT
                                                                                                                                encounter_type_id
                                                                                                                              FROM
                                                                                                                                openmrs.encounter_type
                                                                                                                              WHERE
                                                                                                                                locate(
                                                                                                                                    'art',
                                                                                                                                    name)
                                                                                                                                >
                                                                                                                                0
                                                                                                                                AND
                                                                                                                                locate(
                                                                                                                                    'summary',
                                                                                                                                    name)
                                                                                                                                >
                                                                                                                                0)
WHERE locate('art', name) > 0 AND locate('card', name) > 0 AND locate('summary', name) > 0 AND locate('new', name) = 0;

-- ART Encounter Page
UPDATE openmrs_backup.encounter_type
SET encounter_type_id = 60
WHERE encounter_type_id = (SELECT encounter_type_id
                           FROM openmrs.encounter_type
                           WHERE locate('art', name) > 0 AND locate('card', name) > 0 AND locate('encounter', name) > 0 AND
                                 locate('education', name) = 0);
UPDATE openmrs_backup.form
SET form_id = 60
WHERE form_id = (SELECT form_id
                 FROM openmrs.form
                 WHERE locate('art', name) > 0 AND locate('card', name) > 0 AND locate('encounter', name) > 0);
UPDATE openmrs_backup.encounter
SET encounter_type = (SELECT encounter_type_id
                      FROM openmrs.encounter_type
                      WHERE locate('art', name) > 0 AND locate('card', name) > 0 AND locate('encounter', name) > 0 AND
                            locate('education', name) = 0), form_id = (SELECT form_id
                                                                       FROM openmrs.form
                                                                       WHERE
                                                                         locate('art', name) > 0 AND locate('card', name) > 0
                                                                         AND locate('encounter', name) > 0)
WHERE encounter_type IN (SELECT encounter_type_id
                         FROM openmrs_backup.encounter_type
                         WHERE locate('encounter', name) > 0 AND locate('page', name) > 0);
UPDATE openmrs_backup.encounter_type
SET encounter_type_id = (SELECT encounter_type_id
                         FROM openmrs.encounter_type
                         WHERE locate('art', name) > 0 AND locate('card', name) > 0 AND locate('encounter', name) > 0 AND
                               locate('education', name) = 0)
WHERE locate('encounter', name) > 0 AND locate('page', name) > 0;
UPDATE openmrs_backup.form
SET form_id      = (SELECT form_id
                    FROM openmrs.form
                    WHERE locate('art', name) > 0 AND locate('card', name) > 0 AND locate('encounter', name) > 0),
  encounter_type = (SELECT encounter_type_id
                    FROM openmrs.encounter_type
                    WHERE locate('art', name) > 0 AND locate('card', name) > 0 AND locate('encounter', name) > 0 AND
                          locate('education', name) = 0)
WHERE
  locate('art', name) > 0 AND locate('card', name) > 0 AND locate('encounter', name) > 0 AND locate('new', form.name) = 0;

-- ART Health Education
UPDATE openmrs_backup.encounter_type
SET encounter_type_id = 70
WHERE encounter_type_id = (SELECT encounter_type_id
                           FROM openmrs.encounter_type
                           WHERE locate('art', name) > 0 AND locate('card', name) > 0 AND locate('education', name) > 0);
UPDATE openmrs_backup.form
SET form_id = 70
WHERE form_id = (SELECT form_id
                 FROM openmrs.form
                 WHERE locate('art', name) > 0 AND locate('card', name) > 0 AND locate('education', name) > 0);
UPDATE openmrs_backup.encounter
SET encounter_type = (SELECT encounter_type_id
                      FROM openmrs.encounter_type
                      WHERE locate('art', name) > 0 AND locate('card', name) > 0 AND locate('education', name) > 0),
  form_id          = (SELECT form_id
                      FROM openmrs.form
                      WHERE locate('art', name) > 0 AND locate('card', name) > 0 AND locate('education', name) > 0)
WHERE encounter_type IN (SELECT encounter_type_id
                         FROM openmrs_backup.encounter_type
                         WHERE locate('health', name) > 0 AND locate('education', name) > 0);
UPDATE openmrs_backup.encounter_type
SET encounter_type_id = (SELECT encounter_type_id
                         FROM openmrs.encounter_type
                         WHERE locate('art', name) > 0 AND locate('card', name) > 0 AND locate('education', name) > 0)
WHERE locate('health', name) > 0 AND locate('education', name) > 0;
UPDATE openmrs_backup.form
SET form_id      = (SELECT form_id
                    FROM openmrs.form
                    WHERE locate('art', name) > 0 AND locate('card', name) > 0 AND locate('education', name) > 0),
  encounter_type = (SELECT encounter_type_id
                    FROM openmrs.encounter_type
                    WHERE locate('art', name) > 0 AND locate('card', name) > 0 AND locate('education', name) > 0)
WHERE locate('art', name) > 0 AND locate('card', name) > 0 AND locate('education', name) > 0 AND locate('new', name) = 0;


/*!40101 SET SQL_MODE = @OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS = @OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS = @OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT = @OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS = @OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION = @OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES = @OLD_SQL_NOTES */;
