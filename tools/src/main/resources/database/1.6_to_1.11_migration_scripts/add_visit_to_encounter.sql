/**Script to upgrade patient encounters to display in the reference app - By METS Project - Revised Jan 2016. Used when upgrading from 1.9.1 to 2.0*/


/** update the visit table */
SELECT 'Adding visits to encounters' as log;
INSERT INTO visit (patient_id, visit_type_id, date_started, date_stopped, location_id, creator, date_created, uuid, changed_by, date_changed)
  SELECT
    patient_id,
    1,
    encounter_datetime,
    encounter_datetime,
    location_id,
    creator,
    encounter_datetime,
    UUID(),
    creator,
    encounter_datetime
  FROM encounter
  WHERE encounter.visit_id IS NULL;

/** Add the visit created above to the encounter for which it belongs **/
UPDATE encounter e INNER JOIN visit v ON (
  e.patient_id = v.patient_id AND e.encounter_datetime = v.date_started AND e.creator = v.creator AND
  e.location_id = v.location_id AND e.visit_id IS NULL)
SET e.visit_id = v.visit_id;

SELECT 'Adding visits to encounters complete' as log;
