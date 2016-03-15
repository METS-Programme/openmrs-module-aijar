#!/usr/bin/env bash

mysql -u root -proot -e "DROP database openmrs_backup; create database openmrs_backup;"
mysql -u root -proot openmrs_backup <  /Users/ssmusoke/DevWorkArea/Migrations/openmrsWed_03_09_2016_102739_06.sql
mysql -u root -proot openmrs_backup < tools/src/main/resources/database/1.6_to_1.11_migration_scripts/transform_encounters_from_old_to_new.sql
mysql -u root -proot -e "DROP database openmrs; create database openmrs;"
mysql -u root -proot openmrs < tools/src/main/resources/database/openmrs1.11.6_empty_db.sql
mysql -u root -proot openmrs < /Users/ssmusoke/DevWorkArea/Migrations/concept_dictonary_ref08032016.sql
mysql -u root -proot openmrs < tools/src/main/resources/database/1.6_to_1.11_migration_scripts/1.6_to_1.11_data_transfer.sql
mysql -u root -proot openmrs < tools/src/main/resources/database/1.6_to_1.11_migration_scripts/add_visit_to_encounter.sql