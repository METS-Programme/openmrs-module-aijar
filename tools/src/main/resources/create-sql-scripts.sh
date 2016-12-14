#!/usr/bin/env bash

# Turns off foreign key cheks to speed up script execution
cat database/mysql_script_header.sql > upgrade/new-install.sql

# Base platform from OpenMRS SDK
cat database/openmrs-platform.sql >> upgrade/new-install.sql

# adds the current concept dictionary
cat database/concept_dictonary_ref.sql >> upgrade/new-install.sql

# adds functions and procedures for BIRT reports
cat database/enable_birt_report_function.sql >> upgrade/new-install.sql

# cleans up the data integrity module which will be re-installed
cat database/cleanup_data_integrity_module.sql >> upgrade/new-install.sql

# Turns on foreign key checks
cat database/mysql_script_footer.sql >> upgrade/new-install.sql

#Copying new-install.sql to new_install directory
cp upgrade/new-install.sql new_install/new-install.sql

# Create an SQL script for an upgrade

# Turns off foreign key checks to speed up script execution
cat database/mysql_script_header.sql > upgrade/upgrade_1_6_x.sql
cat database/mysql_script_header.sql > upgrade/upgrade_1_9_x.sql

# adds the current concept dictionary
cat database/concept_dictonary_ref.sql >> upgrade/upgrade_1_6_x.sql
cat database/concept_dictonary_ref.sql >> upgrade/upgrade_1_9_x.sql

# transform encounters from pre-1.11
cat database/1.6_to_1.11_migration_scripts/transform_encounters_from_old_to_new.sql >> upgrade/upgrade_1_6_x.sql
cat database/1.6_to_1.11_migration_scripts/transform_encounters_from_old_to_new.sql >> upgrade/upgrade_1_9_x.sql

#Delete address hierarchy tables in openmrs_backup database
cat database/1.6_to_1.11_migration_scripts/delete_address_hierarchy.sql >> upgrade/upgrade_1_9_x.sql

# Actual data migration from the openmrs_backup to openmrs database
cat database/1.6_to_1.11_migration_scripts/1.6.3_to_1.11_data_transfer.sql >> upgrade/upgrade_1_6_x.sql
cat database/1.6_to_1.11_migration_scripts/1.9.1_to_1.11_data_transfer.sql >> upgrade/upgrade_1_9_x.sql

# add visits to encounters - which is required in 1.11.x
cat database/1.6_to_1.11_migration_scripts/add_visit_to_encounter.sql >> upgrade/upgrade_1_6_x.sql
cat database/1.6_to_1.11_migration_scripts/add_visit_to_encounter.sql >> upgrade/upgrade_1_9_x.sql

# moved phone numbers from to new person attribute only after data has been moved
cat database/1.6_to_1.11_migration_scripts/add_telephones_to_person.sql >> upgrade/upgrade_1_6_x.sql;

# adds functions and procedures for BIRT reports
cat database/enable_birt_report_function.sql >> upgrade/upgrade_1_6_x.sql
cat database/enable_birt_report_function.sql >> upgrade/upgrade_1_9_x.sql

# update report objects in the database to match the ones in the BIRT folder
cat database/update_birt_report_objects.sql >> upgrade/upgrade_1_6_x.sql
cat database/update_birt_report_objects.sql >> upgrade/upgrade_1_9_x.sql

# cleans up the data integrity module which will be re-installed
cat database/cleanup_data_integrity_module.sql >> upgrade/upgrade_1_6_x.sql
cat database/cleanup_data_integrity_module.sql >> upgrade/upgrade_1_9_x.sql

# Turns on foreign key checks
cat database/mysql_script_footer.sql >> upgrade/upgrade_1_6_x.sql
cat database/mysql_script_footer.sql >> upgrade/upgrade_1_9_x.sql