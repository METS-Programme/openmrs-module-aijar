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

/* The address hierarchy may be installed before so this causes problems - remove instal trail of the address hierarchy */
DELETE FROM global_property
WHERE property IN
      ('address.format', 'addresshierarchy.database_version', 'addresshierarchy.mandatory', 'addresshierarchy.started');

/* Drop the address hierarchy tables if necessary */
ALTER TABLE address.address_hierarchy_address_to_entry_map DROP FOREIGN KEY address_id_to_person_address_table;
ALTER TABLE address.address_hierarchy_address_to_entry_map DROP FOREIGN KEY entry_id_to_address_hierarchy_table;
ALTER TABLE address.address_hierarchy_entry DROP FOREIGN KEY level_to_level;
ALTER TABLE address.address_hierarchy_entry DROP FOREIGN KEY `parent-to-parent`;
ALTER TABLE address.address_hierarchy_level DROP FOREIGN KEY parent_level;
DROP TABLE address.address_hierarchy_address_to_entry_map;
DROP TABLE address.address_hierarchy_entry;
DROP TABLE address.address_hierarchy_level;

/*!40101 SET SQL_MODE = @OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS = @OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS = @OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT = @OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS = @OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION = @OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES = @OLD_SQL_NOTES */;