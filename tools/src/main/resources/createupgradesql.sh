#!/usr/bin/env bash
# This script creates a new upgrade file

# Turns off foreign key cheks to speed up script execution
cat database/mysql_script_header.sql > upgrade/upgrade.sql

# adds the current concept dictionary
cat database/concept_dictonary_ref.sql >> upgrade/upgrade.sql

# adds functions and procedures for BIRT reports
cat database/enable_birt_report_function.sql >> upgrade/upgrade.sql

# cleans up the data integrity module which will be re-installed
cat database/cleanup_data_integrity_module.sql >> upgrade/upgrade.sql

# Turns on foreign key checks
cat database/mysql_script_footer.sql >> upgrade/upgrade.sql
