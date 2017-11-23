 /* Remove the data integrity change log records */
DELETE FROM global_property WHERE property LIKE '%dataintegrity%';


/* Remove the data integrity change log records */
DELETE FROM liquibasechangelog WHERE ID LIKE '%dataintegrity%';

/* Drop any existing data integrity tables */
ALTER TABLE dataintegrity_run DROP FOREIGN KEY integrity_check_for_run;
ALTER TABLE dataintegrity_run DROP FOREIGN KEY user_who_ran_integrity_check;
ALTER TABLE dataintegrity_result DROP FOREIGN KEY integrity_check_for_result;
ALTER TABLE dataintegrity_result DROP FOREIGN KEY user_who_created_integrity_check_result;
ALTER TABLE dataintegrity_column DROP FOREIGN KEY integrity_check_for_column;
ALTER TABLE dataintegrity_check DROP FOREIGN KEY integrity_check_changed_by;
ALTER TABLE dataintegrity_check DROP FOREIGN KEY integrity_check_creator;
ALTER TABLE dataintegrity_check DROP FOREIGN KEY integrity_check_retired_by;
DROP TABLE IF EXISTS dataintegrity_run;
DROP TABLE IF EXISTS dataintegrity_result;
DROP TABLE IF EXISTS dataintegrity_column;
DROP TABLE IF EXISTS dataintegrity_check;
DROP TABLE IF EXISTS dataintegrity_integrity_checks;