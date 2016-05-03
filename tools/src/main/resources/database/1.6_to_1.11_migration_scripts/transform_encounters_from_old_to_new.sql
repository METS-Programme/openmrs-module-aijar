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

-- Update the encounter types from 1.6.3
-- TODO: Update this script for sites using 1.9.x which have maternity

-- Delete forms causing conflict
TRUNCATE openmrs_backup.form_field;
TRUNCATE openmrs_backup.htmlformentry_html_form;
delete from openmrs_backup.form where form_id not in (select distinct form_id from openmrs_backup.encounter);
delete from openmrs_backup.encounter_type where encounter_type_id not in (select distinct encounter_type from openmrs_backup.encounter);


-- ART SUMMARY
update openmrs_backup.encounter set encounter_type = (select encounter_type_id from openmrs.encounter_type where locate('art',name) > 0 and locate('summary',name) > 0),form_id = (select form_id from openmrs.form where locate('art',name) > 0 and locate('card',name) > 0 and locate('summary',name) > 0) where encounter_type IN (select encounter_type_id from openmrs_backup.encounter_type where locate('summary',name) > 0 and locate('page',name) > 0);
update openmrs_backup.encounter_type set encounter_type_id = (select encounter_type_id from openmrs.encounter_type where locate('art',name) > 0 and locate('summary',name) > 0) where locate('summary',name) > 0 and locate('page',name) > 0;
update openmrs_backup.form set form_id = (select form_id from openmrs.form where locate('art',name) > 0 and locate('card',name) > 0 and locate('summary',name) > 0),encounter_type = (select encounter_type_id from openmrs.encounter_type where locate('art',name) > 0 and locate('summary',name) > 0) where locate('art',name) > 0 and locate('card',name) > 0 and locate('summary',name) > 0 and locate('new',name) = 0;
-- UPDATE encounter_type SET encounter_type_id = 8 WHERE encounter_type_id = 1;
-- UPDATE form SET form_id = 14 WHERE form_id = 28;
-- UPDATE encounter SET encounter_type = 8, form_id = 14 WHERE encounter_type = 1;

-- ART Encounter Page
update openmrs_backup.encounter set encounter_type = (select encounter_type_id from openmrs.encounter_type where locate('art',name) > 0 and locate('card',name) > 0 and locate('encounter',name) > 0 and locate('education',name) = 0),form_id = (select form_id from openmrs.form where locate('art',name) > 0 and locate('card',name) > 0 and locate('encounter',name) > 0) where encounter_type IN (select encounter_type_id from openmrs_backup.encounter_type where locate('encounter',name) > 0 and locate('page',name) > 0);
update openmrs_backup.encounter_type set encounter_type_id = (select encounter_type_id from openmrs.encounter_type where locate('art',name) > 0 and locate('card',name) > 0 and locate('encounter',name) > 0 and locate('education',name) = 0) where locate('encounter',name) > 0 and locate('page',name) > 0;
update openmrs_backup.form set form_id = (select form_id from openmrs.form where locate('art',name) > 0 and locate('card',name) > 0 and locate('encounter',name) > 0),encounter_type = (select encounter_type_id from openmrs.encounter_type where locate('art',name) > 0 and locate('card',name) > 0 and locate('encounter',name) > 0 and locate('education',name) = 0) where locate('art',name) > 0 and locate('card',name) > 0 and locate('encounter',name) > 0 and locate('new',form.name) = 0;
-- UPDATE encounter_type SET encounter_type_id = 9 WHERE encounter_type_id = 2;
-- UPDATE form SET form_id = 12 WHERE form_id =27;
-- UPDATE encounter SET encounter_type = 9, form_id = 12 WHERE encounter_type = 2;

-- ART Health Education
update openmrs_backup.encounter set encounter_type = (select encounter_type_id from openmrs.encounter_type where locate('art',name) > 0 and locate('card',name) > 0 and locate('education',name) > 0),form_id = (select form_id from openmrs.form where locate('art',name) > 0 and locate('card',name) > 0 and locate('education',name) > 0) where encounter_type IN (select encounter_type_id from openmrs_backup.encounter_type where locate('health',name) > 0 and locate('education',name) > 0);
update openmrs_backup.encounter_type set encounter_type_id = (select encounter_type_id from openmrs.encounter_type where locate('art',name) > 0 and locate('card',name) > 0 and locate('education',name) > 0) where locate('health',name) > 0 and locate('education',name) > 0;
UPDATE openmrs_backup.form
SET form_id      = (SELECT form_id
                    FROM openmrs.form
                    WHERE locate('art', name) > 0 AND locate('card', name) > 0 AND locate('education', name) > 0),
  encounter_type = (SELECT encounter_type_id
                    FROM openmrs.encounter_type
                    WHERE locate('art', name) > 0 AND locate('card', name) > 0 AND locate('education', name) > 0)
WHERE locate('art', name) > 0 AND locate('card', name) > 0 AND locate('education', name) > 0 AND locate('new', name) = 0;

-- UPDATE encounter_type SET encounter_type_id = 11 WHERE encounter_type_id = 11;
-- UPDATE form SET form_id = 13 WHERE form_id = 34;
-- UPDATE encounter SET encounter_type = 11, form_id = 13 WHERE encounter_type = 11;

/*!40101 SET SQL_MODE = @OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS = @OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS = @OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT = @OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS = @OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION = @OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES = @OLD_SQL_NOTES */;
