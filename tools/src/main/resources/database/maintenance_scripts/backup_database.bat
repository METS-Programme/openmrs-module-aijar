rem Get the datetime in a format that can go in a filename.
set _my_datetime=%date%_%time%
set _my_datetime=%_my_datetime: =_%
set _my_datetime=%_my_datetime::=%
set _my_datetime=%_my_datetime:/=_%
set _my_datetime=%_my_datetime:.=_%

C:\Program Files\WHO\OpenMRS\mysql-5.0.51a-win32\bin\mysqldump --port=3307 -u root --opt --routines openmrs >
openmrs%_my_datetime%.sql