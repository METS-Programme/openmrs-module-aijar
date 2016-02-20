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

/* Change the admin to have userid 2 to enable the liquibase changesets to work, First move all forms to the daemon user then back to admin before changing the admin id to 2
*/
UPDATE htmlformentry_html_form
SET changed_by = 52
WHERE changed_by = 1;
UPDATE htmlformentry_html_form
SET creator = 52
WHERE creator = 1;
UPDATE notification_alert
SET alert_creator = 52
WHERE alert_creator = 1;
UPDATE notification_alert_recipient
SET alert_read_by_user = 52
WHERE alert_read_by_user = 1;
UPDATE users
SET user_id = 2
WHERE user_id = 1;
UPDATE htmlformentry_html_form
SET changed_by = 2
WHERE changed_by = 52;
UPDATE htmlformentry_html_form
SET creator = 2
WHERE creator = 52;
UPDATE notification_alert
SET alert_creator = 2
WHERE alert_creator = 52;
UPDATE notification_alert_recipient
SET alert_read_by_user = 2
WHERE alert_read_by_user = 52;

/* Change the daemon user to have userid 1 to enable the liquibase changesets to work */
UPDATE users
SET user_id = 1
WHERE user_id = 52;
UPDATE scheduler_task_config
SET changed_by = 1
WHERE changed_by = 52;

/* Update the user roles from admin to the daemon user */
UPDATE user_role
SET user_id = 1
WHERE user_id = 2;

/*!40101 SET SQL_MODE = @OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS = @OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS = @OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT = @OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS = @OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION = @OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES = @OLD_SQL_NOTES */;