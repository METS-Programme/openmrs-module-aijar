REM create OpenMRS user and database in the new server
mysql -u root --port 3306 -e "create database openmrs; GRANT ALL PRIVILEGES ON openmrs.* TO 'openmrs'@'localhost'
IDENTIFIED BY 'openmrs';"

REM dump the data from the old server into the new one
mysqldump -u root --port 3307 openmrs | mysql -u openmrs -popenmrs --port 3306 openmrs

REM run the migration preparation scripts
mysql -u openmrs -popenmrs --port 3306 openmrs -v -v < pre-migration.sql
mysql -u openmrs -popenmrs --port 3306 openmrs -v -v < concept_data_cleanup.sql

REM there have been sites with failed addresshierarchy module installation, reset the global variables
mysql -u openmrs -popenmrs --port 3306 openmrs -v -v < addresshierarchy.sql
