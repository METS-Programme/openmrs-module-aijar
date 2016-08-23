DROP PROCEDURE IF EXISTS `mergeSummaryPages`;

DELIMITER $$
CREATE DEFINER=`openmrs`@`localhost` PROCEDURE `mergeSummaryPages`()
  BEGIN

    DECLARE patient TEXT;
    DECLARE ecnounter TEXT;
    DECLARE total TEXT;
    DECLARE found_string TEXT;
    DECLARE occurance INT;
    DECLARE i INT DEFAULT 2;
    DECLARE  e_id CHAR(8);
    DECLARE done INT DEFAULT FALSE;
    DECLARE cursor_i CURSOR FOR select e.patient_id,group_concat(encounter_id),count(*) as encounters from encounter e inner join encounter_type et on(et.uuid = '8d5b27bc-c2cc-11de-8d13-0010c6dffd0f' and e.encounter_type = et.encounter_type_id ) group by e.patient_id,e.encounter_type HAVING COUNT(*) > 1 order by e.encounter_id;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    -- Temp table to hold encounter ids
    DROP TEMPORARY TABLE IF EXISTS tb;
    CREATE TABLE IF NOT EXISTS tb(`encounter_id` INT);

    -- Table to hold all duplicated encounters
    DROP TABLE IF EXISTS duplicate_encounters;
    CREATE TABLE IF NOT EXISTS duplicate_encounters(`encounter_id` INT);

    -- Table to hold all merged observations
    DROP TABLE IF EXISTS summary_obs;
    CREATE TABLE summary_obs LIKE obs;

    -- Table to hold all cleaned observations
    DROP TABLE IF EXISTS new_obs;
    CREATE TABLE new_obs LIKE obs;

    SELECT 'Trying to merge summary pages if there are patients with more than one' as log;

    -- Delete encounters without observations

    delete from encounter where encounter_id not in (select encounter_id from obs);

    -- Delete visits without encounters

    delete from visit where visit_id not in (select visit_id from encounter);

    OPEN cursor_i;
    read_loop: LOOP
      FETCH cursor_i INTO patient,ecnounter,total;
      IF done THEN
        LEAVE read_loop;
      END IF;
      -- truncate to hold next set of encounter ids
      TRUNCATE tb;
      SET i=1;
      WHILE i <= total DO
        SET e_id = substring_index (substring_index ( ecnounter,',',i ), ',', -1);
        -- insert each id into the temp table
        insert into tb(encounter_id) VALUES (e_id);
        SET i = i + 1;
      END WHILE;

      insert into duplicate_encounters(encounter_id) SELECT encounter_id from tb;

      -- Create temp table hold current obs to process

      select 'Creating temp table' as log;

      CREATE TEMPORARY TABLE IF NOT EXISTS temp_obs AS (SELECT * FROM obs where encounter_id in (SELECT encounter_id from tb));

      -- Create another table grouping by concepts to remove duplicate concepts only remaining with clean

      CREATE TEMPORARY TABLE IF NOT EXISTS temp_obs_2 AS (SELECT * FROM temp_obs group by concept_id);

      -- Update un duplicate table with most current encounter_id

      UPDATE temp_obs_2 SET encounter_id = (SELECT MAX(encounter_id) from temp_obs);

      -- Insert  updated data into temporary location

      insert into summary_obs (obs_id, person_id, concept_id, encounter_id, order_id, obs_datetime, location_id, obs_group_id, accession_number, value_group_id, value_boolean, value_coded_name_id, value_drug, value_datetime, value_numeric, value_modifier, value_text, value_complex, comments, creator, date_created, voided, voided_by, date_voided, void_reason, uuid, previous_version, form_namespace_and_path) select obs_id, person_id, concept_id, encounter_id, order_id, obs_datetime, location_id, obs_group_id, accession_number, value_group_id, value_boolean, value_coded_name_id, value_drug, value_datetime, value_numeric, value_modifier, value_text, value_complex, comments, creator, date_created, voided, voided_by, date_voided, void_reason, uuid, previous_version, form_namespace_and_path from temp_obs_2;

      drop TEMPORARY TABLE  temp_obs;
      drop TEMPORARY TABLE  temp_obs_2;

      select 'Next patient' as log;

    END LOOP;
    CLOSE cursor_i;

    -- Re-import old observations to temporary table

    insert into new_obs (select * from obs where encounter_id not in (select encounter_id from duplicate_encounters));

    -- Import merged observations to temporary table

    insert into new_obs (select * from summary_obs);

    -- Rename obs and new_obs tables to restored merged data

    rename table obs to obs_drop, new_obs to obs;

    -- Delete all working tables

    drop table obs_drop;
    drop table duplicate_encounters;
    drop table summary_obs;

    -- Delete encounters without observations

    delete from encounter where encounter_id not in (select encounter_id from obs);

    -- Delete visits without encounters

    delete from visit where visit_id not in (select visit_id from encounter);

    select 'Merge Successful' as log;

  END$$
DELIMITER ;

call mergeSummaryPages();