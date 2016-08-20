@REM run the backup file from the  1.6.3 database if it exists, into the openmrs_backup directory


@IF EXIST database.sql (
@mysql --port=3306 -u root -e "drop database if exists openmrs_backup;"
@mysql --port=3306 -u root -e "create database openmrs_backup;" 		
@mysql --port=3306 -u root openmrs_backup < database.sql



@echo database.sql script loaded into openmrs_backup database	

@REM  Now copy the data from openmrs_backup into the openmrs_script
    

mysql --port=3306 -u root openmrs < upgrade_1_9_x.sql


@echo Migration from 1.6.3 to 1.11.6 completed
@PAUSE > nul


) ELSE (
    

@ECHO The database.sql file is missing, please provide that file to enable the upgrade
@PAUSE > nul

)

