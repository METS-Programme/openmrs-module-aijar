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
TRUNCATE form_field;
TRUNCATE htmlformentry_html_form;
DELETE FROM form
WHERE LOWER(name) LIKE '%imai%' OR LOWER(name) LIKE '%lab form%';

-- ART SUMMARY
UPDATE encounter_type
SET encounter_type_id = 8
WHERE encounter_type_id = 1;
UPDATE form
SET form_id = 14
WHERE form_id = ;
UPDATE encounter
SET encounter_type = 8, form_id = 14
WHERE encounter_type = 1;

-- ART Encounter Page
UPDATE encounter_type
SET encounter_type_id = 9
WHERE encounter_type_id = 2;
UPDATE form
SET form_id = 12
WHERE form_id = XX;
UPDATE encounter
SET encounter_type = 9, form_id = 12
WHERE encounter_type = 2;

-- ART Health Education
UPDATE encounter_type
SET encounter_type_id = 11
WHERE encounter_type_id = 11;
UPDATE form
SET form_id = 13
WHERE form_id = XX;
UPDATE encounter
SET encounter_type_id = 11, form_id = 13
WHERE encounter_type_id = 11;

/*!40101 SET SQL_MODE = @OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS = @OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS = @OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT = @OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS = @OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION = @OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES = @OLD_SQL_NOTES */;