
update openmrs_backup.address_hierarchy_entry set parent_id=NULL;
delete from openmrs_backup.address_hierarchy_entry;
update openmrs_backup.address_hierarchy_level set parent_level_id=NULL;
delete from openmrs_backup.address_hierarchy_level;

