@rem Backup the database including stored procedures required to run reports

@IF EXIST new-install.sql (
ECO OFF
for /f "delims=" %%a in ('wmic OS Get localdatetime  ^| find "."') do set dt=%%a
set YYYY=%dt:~0,4%
set MM=%dt:~4,2%
set DD=%dt:~6,2%
set HH=%dt:~8,2%
set Min=%dt:~10,2%
set Sec=%dt:~12,2%

set stamp=%YYYY%-%MM%-%DD%_%HH%-%Min%-%Sec%
ECO
@echo Backingup exisiting openmrs database
@mysqldump  -u openmrs -popenmrs --opt --routines openmrs > openmrs_reset_backup_%stamp%.sql

@REM Resetting openmrs database to default for UgandaEMR
@echo Database backup done close this window

@echo Deleting existing openmrs database
@mysql --port=3306 -u openmrs -popenmrs -e "drop database if exists openmrs;"
@echo creating a new database openmrs
@mysql --port=3306 -u openmrs -popenmrs -e "create database openmrs;"
@echo Starting to load openmrs database with blank new-install.sql script
@mysql --port=3306 -u openmrs -popenmrs openmrs < new-install.sql

@echo openmrs blank database script loaded into openmrs database. Close to Complete.
@PAUSE > nul
)ELSE (
@ECHO The new-install.sql file is missing, please provide that file to enable the reset
@PAUSE > nul
)
