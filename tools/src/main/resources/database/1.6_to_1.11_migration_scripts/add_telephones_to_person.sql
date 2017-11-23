DROP PROCEDURE IF EXISTS add_telephones;

DELIMITER $$
CREATE DEFINER=`openmrs`@`localhost` PROCEDURE `add_telephones`()
  BEGIN
    DECLARE telephone_attribute TEXT;

    SELECT person_attribute_type_id INTO telephone_attribute FROM person_attribute_type where uuid = '14d4f066-15f5-102d-96e4-000c29c2a5d7';

    SELECT 'Creating telephone contacts' AS log;

    -- In the old system forms, telephone numbers were saved in person_address table on postal_code column, refer to the old forms

    -- Selecting only valid numbers

    INSERT INTO person_attribute(person_id, value, person_attribute_type_id, creator, date_created, voided, uuid) SELECT person_id,postal_code,telephone_attribute,creator,date_created, 0, UUID() FROM person_address where postal_code is not null;

    -- TODO Process invalid numbers by splitting by either slash or space and validating each of the numbers
    -- TODO Process invalid numbers by removing all non numbers from it and then validating
    -- TODO Ascertain if users can have more than one number

  END$$
DELIMITER ;

call add_telephones();
SELECT 'Creating telephone contacts complete' AS log;
