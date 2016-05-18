  DROP PROCEDURE IF EXISTS `getARTData`;
  DROP PROCEDURE IF EXISTS `GetARTFollowupData0_24`;
  DROP PROCEDURE IF EXISTS `GetARTFollowupData25_48`;
  DROP PROCEDURE IF EXISTS `GetARTFollowupData49_72`;
  DROP PROCEDURE IF EXISTS `getPreARTData`;
  DROP PROCEDURE IF EXISTS `getPreARTFollowup`;
  DROP PROCEDURE IF EXISTS `hmis106a1a`;
  DROP PROCEDURE IF EXISTS `hmis106a1aYouth`;
  DROP PROCEDURE IF EXISTS `hmis106a1b`;
  DROP PROCEDURE IF EXISTS `hmis105EID`;
  DROP PROCEDURE IF EXISTS `mergeSummaryPages`;
  DROP PROCEDURE IF EXISTS `transfer`;


  DROP FUNCTION IF EXISTS `get_adherence_Count`;
  DROP FUNCTION IF EXISTS `get_adherenceType_Count`;
  DROP FUNCTION IF EXISTS `getADHStatusTxt`;
  DROP FUNCTION IF EXISTS `getAncNumberTxt`;
  DROP FUNCTION IF EXISTS `getAppKeepTxt`;
  DROP FUNCTION IF EXISTS `getArtBaseTransferDate`;
  DROP FUNCTION IF EXISTS `getArtEligibilityAndReadyDate`;
  DROP FUNCTION IF EXISTS `getArtEligibilityDate`;
  DROP FUNCTION IF EXISTS `getArtEligibilityReasonTxt`;
  DROP FUNCTION IF EXISTS `getArtRegCoded`;
  DROP FUNCTION IF EXISTS `getArtRegCoded2`;
  DROP FUNCTION IF EXISTS `getArtRegTxt`;
  DROP FUNCTION IF EXISTS `getArtRegTxt2`;
  DROP FUNCTION IF EXISTS `getArtRestartDate`;
  DROP FUNCTION IF EXISTS `getArtStartDate`;
  DROP FUNCTION IF EXISTS `getArtStartDate2`;
  DROP FUNCTION IF EXISTS `getArtStartRegTxt`;
  DROP FUNCTION IF EXISTS `getArtStopDate`;
  DROP FUNCTION IF EXISTS `getArtStopDate1`;
  DROP FUNCTION IF EXISTS `getArtStopReasonTxt`;
  DROP FUNCTION IF EXISTS `getBaseWeightValue`;
  DROP FUNCTION IF EXISTS `getCareEntryTxt`;
  DROP FUNCTION IF EXISTS `getCd4BaseValue`;
  DROP FUNCTION IF EXISTS `get_CD4_count`;
  DROP FUNCTION IF EXISTS `getCd4SevereBaseValue`;
  DROP FUNCTION IF EXISTS `getCD4Value`;
  DROP FUNCTION IF EXISTS `getCodedDeathDate`;
  DROP FUNCTION IF EXISTS `getCohortAllBefore10`;
  DROP FUNCTION IF EXISTS `getCohortAllBefore11`;
  DROP FUNCTION IF EXISTS `getCohortAllBefore12`;
  DROP FUNCTION IF EXISTS `getCohortAllBefore15a`;
  DROP FUNCTION IF EXISTS `getCohortAllBefore15b`;
  DROP FUNCTION IF EXISTS `getCohortAllBefore16`;
  DROP FUNCTION IF EXISTS `getCohortAllBefore3`;
  DROP FUNCTION IF EXISTS `getCohortAllBefore4a`;
  DROP FUNCTION IF EXISTS `getCohortAllBefore4b`;
  DROP FUNCTION IF EXISTS `getCohortAllBefore5`;
  DROP FUNCTION IF EXISTS `getCohortAllBefore6`;
  DROP FUNCTION IF EXISTS `getCohortAllBefore7`;
  DROP FUNCTION IF EXISTS `getCohortAllBefore9`;
  DROP FUNCTION IF EXISTS `getCohortMonth`;
  DROP FUNCTION IF EXISTS `get_cpt_receipt_status`;
  DROP FUNCTION IF EXISTS `getCptStartDate`;
  DROP FUNCTION IF EXISTS `getCptStatusTxt`;
  DROP FUNCTION IF EXISTS `getCptStatusTxt2`;
  DROP FUNCTION IF EXISTS `getDeathDate`;
  DROP FUNCTION IF EXISTS `get_death_status`;
  DROP FUNCTION IF EXISTS `getEddDate`;
  DROP FUNCTION IF EXISTS `getEddEncounterId`;
  DROP FUNCTION IF EXISTS `getEddEncounterId2`;
  DROP FUNCTION IF EXISTS `getEddEncounterId3`;
  DROP FUNCTION IF EXISTS `getEddEncounterId4`;
  DROP FUNCTION IF EXISTS `getEncounterId`;
  DROP FUNCTION IF EXISTS `getEncounterId2`;
  DROP FUNCTION IF EXISTS `getEnrolDate`;
  DROP FUNCTION IF EXISTS `getFirstArtStopDate`;
  DROP FUNCTION IF EXISTS `getFlucStartDate`;
  DROP FUNCTION IF EXISTS `get_followup_status`;
  DROP FUNCTION IF EXISTS `get_followup_status2`;
  DROP FUNCTION IF EXISTS `getFUARTStatus`;
  DROP FUNCTION IF EXISTS `getFunctionalStatusTxt`;
  DROP FUNCTION IF EXISTS `getFUStatus`;
  DROP FUNCTION IF EXISTS `getINHStartDate`;
  DROP FUNCTION IF EXISTS `getLastCd4SevereValue`;
  DROP FUNCTION IF EXISTS `getLastCd4Value`;
  DROP FUNCTION IF EXISTS `getLastEncounterDate`;
  DROP FUNCTION IF EXISTS `getLastVisitDate`;
  DROP FUNCTION IF EXISTS `get_lost_status`;
  DROP FUNCTION IF EXISTS `getMonthCD4Value`;
  DROP FUNCTION IF EXISTS `getMonthsOnCurrent`;
  DROP FUNCTION IF EXISTS `getMonthsSinceStart`;
  DROP FUNCTION IF EXISTS `getNumberDrugEncounter`;
  DROP FUNCTION IF EXISTS `getNumberDrugSummary`;
  DROP FUNCTION IF EXISTS `getNutritionalStatus`;
  DROP FUNCTION IF EXISTS `getPatientIdentifierTxt`;
  DROP FUNCTION IF EXISTS `getReferralText`;
  DROP FUNCTION IF EXISTS `getReturnDate`;
  DROP FUNCTION IF EXISTS `getReturnDate2`;
  DROP FUNCTION IF EXISTS `get_scheduled_visits`;
  DROP FUNCTION IF EXISTS `get_seen_status`;
  DROP FUNCTION IF EXISTS `getStartEncounterId`;
  DROP FUNCTION IF EXISTS `getStatusAtEnrollment`;
  DROP FUNCTION IF EXISTS `getSubstituteDate`;
  DROP FUNCTION IF EXISTS `getSubstituteObsGroupId`;
  DROP FUNCTION IF EXISTS `getSubstituteObsGroupId2`;
  DROP FUNCTION IF EXISTS `getSubstituteReasonTxt`;
  DROP FUNCTION IF EXISTS `getSwitchDate`;
  DROP FUNCTION IF EXISTS `getSwitchObsGroupId`;
  DROP FUNCTION IF EXISTS `getSwitchObsGroupId2`;
  DROP FUNCTION IF EXISTS `getSwitchReasonTxt`;
  DROP FUNCTION IF EXISTS `getTbRegNoTxt`;
  DROP FUNCTION IF EXISTS `getTbStartDate`;
  DROP FUNCTION IF EXISTS `get_tb_status`;
  DROP FUNCTION IF EXISTS `getTbStatusTxt`;
  DROP FUNCTION IF EXISTS `getTbStopDate`;
  DROP FUNCTION IF EXISTS `getTransferInTxt`;
  DROP FUNCTION IF EXISTS `getTransferOutDate`;
  DROP FUNCTION IF EXISTS `get_transfer_status`;
  DROP FUNCTION IF EXISTS `getWeightValue`;
  DROP FUNCTION IF EXISTS `getWhoStageBaseTxt`;
  DROP FUNCTION IF EXISTS `getWHOStageDate`;
  DROP FUNCTION IF EXISTS `getWhoStageTxt`;

  DELIMITER $$
  CREATE DEFINER=`root`@`localhost` PROCEDURE `getARTData`(IN start_year INT, IN start_month INT)
  BEGIN
      DECLARE bDone INT;

      DECLARE patient_id INT;

      DECLARE art_start_date DATE;

      DECLARE unique_id_number CHAR(15);

      DECLARE ti_emtct CHAR(10);

      DECLARE patient_clinic_id CHAR(12);

      DECLARE surname CHAR(50);
      DECLARE gn CHAR(50);

      DECLARE sex CHAR(1);

      DECLARE age INT;

      DECLARE district CHAR(30);
      DECLARE sub_county CHAR(30);
      DECLARE village_cell CHAR(30);

      DECLARE function_status CHAR(30);

      DECLARE weight_muac CHAR(30);

      DECLARE who_stage INT;

      DECLARE cd4 INT;
      DECLARE viral_load INT;

      DECLARE cpt_start_date DATE;
      DECLARE cpt_stop_date DATE;

      DECLARE inh_start_date DATE;
      DECLARE inh_stop_date DATE;

      DECLARE tb_reg_no CHAR(15);
      DECLARE tb_start_date DATE;
      DECLARE tb_stop_date DATE;


      DECLARE preg1_edd CHAR(15);
      DECLARE preg1_anc CHAR(15);
      DECLARE preg1_infant CHAR(15);

      DECLARE preg2_edd CHAR(15);
      DECLARE preg2_anc CHAR(15);
      DECLARE preg2_infant CHAR(15);

      DECLARE preg3_edd CHAR(15);
      DECLARE preg3_anc CHAR(15);
      DECLARE preg3_infant CHAR(15);

      DECLARE preg4_edd CHAR(15);
      DECLARE preg4_anc CHAR(15);
      DECLARE preg4_infant CHAR(15);

      DECLARE original_regimen CHAR(15);

      DECLARE first_line_first CHAR(15);
      DECLARE first_line_second CHAR(15);


      DECLARE second_line_first CHAR(15);
      DECLARE second_line_second CHAR(15);

      DECLARE third_line_first CHAR(15);
      DECLARE third_line_second CHAR(15);

      DECLARE curs CURSOR FOR
        SELECT
          e.patient_id                                   AS 'patient_id',
          o.value_datetime                               AS 'art_start_date',
          getPatientIdentifierTxt(
              e.patient_id)                              AS 'unique_id_number',
          CONCAT(getTransferInTxt(e.patient_id), IF(getCareEntryTxt(e.patient_id) IN ('PMTCT', 'eMTCT'), 'eMTCT',
                                                    '')) AS 'ti_emtct',
          TIMESTAMPDIFF(YEAR, p.birthdate,
                        (MAKEDATE(start_year,1) + INTERVAL start_quarter QUARTER - INTERVAL 1 DAY))                       AS 'age',
          p.gender                                       AS 'sex',
          getFunctionalStatusTxt(e.patient_id,
                                 o.value_datetime)       AS 'function_status',
          getBaseWeightValue(e.patient_id,
                             o.value_datetime)           AS 'weight_muac',
          getWhoStageBaseTxt(e.patient_id,
                             o.value_datetime)           AS 'who_stage',
          getCd4BaseValue(e.patient_id,
                          o.value_datetime)              AS 'cd4',
          getCptStartDate(
              e.patient_id)                              AS 'cpt_start_date',
          getTbRegNoTxt(
              e.patient_id)                              AS 'tb_reg_no',
          getTbStartDate(
              e.patient_id)                              AS 'tb_start_date',
          getTbStopDate(
              e.patient_id)                              AS 'tb_stop_date',
          getArtStartRegTxt(
              e.patient_id)                              AS 'original_regimen',
          getEddDate(getEddEncounterId(
                         e.patient_id))                  AS 'preg1_edd',
          getAncNumberTxt(getEddEncounterId(
                              e.patient_id))             AS 'preg1_anc',
          getEddDate(getEddEncounterId2(
                         e.patient_id))                  AS 'preg2_edd',
          getAncNumberTxt(getEddEncounterId2(
                              e.patient_id))             AS 'preg2_anc',
          getEddDate(getEddEncounterId3(
                         e.patient_id))                  AS 'preg3_edd',
          getAncNumberTxt(getEddEncounterId3(
                              e.patient_id))             AS 'preg3_anc',
          getEddDate(getEddEncounterId4(
                         e.patient_id))                  AS 'preg4_edd',
          getAncNumberTxt(getEddEncounterId4(
                              e.patient_id))             AS 'preg4_anc',
          CONCAT(getSwitchReasonTxt(getSwitchObsGroupId(e.patient_id)), '/',
                 date_format(getSwitchDate(getSwitchObsGroupId(e.patient_id)),
                             '%e/%m/%y'))                AS 'first_line_first',
          CONCAT(getSwitchReasonTxt(getSwitchObsGroupId2(e.patient_id)), '/',
                 date_format(getSwitchDate(getSwitchObsGroupId2(e.patient_id)),
                             '%e/%m/%y'))                AS 'first_line_second',
          CONCAT(getSubstituteReasonTxt(getSubstituteObsGroupId(e.patient_id)), '/',
                 date_format(getSubstituteDate(getSubstituteObsGroupId(e.patient_id)),
                             '%e/%m/%y'))                AS 'second_line_first',
          CONCAT(getSubstituteReasonTxt(getSubstituteObsGroupId2(e.patient_id)), '/',
                 date_format(getSubstituteDate(getSubstituteObsGroupId2(e.patient_id)),
                             '%e/%m/%y'))                AS 'second_line_second'
        FROM
          person p
          INNER JOIN
          encounter e ON (p.person_id = e.patient_id)
          INNER JOIN
          obs o ON (e.encounter_id = o.encounter_id
                    AND o.concept_id IN (99160, 99161)


                    AND EXTRACT(YEAR_MONTH FROM o.value_datetime) =
                        EXTRACT(YEAR_MONTH FROM (MAKEDATE(start_year, 1) + INTERVAL start_month MONTH - INTERVAL 1 DAY))
          )
        ORDER BY o.value_datetime ASC;

      DECLARE CONTINUE HANDLER FOR NOT FOUND SET bDone = 1;

      DROP TEMPORARY TABLE IF EXISTS artData;

      CREATE TEMPORARY TABLE IF NOT EXISTS artData
      (
        patient_id         INT,
        art_start_date     DATE,
        unique_id_number   CHAR(15),
        ti_emtct           CHAR(10),
        patient_clinic_id  CHAR(12),
        surname            CHAR(40),
        given_name         CHAR(40),
        sex                CHAR(1),
        age                INT,
        district           CHAR(30),
        sub_county         CHAR(30),
        village_cell       CHAR(30),
        function_status    CHAR(30),
        weight_muac        CHAR(30),
        who_stage          INT,
        cd4                INT,
        viral_load         INT,
        cpt_start_date     DATE,
        cpt_stop_date      DATE,
        inh_start_date     DATE,
        inh_stop_date      DATE,
        tb_reg_no          CHAR(15),
        tb_start_date      DATE,
        tb_stop_date       DATE,
        preg1_edd          CHAR(15),
        preg1_anc          CHAR(15),
        preg1_infant       CHAR(15),
        preg2_edd          CHAR(15),
        preg2_anc          CHAR(15),
        preg2_infant       CHAR(15),
        preg3_edd          CHAR(15),
        preg3_anc          CHAR(15),
        preg3_infant       CHAR(15),
        preg4_edd          CHAR(15),
        preg4_anc          CHAR(15),
        preg4_infant       CHAR(15),
        original_regimen   CHAR(15),
        first_line_first   CHAR(15),
        first_line_second  CHAR(15),
        second_line_first  CHAR(15),
        second_line_second CHAR(15),
        third_line_first   CHAR(15),
        third_line_second  CHAR(15)
      );

      OPEN curs;

      SET bDone = 0;

      REPEAT
        FETCH curs
        INTO
          patient_id,
          art_start_date,
          unique_id_number,
          ti_emtct,
          age,
          sex,
          function_status,
          weight_muac,
          who_stage,
          cd4,
          cpt_start_date,
          tb_reg_no,
          tb_start_date,
          tb_stop_date,
          original_regimen,
          preg1_edd,
          preg1_anc,
          preg2_edd,
          preg2_anc,
          preg3_edd,
          preg3_anc,
          preg4_edd,
          preg4_anc,
          first_line_first,
          first_line_second,
          second_line_first,
          second_line_second;
        SELECT
          CONCAT(given_name, COALESCE(middle_name, '')),
          family_name
        INTO gn, surname
        FROM person_name
        WHERE person_id = patient_id
        LIMIT 1;
        SELECT
          county_district,
          state_province,
          city_village
        INTO district, sub_county, village_cell
        FROM
          person_address
        WHERE
          person_id = patient_id
        LIMIT 1;
        INSERT INTO artData (
          patient_id,
          art_start_date,
          unique_id_number,
          ti_emtct,
          given_name,
          surname,
          sex,
          age,
          district,
          sub_county,
          village_cell,
          function_status,
          weight_muac,
          who_stage,
          cd4,
          cpt_start_date,
          tb_reg_no,
          tb_start_date,
          tb_stop_date,
          original_regimen,
          preg1_edd,
          preg1_anc,
          preg2_edd,
          preg2_anc,
          preg3_edd,
          preg3_anc,
          preg4_edd,
          preg4_anc,
          first_line_first,
          first_line_second,
          second_line_first,
          second_line_second
        ) VALUES (
          patient_id,
          art_start_date,
          unique_id_number,
          ti_emtct,
          surname,
          gn,
          sex,
          age,
          district,
          sub_county,
          village_cell,
          function_status,
          weight_muac,
          who_stage,
          cd4,
          cpt_start_date,
          tb_reg_no,
          tb_start_date,
          tb_stop_date,
          original_regimen,
          preg1_edd,
          preg1_anc,
          preg2_edd,
          preg2_anc,
          preg3_edd,
          preg3_anc,
          preg4_edd,
          preg4_anc,
          first_line_first,
          first_line_second,
          second_line_first,
          second_line_second
        );
      UNTIL bDone END REPEAT;
      CLOSE curs;
      SELECT DISTINCT *
      FROM artData
      WHERE patient_id IS NOT NULL;
    END$$
  DELIMITER ;

  DELIMITER $$
  CREATE DEFINER=`root`@`localhost` PROCEDURE `GetARTFollowupData0_24`(IN start_year INT, IN start_month INT)
  BEGIN
      DECLARE bDone INT;

      DECLARE patient INT;
      DECLARE x INT;
      DECLARE arvs_fu_status TEXT;
      DECLARE tb_status TEXT;
      DECLARE tb_status_1 TEXT;

      DECLARE adh TEXT;
      DECLARE cpt TEXT;
      DECLARE adh_cpt_all TEXT;
      DECLARE adh_cpt TEXT;
      DECLARE fu TEXT;
      DECLARE arvs TEXT;
      DECLARE full_top TEXT;
      DECLARE enc INT;
      DECLARE real_date INT;

      DECLARE start_date DATE;
      DECLARE end_date DATE;

      DECLARE cs_1 INT;
      DECLARE cs_2 INT;
      DECLARE cs_3 INT;

      DECLARE w_1 DECIMAL;
      DECLARE w_2 DECIMAL;
      DECLARE w_3 DECIMAL;

      DECLARE cd4_1 DECIMAL;
      DECLARE cd4_2 DECIMAL;
      DECLARE cd4_3 DECIMAL;

      DECLARE vl_1 DECIMAL;
      DECLARE vl_2 DECIMAL;
      DECLARE vl_3 DECIMAL;

      DECLARE curs CURSOR FOR

        SELECT DISTINCT e.patient_id AS 'patient_id'

        FROM
          encounter e
          INNER JOIN
          obs o ON (e.encounter_id = o.encounter_id
                    AND o.concept_id IN (99160, 99161)
                    AND e.voided = 0
                    AND o.voided = 0 AND EXTRACT(YEAR_MONTH FROM o.value_datetime) = EXTRACT(YEAR_MONTH FROM (
          MAKEDATE(start_year, 1) + INTERVAL start_month MONTH - INTERVAL 1 DAY)))
        ORDER BY o.value_datetime ASC;

      DECLARE CONTINUE HANDLER FOR NOT FOUND SET bDone = 1;

      DROP TEMPORARY TABLE IF EXISTS art_followup_data_0_24;

      CREATE TEMPORARY TABLE IF NOT EXISTS art_followup_data_0_24 (
        patient_id     INT,
        arvs_fu_status TEXT,
        tb_status      TEXT,
        adh_cpt        TEXT,
        cs_1           INT,
        cs_2           INT,
        cs_3           INT,
        w_1            DECIMAL,
        w_2            DECIMAL,
        w_3            DECIMAL,
        cd4_1          DECIMAL,
        cd4_2          DECIMAL,
        cd4_3          DECIMAL,
        vl_1           DECIMAL,
        vl_2           DECIMAL,
        vl_3           DECIMAL
      );

      OPEN curs;

      SET bDone = 0;

      REPEAT
        FETCH curs
        INTO patient;
        SET x = 0;
        SET arvs_fu_status = '';
        SET tb_status = '';
        SET adh_cpt = '';

        SET arvs = '';
        SET tb_status_1 = '';
        SET cpt = '';
        SET adh = '';
        SET full_top = '';
        SET adh_cpt_all = '';
        SET fu = '';
        SET enc = '';

        WHILE x <= 24 DO
          SET real_date = (start_month + x);

          SET start_date = MAKEDATE(start_year, 1) + INTERVAL real_date - 1 MONTH;
          SET end_date = MAKEDATE(start_year, 1) + INTERVAL real_date MONTH - INTERVAL 1 DAY;

          SET arvs = '';
          SET tb_status_1 = '';
          SET cpt = '';
          SET adh = '';
          SET full_top = '';
          SET adh_cpt_all = '';
          SET enc = '';
          SET fu = '';

          IF (start_year <= YEAR((MAKEDATE(start_year,1) + INTERVAL start_quarter QUARTER - INTERVAL 1 DAY)) AND start_month <= MONTH((MAKEDATE(start_year,1) + INTERVAL start_quarter QUARTER - INTERVAL 1 DAY)))
          THEN

            SET enc = getEncounterId(patient, start_year, real_date);
            SET adh = getADHStatusTxt(patient, start_date, end_date);
            SET fu = getFUARTStatus(patient, start_date, end_date);

            IF (enc IS NOT NULL)
            THEN
              IF (x = 0)
              THEN
                SET arvs = getArtStartRegTxt(patient);
              ELSE
                SET arvs = getArtRegTxt(enc);
              END IF;
              SET tb_status_1 = getTbStatusTxt(enc);
              SET cpt = getCptStatusTxt2(enc);
            END IF;

            IF (arvs <> '' AND fu <> '')
            THEN
              SET full_top = CONCAT(arvs, '/', fu);
            ELSEIF arvs <> ''
              THEN
                SET full_top = arvs;
            ELSEIF fu <> ''
              THEN
                SET full_top = fu;
            END IF;

            IF (adh <> '' AND cpt <> '')
            THEN
              SET adh_cpt_all = CONCAT(adh, '|', cpt);
            ELSEIF adh <> ''
              THEN
                SET adh_cpt_all = adh;
            ELSEIF cpt <> ''
              THEN
                SET adh_cpt_all = cpt;
            END IF;
          END IF;

          SET tb_status = CONCAT_WS(',', COALESCE(tb_status, ''), COALESCE(tb_status_1, ''));
          SET arvs_fu_status = CONCAT_WS(',', COALESCE(arvs_fu_status, ''), COALESCE(full_top, ''));
          SET adh_cpt = CONCAT_WS(',', COALESCE(adh_cpt, ''), COALESCE(adh_cpt_all, ''));

          SET x = x + 1;
        END WHILE;
        INSERT INTO art_followup_data_0_24 (
          patient_id,
          arvs_fu_status,
          tb_status,
          adh_cpt,
          cs_1,
          cs_2,
          cs_3,
          w_1,
          w_2,
          w_3,
          cd4_1,
          cd4_2,
          cd4_3,
          vl_1,
          vl_2,
          vl_3
        ) VALUES (
          patient,
          SUBSTR(arvs_fu_status, 2),
          SUBSTR(tb_status, 2),
          SUBSTR(adh_cpt, 2),
          cs_1,
          cs_2,
          cs_3,
          w_1,
          w_2,
          w_3,
          cd4_1,
          cd4_2,
          cd4_3,
          vl_1,
          vl_2,
          vl_3
        );
      UNTIL bDone END REPEAT;

      CLOSE curs;

      SELECT DISTINCT *
      FROM
        art_followup_data_0_24
      WHERE patient_id IS NOT NULL;
    END$$
  DELIMITER ;

  DELIMITER $$
  CREATE DEFINER=`root`@`localhost` PROCEDURE `GetARTFollowupData25_48`(IN start_year INT, IN start_month INT)
  BEGIN
      DECLARE bDone INT;

      DECLARE patient INT;
      DECLARE x INT;
      DECLARE arvs_fu_status TEXT;
      DECLARE tb_status TEXT;
      DECLARE tb_status_1 TEXT;


      DECLARE adh TEXT;
      DECLARE cpt TEXT;
      DECLARE adh_cpt_all TEXT;
      DECLARE adh_cpt TEXT;
      DECLARE fu TEXT;
      DECLARE arvs TEXT;
      DECLARE full_top TEXT;
      DECLARE enc INT;
      DECLARE real_date INT;

      DECLARE start_date DATE;
      DECLARE end_date DATE;

      DECLARE cs_1 INT;
      DECLARE cs_2 INT;

      DECLARE w_1 DECIMAL;
      DECLARE w_2 DECIMAL;

      DECLARE cd4_1 DECIMAL;
      DECLARE cd4_2 DECIMAL;

      DECLARE vl_1 DECIMAL;
      DECLARE vl_2 DECIMAL;

      DECLARE curs CURSOR FOR
        SELECT e.patient_id AS 'patient_id'

        FROM
          encounter e
          INNER JOIN
          obs o ON (e.encounter_id = o.encounter_id
                    AND o.concept_id IN (99160, 99161)
                    AND e.voided = 0
                    AND o.voided = 0 AND EXTRACT(YEAR_MONTH FROM o.value_datetime) = EXTRACT(YEAR_MONTH FROM (
          MAKEDATE(start_year, 1) + INTERVAL start_month MONTH - INTERVAL 1 DAY)))
        ORDER BY o.value_datetime ASC;

      DECLARE CONTINUE HANDLER FOR NOT FOUND SET bDone = 1;

      DROP TEMPORARY TABLE IF EXISTS art_followup_data_25_48;

      CREATE TEMPORARY TABLE IF NOT EXISTS art_followup_data_25_48 (

        patient_id     INT,
        arvs_fu_status TEXT,
        tb_status      TEXT,
        adh_cpt        TEXT,
        cs_1           INT,
        cs_2           INT,
        w_1            DECIMAL,
        w_2            DECIMAL,
        cd4_1          DECIMAL,
        cd4_2          DECIMAL,
        vl_1           DECIMAL,
        vl_2           DECIMAL
      );

      OPEN curs;

      SET bDone = 0;

      REPEAT
        FETCH curs
        INTO patient;
        SET x = 25;
        SET arvs_fu_status = '';
        SET tb_status = '';
        SET adh = '';
        SET cpt = '';
        SET arvs = '';
        SET adh_cpt = '';
        WHILE x <= 48 DO
          SET real_date = (start_month + x);

          SET start_date = MAKEDATE(start_year, 1) + INTERVAL real_date - 1 MONTH;
          SET end_date = MAKEDATE(start_year, 1) + INTERVAL real_date MONTH - INTERVAL 1 DAY;

          IF (start_year <= YEAR((MAKEDATE(start_year,1) + INTERVAL start_quarter QUARTER - INTERVAL 1 DAY)) AND start_month < MONTH((MAKEDATE(start_year,1) + INTERVAL start_quarter QUARTER - INTERVAL 1 DAY)))
          THEN

            SET enc = getEncounterId(patient, start_year, real_date);
            SET adh = getADHStatusTxt(patient, start_date, end_date);
            SET fu = getFUARTStatus(patient, start_date, end_date);

            IF (enc IS NOT NULL)
            THEN
              SET arvs = getArtRegTxt(enc);
              SET tb_status_1 = getTbStatusTxt(enc);
              SET cpt = getCptStatusTxt(enc);
            ELSE
              SET arvs = NULL;
              SET tb_status_1 = NULL;
              SET cpt = NULL;
            END IF;

            IF (arvs IS NOT NULL AND fu IS NOT NULL)
            THEN
              SET full_top = CONCAT(arvs, '/', fu);
            ELSEIF arvs IS NOT NULL
              THEN
                SET full_top = arvs;
            ELSEIF fu IS NOT NULL
              THEN
                SET full_top = fu;
            END IF;
            IF (adh IS NOT NULL AND cpt IS NOT NULL)
            THEN
              SET adh_cpt_all = CONCAT(adh, '|', cpt);
            ELSEIF adh IS NULL
              THEN
                SET adh_cpt_all = adh;
            ELSEIF cpt IS NULL
              THEN
                SET adh_cpt_all = cpt;
            END IF;
          ELSE
            SET tb_status_1 = NULL;
            SET full_top = NULL;
            SET adh_cpt_all = NULL;

          END IF;

          SET tb_status = CONCAT_WS(',', COALESCE(tb_status, ''), COALESCE(tb_status_1, ''));
          SET arvs_fu_status = CONCAT_WS(',', COALESCE(arvs_fu_status, ''), COALESCE(full_top, ''));
          SET adh_cpt = CONCAT_WS(',', COALESCE(adh_cpt, ''), COALESCE(adh_cpt_all, ''));

          SET x = x + 1;
        END WHILE;
        IF (patient > 0)
        THEN
          INSERT INTO art_followup_data_25_48 (
            patient_id,
            arvs_fu_status,
            tb_status,
            adh_cpt,
            cs_1,
            cs_2,
            w_1,
            w_2,
            cd4_1,
            cd4_2,
            vl_1,
            vl_2
          ) VALUES (
            patient,
            SUBSTR(arvs_fu_status, 2),
            SUBSTR(tb_status, 2),
            SUBSTR(adh_cpt, 2),
            cs_1,
            cs_2,
            w_1,
            w_2,
            cd4_1,
            cd4_2,
            vl_1,
            vl_2
          );
        END IF;
      UNTIL bDone END REPEAT;
      CLOSE curs;
      SELECT DISTINCT *
      FROM
        art_followup_data_25_48;
    END$$
  DELIMITER ;

  DELIMITER $$
  CREATE DEFINER=`root`@`localhost` PROCEDURE `GetARTFollowupData49_72`(IN start_year INT, IN start_month INT)
  BEGIN
      DECLARE bDone INT;

      DECLARE patient INT;
      DECLARE x INT;
      DECLARE arvs_fu_status TEXT;
      DECLARE tb_status TEXT;
      DECLARE tb_status_1 TEXT;

      DECLARE adh TEXT;
      DECLARE cpt TEXT;
      DECLARE adh_cpt_all TEXT;
      DECLARE adh_cpt TEXT;
      DECLARE fu TEXT;
      DECLARE arvs TEXT;
      DECLARE full_top TEXT;
      DECLARE enc INT;
      DECLARE real_date INT;

      DECLARE start_date DATE;
      DECLARE end_date DATE;

      DECLARE cs_1 INT;
      DECLARE cs_2 INT;

      DECLARE w_1 DECIMAL;
      DECLARE w_2 DECIMAL;

      DECLARE cd4_1 DECIMAL;
      DECLARE cd4_2 DECIMAL;

      DECLARE vl_1 DECIMAL;
      DECLARE vl_2 DECIMAL;
      DECLARE curs CURSOR FOR
        SELECT e.patient_id AS 'patient_id'

        FROM
          encounter e
          INNER JOIN
          obs o ON (e.encounter_id = o.encounter_id
                    AND o.concept_id IN (99160, 99161)
                    AND e.voided = 0
                    AND o.voided = 0 AND EXTRACT(YEAR_MONTH FROM o.value_datetime) = EXTRACT(YEAR_MONTH FROM (
          MAKEDATE(start_year, 1) + INTERVAL start_month MONTH - INTERVAL 1 DAY)))
        ORDER BY o.value_datetime ASC;

      DECLARE CONTINUE HANDLER FOR NOT FOUND SET bDone = 1;

      DROP TEMPORARY TABLE IF EXISTS art_followup_data_49_72;

      CREATE TEMPORARY TABLE IF NOT EXISTS art_followup_data_49_72 (
        patient_id     INT,
        arvs_fu_status TEXT,
        tb_status      TEXT,
        adh_cpt        TEXT,
        cs_1           INT,
        cs_2           INT,
        w_1            DECIMAL,
        w_2            DECIMAL,
        cd4_1          DECIMAL,
        cd4_2          DECIMAL,
        vl_1           DECIMAL,
        vl_2           DECIMAL
      );

      OPEN curs;

      SET bDone = 0;

      REPEAT
        FETCH curs
        INTO patient;
        SET x = 49;
        SET arvs_fu_status = '';
        SET tb_status = '';
        SET adh = '';
        SET cpt = '';
        SET arvs = '';
        SET adh_cpt = '';
        WHILE x <= 72 DO
          SET real_date = (start_month + x);

          SET start_date = MAKEDATE(start_year, 1) + INTERVAL real_date - 1 MONTH;
          SET end_date = MAKEDATE(start_year, 1) + INTERVAL real_date MONTH - INTERVAL 1 DAY;

          IF (start_year <= YEAR((MAKEDATE(start_year,1) + INTERVAL start_quarter QUARTER - INTERVAL 1 DAY)) AND start_month < MONTH((MAKEDATE(start_year,1) + INTERVAL start_quarter QUARTER - INTERVAL 1 DAY)))
          THEN

            SET enc = getEncounterId(patient, start_year, real_date);
            SET adh = getADHStatusTxt(patient, start_date, end_date);
            SET fu = getFUARTStatus(patient, start_date, end_date);

            IF (enc IS NOT NULL)
            THEN
              SET arvs = getArtRegTxt(enc);
              SET tb_status_1 = getTbStatusTxt(enc);
              SET cpt = getCptStatusTxt(enc);
            ELSE
              SET arvs = NULL;
              SET tb_status_1 = NULL;
              SET cpt = NULL;
            END IF;

            IF (arvs IS NOT NULL AND fu IS NOT NULL)
            THEN
              SET full_top = CONCAT(arvs, '/', fu);
            ELSEIF arvs IS NOT NULL
              THEN
                SET full_top = arvs;
            ELSEIF fu IS NOT NULL
              THEN
                SET full_top = fu;
            END IF;
            IF (adh IS NOT NULL AND cpt IS NOT NULL)
            THEN
              SET adh_cpt_all = CONCAT(adh, '|', cpt);
            ELSEIF adh IS NULL
              THEN
                SET adh_cpt_all = adh;
            ELSEIF cpt IS NULL
              THEN
                SET adh_cpt_all = cpt;
            END IF;
          ELSE
            SET tb_status_1 = NULL;
            SET full_top = NULL;
            SET adh_cpt_all = NULL;

          END IF;

          SET tb_status = CONCAT_WS(',', COALESCE(tb_status, ''), COALESCE(tb_status_1, ''));
          SET arvs_fu_status = CONCAT_WS(',', COALESCE(arvs_fu_status, ''), COALESCE(full_top, ''));
          SET adh_cpt = CONCAT_WS(',', COALESCE(adh_cpt, ''), COALESCE(adh_cpt_all, ''));

          SET x = x + 1;
        END WHILE;
        IF (patient > 0)
        THEN
          INSERT INTO art_followup_data_49_72 (
            patient_id,
            arvs_fu_status,
            tb_status,
            adh_cpt,
            cs_1,
            cs_2,
            w_1,
            w_2,
            cd4_1,
            cd4_2,
            vl_1,
            vl_2

          ) VALUES (
            patient,
            SUBSTR(arvs_fu_status, 2),
            SUBSTR(tb_status, 2),
            SUBSTR(adh_cpt, 2),
            cs_1,
            cs_2,
            w_1,
            w_2,
            cd4_1,
            cd4_2,
            vl_1,
            vl_2
          );
        END IF;
      UNTIL bDone END REPEAT;
      CLOSE curs;
      SELECT DISTINCT *
      FROM art_followup_data_49_72
      WHERE patient_id IS NOT NULL;
    END$$
  DELIMITER ;

  DELIMITER $$
  CREATE DEFINER=`root`@`localhost` PROCEDURE `getPreARTData`(IN start_year INTEGER)
  BEGIN

      DECLARE bDone INT;

      DECLARE date_enrolled_in_care DATE;

      DECLARE unique_id CHAR(25);

      DECLARE patient_id INT;

      DECLARE surname CHAR(50);
      DECLARE gn CHAR(50);

      DECLARE p_sex CHAR(40);

      DECLARE p_age INT;

      DECLARE district CHAR(30);
      DECLARE sub_county CHAR(30);
      DECLARE village_cell CHAR(30);

      DECLARE entry_point CHAR(15);

      DECLARE status_at_enrollment CHAR(10);

      DECLARE cpt_start_date DATE;
      DECLARE cpt_stop_date DATE;

      DECLARE inh_start_date DATE;
      DECLARE inh_stop_date DATE;

      DECLARE tb_reg_no CHAR(15);
      DECLARE tb_start_date DATE;
      DECLARE tb_stop_date DATE;

      DECLARE who_stage_1 DATE;
      DECLARE who_stage_2 DATE;
      DECLARE who_stage_3 DATE;
      DECLARE who_stage_4 DATE;


      DECLARE date_eligible_for_art DATE;

      DECLARE why_eligible CHAR(15);

      DECLARE date_eligible_and_ready_for_art DATE;

      DECLARE date_art_started DATE;

      DECLARE curs CURSOR FOR SELECT DISTINCT
                                getEnrolDate(e.patient_id)                  AS 'date_enrolled_in_care',
                                getPatientIdentifierTxt(e.patient_id)       AS 'unique_id',
                                e.patient_id                                AS 'patient_id',
                                getCareEntryTxt(e.patient_id)               AS 'entry_point',
                                getStatusAtEnrollment(e.patient_id)         AS 'status_at_enrollment',
                                getCptStartDate(e.patient_id)               AS 'cpt_start_date',
                                getINHStartDate(e.patient_id)               AS 'inh_start_date',
                                getTbRegNoTxt(e.patient_id)                 AS 'tb_reg_no',
                                getTbStartDate(e.patient_id)                AS 'tb_start_date',
                                getTbStopDate(e.patient_id)                 AS 'tb_stop_date',
                                getWHOStageDate(e.patient_id, 1)            AS 'who_stage_1',
                                getWHOStageDate(e.patient_id, 2)            AS 'who_stage_2',
                                getWHOStageDate(e.patient_id, 3)            AS 'who_stage_3',
                                getWHOStageDate(e.patient_id, 4)            AS 'who_stage_4',
                                getArtEligibilityDate(e.patient_id)         AS 'date_eligible_for_art',
                                getArtEligibilityReasonTxt(e.patient_id)    AS 'why_eligible',
                                getArtEligibilityAndReadyDate(e.patient_id) AS 'date_eligible_and_ready_for_art',
                                getArtBaseTransferDate(e.patient_id)        AS 'date_art_started'
                              FROM encounter e
                              WHERE e.voided = 0 AND YEAR(e.encounter_datetime) = start_year AND e.encounter_type = (select encounter_type_id from encounter_type where locate('art',name) > 0 and locate('summary',name) > 0)
                              ORDER BY e.encounter_datetime;

      DECLARE CONTINUE HANDLER FOR NOT FOUND SET bDone = 1;

      DROP TEMPORARY TABLE IF EXISTS artPreData;

      CREATE TEMPORARY TABLE IF NOT EXISTS artPreData (
        date_enrolled_in_care           DATE,
        unique_id                       CHAR(25),
        patient_id                      INT,
        surname                         CHAR(40),
        given_name                      CHAR(40),
        sex                             CHAR(40),
        age                             INT,
        district                        CHAR(30),
        sub_county                      CHAR(30),
        village_cell                    CHAR(30),
        entry_point                     CHAR(15),
        status_at_enrollment            CHAR(10),
        cpt_start_date                  DATE,
        cpt_stop_date                   DATE,
        inh_start_date                  DATE,
        inh_stop_date                   DATE,
        tb_reg_no                       CHAR(15),
        tb_start_date                   DATE,
        tb_stop_date                    DATE,
        who_stage_1                     DATE,
        who_stage_2                     DATE,
        who_stage_3                     DATE,
        who_stage_4                     DATE,
        date_eligible_for_art           DATE,
        why_eligible                    CHAR(15),
        date_eligible_and_ready_for_art DATE,
        date_art_started                DATE
      );

      OPEN curs;

      SET bDone = 0;

      REPEAT
        FETCH curs
        INTO date_enrolled_in_care, unique_id, patient_id, entry_point, status_at_enrollment, cpt_start_date, inh_start_date, tb_reg_no, tb_start_date, tb_stop_date, who_stage_1, who_stage_2, who_stage_3, who_stage_4, date_eligible_for_art, why_eligible, date_eligible_and_ready_for_art, date_art_started;

        SELECT
          CONCAT(given_name, COALESCE(middle_name, '')),
          family_name
        INTO gn, surname
        FROM person_name
        WHERE person_id = patient_id
        LIMIT 1;
        SELECT
          pp.gender,
          TIMESTAMPDIFF(YEAR, pp.birthdate, (MAKEDATE(start_year,1) + INTERVAL start_quarter QUARTER - INTERVAL 1 DAY))
        INTO p_sex, p_age
        FROM person pp
        WHERE person_id = patient_id
        LIMIT 1;
        SELECT
          county_district,
          state_province,
          city_village
        INTO district, sub_county, village_cell
        FROM person_address
        WHERE person_id = patient_id
        LIMIT 1;
        INSERT INTO artPreData (
          date_enrolled_in_care,
          unique_id,
          patient_id,
          surname,
          given_name,
          sex,
          age,
          district,
          sub_county,
          village_cell,
          entry_point,
          status_at_enrollment,
          cpt_start_date,
          cpt_stop_date,
          inh_start_date,
          inh_stop_date,
          tb_reg_no,
          tb_start_date,
          tb_stop_date,
          who_stage_1,
          who_stage_2,
          who_stage_3,
          who_stage_4,
          date_eligible_for_art,
          why_eligible,
          date_eligible_and_ready_for_art,
          date_art_started
        ) VALUES (
          date_enrolled_in_care,
          unique_id,
          patient_id,
          surname,
          gn,
          p_sex,
          p_age,
          district,
          sub_county,
          village_cell,
          entry_point,
          status_at_enrollment,
          cpt_start_date,
          cpt_stop_date,
          inh_start_date,
          inh_stop_date,
          tb_reg_no,
          tb_start_date,
          tb_stop_date,
          who_stage_1,
          who_stage_2,
          who_stage_3,
          who_stage_4,
          date_eligible_for_art,
          why_eligible,
          date_eligible_and_ready_for_art,
          date_art_started
        );

      UNTIL bDone
      END REPEAT;
      CLOSE curs;
      SELECT DISTINCT *
      FROM artPreData
      WHERE patient_id IS NOT NULL;
    END$$
  DELIMITER ;

  DELIMITER $$
  CREATE DEFINER=`root`@`localhost` PROCEDURE `getPreARTFollowup`(IN start_year INT)
  BEGIN

      DECLARE bDone INT;
      DECLARE patient_id INT;

      DECLARE fu_status TEXT;
      DECLARE fu_status_1 CHAR(20);
      DECLARE fu_status_2 CHAR(20);
      DECLARE fu_status_3 CHAR(20);
      DECLARE fu_status_4 CHAR(20);

      DECLARE nutritinal_status TEXT;
      DECLARE nutritinal_status_1 CHAR(10);
      DECLARE nutritinal_status_2 CHAR(10);
      DECLARE nutritinal_status_3 CHAR(10);
      DECLARE nutritinal_status_4 CHAR(10);

      DECLARE tb_status TEXT;
      DECLARE tb_status_1 CHAR(1);
      DECLARE tb_status_2 CHAR(1);
      DECLARE tb_status_3 CHAR(1);
      DECLARE tb_status_4 CHAR(1);


      DECLARE cpt TEXT;
      DECLARE cpt_1 CHAR(1);
      DECLARE cpt_2 CHAR(1);
      DECLARE cpt_3 CHAR(1);
      DECLARE cpt_4 CHAR(1);

      DECLARE x INT;
      DECLARE real_date INT;

      DECLARE curs CURSOR FOR SELECT DISTINCT e.patient_id AS 'patient_id'
                              FROM encounter e
                              WHERE e.voided = 0 AND YEAR(e.encounter_datetime) = start_year AND e.encounter_type = (select encounter_type_id from encounter_type where locate('art',name) > 0 and locate('summary',name) > 0)
                              ORDER BY e.encounter_datetime;

      DECLARE CONTINUE HANDLER FOR NOT FOUND SET bDone = 1;

      DROP TEMPORARY TABLE IF EXISTS pre_art_followup_data;

      CREATE TEMPORARY TABLE IF NOT EXISTS pre_art_followup_data (
        patient_id        INT,
        fu_status         TEXT,
        tb_status         TEXT,
        cpt               TEXT,
        nutritinal_status TEXT
      )
        DEFAULT CHARSET = utf8;

      OPEN curs;

      SET bDone = 0;

      REPEAT
        FETCH curs
        INTO patient_id;
        SET x = 0;
        SET fu_status = '';
        SET tb_status = '';
        SET cpt = '';
        SET nutritinal_status = '';

        SET tb_status_1 = '';
        SET fu_status_1 = '';
        SET nutritinal_status_1 = '';
        SET cpt_1 = '';

        SET tb_status_2 = '';
        SET fu_status_2 = '';
        SET nutritinal_status_2 = '';
        SET cpt_2 = '';

        SET tb_status_3 = '';
        SET fu_status_3 = '';
        SET nutritinal_status_3 = '';
        SET cpt_3 = '';

        SET tb_status_4 = '';
        SET fu_status_4 = '';
        SET nutritinal_status_4 = '';
        SET cpt_4 = '';

        WHILE x < 4 DO
          SET real_date = (start_year + x);

          SET tb_status_1 = getTbStatusTxt(getEncounterId2(patient_id, real_date, 1));
          SET fu_status_1 = getFUStatus(patient_id, (MAKEDATE(real_date, 1)),
                                        (MAKEDATE(start_year, 1) + INTERVAL 1 QUARTER - INTERVAL 1 DAY));
          SET nutritinal_status_1 = getNutritionalStatus(patient_id, (MAKEDATE(real_date, 1)),
                                                         (MAKEDATE(start_year, 1) + INTERVAL 1 QUARTER - INTERVAL 1 DAY));
          SET cpt_1 = getCptStatusTxt(getEncounterId2(patient_id, real_date, 1));


          SET tb_status_2 = getTbStatusTxt(getEncounterId2(patient_id, real_date, 2));
          SET cpt_2 = getCptStatusTxt(getEncounterId2(patient_id, real_date, 2));
          SET fu_status_2 = getFUStatus(patient_id, (MAKEDATE(real_date, 1) + INTERVAL 1 QUARTER),
                                        (MAKEDATE(real_date, 1) + INTERVAL 2 QUARTER - INTERVAL 1 DAY));
          SET nutritinal_status_2 = getNutritionalStatus(patient_id, (MAKEDATE(real_date, 1) + INTERVAL 1 QUARTER),
                                                         (MAKEDATE(real_date, 1) + INTERVAL 2 QUARTER - INTERVAL 1 DAY));


          SET tb_status_3 = getTbStatusTxt(getEncounterId2(patient_id, real_date, 3));
          SET cpt_3 = getCptStatusTxt(getEncounterId2(patient_id, real_date, 3));
          SET fu_status_3 = getFUStatus(patient_id, (MAKEDATE(real_date, 1) + INTERVAL 2 QUARTER),
                                        (MAKEDATE(real_date, 1) + INTERVAL 3 QUARTER - INTERVAL 1 DAY));
          SET nutritinal_status_3 = getNutritionalStatus(patient_id, (MAKEDATE(real_date, 1) + INTERVAL 2 QUARTER),
                                                         (MAKEDATE(real_date, 1) + INTERVAL 3 QUARTER - INTERVAL 1 DAY));


          SET tb_status_4 = getTbStatusTxt(getEncounterId2(patient_id, real_date, 4));
          SET cpt_4 = getCptStatusTxt(getEncounterId2(patient_id, real_date, 4));
          SET fu_status_4 = getFUStatus(patient_id, (MAKEDATE(real_date, 1) + INTERVAL 3 QUARTER),
                                        (MAKEDATE(real_date, 1) + INTERVAL 4 QUARTER - INTERVAL 1 DAY));
          SET nutritinal_status_4 = getNutritionalStatus(patient_id, (MAKEDATE(real_date, 1) + INTERVAL 3 QUARTER),
                                                         (MAKEDATE(real_date, 1) + INTERVAL 4 QUARTER - INTERVAL 1 DAY));


          SET tb_status = CONCAT_WS(',', COALESCE(tb_status, ''), COALESCE(tb_status_1, ''), COALESCE(tb_status_2, ''),
                                    COALESCE(tb_status_3, ''), COALESCE(tb_status_4, ''));
          SET cpt = CONCAT_WS(',', COALESCE(cpt, ''), COALESCE(cpt_1, ''), COALESCE(cpt_2, ''), COALESCE(cpt_3, ''),
                              COALESCE(cpt_4, ''));
          SET fu_status = CONCAT_WS(',', COALESCE(fu_status, ''), COALESCE(fu_status_1, ''), COALESCE(fu_status_2, ''),
                                    COALESCE(fu_status_3, ''), COALESCE(fu_status_4, ''));
          SET nutritinal_status = CONCAT_WS(',', COALESCE(nutritinal_status, ''), COALESCE(nutritinal_status_1, ''),
                                            COALESCE(nutritinal_status_2, ''), COALESCE(nutritinal_status_3, ''),
                                            COALESCE(nutritinal_status_4, ''));
          SET x = x + 1;
        END WHILE;

        INSERT INTO pre_art_followup_data (patient_id, fu_status, tb_status, cpt, nutritinal_status)
        VALUES (patient_id, SUBSTR(fu_status, 2), SUBSTR(tb_status, 2), SUBSTR(cpt, 2), SUBSTR(nutritinal_status, 2));

      UNTIL bDone END REPEAT;
      CLOSE curs;
      SELECT DISTINCT *
      FROM pre_art_followup_data;
    END$$
  DELIMITER ;

  DELIMITER $$
  CREATE DEFINER=`openmrs`@`localhost` PROCEDURE `hmis105EID`(IN start_year CHAR(5), IN start_month CHAR(3))
  BEGIN DECLARE start_year_month CHAR(6) DEFAULT CONCAT(start_year,start_month);
      SELECT
        (SELECT COUNT(*)
         FROM encounter e
           INNER JOIN obs o ON (o.encounter_id = e.encounter_id
                                AND o.voided = 0
                                AND e.voided = 0)
         WHERE EXTRACT(YEAR_MONTH
                       FROM e.encounter_datetime) = start_year_month
               AND o.concept_id = 99606
               AND EXTRACT(YEAR_MONTH
                           FROM o.value_datetime) = start_year_month) AS '1PCR',
        (SELECT COUNT(*)
         FROM encounter e
           INNER JOIN obs o ON (o.encounter_id = e.encounter_id
                                AND o.voided = 0
                                AND e.voided = 0)
         WHERE EXTRACT(YEAR_MONTH
                       FROM e.encounter_datetime) = start_year_month
               AND o.concept_id = 99436
               AND EXTRACT(YEAR_MONTH
                           FROM o.value_datetime) = start_year_month) AS '2PCR',
        (SELECT COUNT(*)
         FROM encounter e
           INNER JOIN obs o ON (o.encounter_id = e.encounter_id
                                AND o.voided = 0
                                AND e.voided = 0)
         WHERE EXTRACT(YEAR_MONTH
                       FROM e.encounter_datetime) = start_year_month
               AND o.concept_id = 99279
               AND o.value_numeric <= 2) AS '<2 months',
        (SELECT COUNT(*) FROM obs o WHERE o.voided = 0 AND o.concept_id = 99435 AND EXTRACT(YEAR_MONTH FROM o.obs_datetime) = start_year_month) AS '1PCRResults',
        (SELECT COUNT(*) FROM obs o WHERE o.voided = 0 AND o.concept_id = 99435 AND EXTRACT(YEAR_MONTH FROM o.obs_datetime) = start_year_month AND o.value_coded = 703) AS '1PCRResults+',
        (SELECT COUNT(*) FROM obs o WHERE o.voided = 0 AND o.concept_id = 99440 AND EXTRACT(YEAR_MONTH FROM o.obs_datetime) = start_year_month) AS '2PCRResults',
        (SELECT COUNT(*) FROM obs o WHERE o.voided = 0 AND o.concept_id = 99440 AND EXTRACT(YEAR_MONTH FROM o.obs_datetime) = start_year_month AND o.value_coded = 703) AS '2PCRResults+',
        (SELECT COUNT(*) FROM obs o WHERE o.voided = 0 AND EXTRACT(YEAR_MONTH FROM o.obs_datetime) = start_year_month AND o.concept_id IN (99435,99440)) AS 'PCRResults',
        (SELECT COUNT(*)
         FROM
           (SELECT o.concept_id,o.person_id,o.obs_datetime AS 'pcrdate' FROM obs o WHERE o.voided = 0 AND EXTRACT(YEAR_MONTH FROM o.obs_datetime) = start_year_month AND o.concept_id IN (99606 ,99436)) t1
           LEFT OUTER JOIN
           (SELECT o.concept_id,o.person_id,o.value_datetime AS 'pcrresultsdate' FROM  obs o WHERE o.voided = 0 AND EXTRACT(YEAR_MONTH FROM o.obs_datetime) = start_year_month AND o.concept_id IN (99435,99440)) t2
             ON (t1.person_id = t2.person_id AND DATEDIFF(t1.pcrdate, t2.pcrresultsdate) <= 14 AND ((t1.concept_id = 99606 AND t2.concept_id = 99435)OR (t1.concept_id = 99436 AND t2.concept_id = 99440)))) AS 'Within two weeks',
        (SELECT COUNT(*) FROM  obs o WHERE o.voided = 0 AND EXTRACT(YEAR_MONTH FROM o.obs_datetime) = start_year_month AND o.concept_id IN (99438 ,99442)) 'Given to Caregiver',
        (SELECT COUNT(*) FROM encounter e INNER JOIN obs o ON (o.encounter_id = e.encounter_id AND o.voided = 0 AND e.voided = 0 AND e.form_id IN (10 ,11)) WHERE EXTRACT(YEAR_MONTH FROM e.encounter_datetime) = start_year_month
                                                                                                                                                                  AND o.concept_id IN (1040 ,
                                                                                                                                                                                       1326)) AS 'rapidtest',

        (SELECT COUNT(*)
         FROM encounter e
           INNER JOIN obs o ON (o.encounter_id = e.encounter_id
                                AND o.voided = 0
                                AND e.voided = 0
                                AND e.form_id IN (select encounter_type_id from encounter_type where locate('eid',name) > 0 and locate('card',name) > 0))
         WHERE EXTRACT(YEAR_MONTH
                       FROM e.encounter_datetime) = start_year_month
               AND o.concept_id IN (1040 ,
                                    1326)
               AND o.value_coded = 703) AS 'rapidtestresult',

        (SELECT COUNT(*)
         FROM encounter e
           INNER JOIN obs o ON (o.encounter_id = e.encounter_id
                                AND o.voided = 0
                                AND e.voided = 0
                                AND e.form_id IN (select encounter_type_id from encounter_type where locate('eid',name) > 0 and locate('card',name) > 0))
         WHERE EXTRACT(YEAR_MONTH
                       FROM e.encounter_datetime) = start_year_month
               AND o.concept_id = 99751
               AND o.value_text IS NOT NULL) AS 'oncare',

        (SELECT COUNT(*)
         FROM encounter e
           INNER JOIN obs o ON (o.encounter_id = e.encounter_id
                                AND o.voided = 0
                                AND e.voided = 0
                                AND e.form_id IN (select encounter_type_id from encounter_type where locate('eid',name) > 0 and locate('card',name) > 0))
         WHERE EXTRACT(YEAR_MONTH
                       FROM e.encounter_datetime) = start_year_month
               AND o.concept_id = 99037) AS 'oncpt',

        (SELECT COUNT(*)
         FROM encounter e
           INNER JOIN obs o ON (o.encounter_id = e.encounter_id
                                AND o.voided = 0
                                AND e.voided = 0
                                AND e.form_id IN (select encounter_type_id from encounter_type where locate('eid',name) > 0 and locate('card',name) > 0))
         WHERE EXTRACT(YEAR_MONTH
                       FROM e.encounter_datetime) = start_year_month
               AND o.concept_id = 99037) AS 'oncptwithin2months'; END$$
  DELIMITER ;

  DELIMITER $$
  CREATE DEFINER=`openmrs`@`localhost` PROCEDURE `hmis106a1a`(IN start_year INTEGER, IN start_quarter INTEGER)
  BEGIN
      SELECT *
      FROM
        (SELECT indicator_id,
           q1indicator,
           SUM(IF(gender = 'M'
                  AND age < 2, 1, 0)) AS q1MBabies,
           SUM(IF(gender = 'F'
                  AND age < 2, 1, 0)) AS q1FBabies,
           SUM(IF(gender = 'M'
                  AND age >= 2
                  AND age <= 4, 1, 0)) AS q1MToddlers,
           SUM(IF(gender = 'F'
                  AND age >= 2
                  AND age <= 4, 1, 0)) AS q1FToddlers,
           SUM(IF(gender = 'M'
                  AND age >= 5
                  AND age <= 14, 1, 0)) AS q1MTeens,
           SUM(IF(gender = 'F'
                  AND age >= 5
                  AND age <= 14, 1, 0)) AS q1FTeens,
           SUM(IF(gender = 'M'
                  AND age > 14, 1, 0)) AS q1MSeniors,
           SUM(IF(gender = 'F'
                  AND age > 14, 1, 0)) AS q1FSeniors,
           SUM(IF((gender = 'F'
                   OR gender = 'M'), 1, 0)) AS q1Total
         FROM
           (SELECT DISTINCT 1 AS indicator_id,
                            'Cummulative No. of clients ever enrolled in HIV care at this facility at the end of the previous quarter' AS q1indicator ) Indicators
           LEFT JOIN
           (SELECT DISTINCT 1 AS indicator_id,
              pp.gender,
              pp.person_id,
                            TIMESTAMPDIFF(YEAR, pp.birthdate, (MAKEDATE(start_year,1) + INTERVAL start_quarter QUARTER - INTERVAL 1 DAY)) AS age
            FROM person pp
              INNER JOIN encounter e ON (e.patient_id = pp.person_id
                                         AND e.encounter_type = (select encounter_type_id from encounter_type where locate('art',name) > 0 and locate('summary',name) > 0)
                                         AND e.voided = 0
                                         AND e.encounter_datetime <= MAKEDATE(start_year, 1) + INTERVAL start_quarter - 1 QUARTER - INTERVAL 1 DAY)) Enrollment USING (indicator_id)
         GROUP BY q1indicator) ind1
        LEFT JOIN
        (SELECT indicator_id,
           q2indicator,
           SUM(IF(gender = 'M'
                  AND age < 2, 1, 0)) AS q2MBabies,
           SUM(IF(gender = 'F'
                  AND age < 2, 1, 0)) AS q2FBabies,
           SUM(IF(gender = 'M'
                  AND age >= 2
                  AND age <= 4, 1, 0)) AS q2MToddlers,
           SUM(IF(gender = 'F'
                  AND age >= 2
                  AND age <= 4, 1, 0)) AS q2FToddlers,
           SUM(IF(gender = 'M'
                  AND age >= 5
                  AND age <= 14, 1, 0)) AS q2MTeens,
           SUM(IF(gender = 'F'
                  AND age >= 5
                  AND age <= 14, 1, 0)) AS q2FTeens,
           SUM(IF(gender = 'M'
                  AND age > 14, 1, 0)) AS q2MSeniors,
           SUM(IF(gender = 'F'
                  AND age > 14, 1, 0)) AS q2FSeniors,
           SUM(IF((gender = 'F'
                   OR gender = 'M'), 1, 0)) AS Total
         FROM
           (SELECT 1 AS indicator_id,
                   'Number of new patients enrolled in HIV care at this  facility during the period' AS q2indicator ) Indicators
           LEFT JOIN
           (SELECT DISTINCT 1 AS indicator_id,
              pp.gender,
              pp.person_id,
                            TIMESTAMPDIFF(YEAR, pp.birthdate, (MAKEDATE(start_year,1) + INTERVAL start_quarter QUARTER - INTERVAL 1 DAY)) AS age
            FROM person pp
              INNER JOIN encounter e ON (e.patient_id = pp.person_id
                                         AND e.encounter_type = (select encounter_type_id from encounter_type where locate('art',name) > 0 and locate('summary',name) > 0)
                                         AND e.voided = 0
                                         AND e.encounter_datetime BETWEEN MAKEDATE(start_year, 1) + INTERVAL start_quarter - 1 QUARTER AND MAKEDATE(start_year, 1) + INTERVAL start_quarter QUARTER - INTERVAL 1 DAY)) Enrollment USING (indicator_id)
         GROUP BY q2indicator) ind2 ON (ind1.indicator_id = ind2.indicator_id)
        LEFT JOIN
        (SELECT indicator_id,
           q3indicator,
           SUM(IF(gender = 'F'
                  AND age >= 5
                  AND age <= 14, 1, 0)) AS q3FTeens,
           SUM(IF(gender = 'F'
                  AND age > 14, 1, 0)) AS q3FSeniors,
           SUM(IF((gender = 'F'), 1, 0)) AS q3Total
         FROM
           (SELECT 1 AS indicator_id,
                   'Number of pregnant and lactating women enrolled into care during the reporting quarter. (subset of row 2 above)' AS q3indicator ) Indicators
           LEFT JOIN
           (SELECT DISTINCT 1 AS indicator_id,
              pp.gender,
              pp.person_id,
                            TIMESTAMPDIFF(YEAR, pp.birthdate, (MAKEDATE(start_year,1) + INTERVAL start_quarter QUARTER - INTERVAL 1 DAY)) AS age
            FROM person pp
              INNER JOIN encounter e ON (e.patient_id = pp.person_id
  									   AND e.encounter_type = (select encounter_type_id from encounter_type where locate('art',name) > 0 and locate('summary',name) > 0)
                                         AND QUARTER(e.encounter_datetime) = start_quarter
                                         AND YEAR(e.encounter_datetime) = start_year)
              INNER JOIN obs o ON (e.encounter_id = o.encounter_id
                                   AND o.concept_id = 90200
                                   AND o.value_coded = 90012)) Enrollment USING (indicator_id)
         GROUP BY q3indicator) ind3 ON (ind2.indicator_id = ind3.indicator_id)
        LEFT JOIN
        (SELECT indicator_id,
           q4indicator,
           SUM(IF((gender = 'F'
                   OR gender = 'M')
                  AND age BETWEEN 0 AND 100, 1, 0)) AS q4Total
         FROM
           (SELECT 1 AS indicator_id,
                   'Number of clients started on INH Prophylaxis during the reporting quarter (Subset of row 2 above)' AS q4indicator ) Indicators
           LEFT JOIN
           (SELECT DISTINCT 1 AS indicator_id,
              p.gender,
              p.person_id,
                            TIMESTAMPDIFF(YEAR, p.birthdate, (MAKEDATE(start_year,1) + INTERVAL start_quarter QUARTER - INTERVAL 1 DAY)) AS age,
                            YEAR(o.obs_datetime) AS 'Year',
                            QUARTER(o.obs_datetime) AS 'quarter'
            FROM person p
              INNER JOIN obs o ON(p.person_id = o.person_id
                                  AND o.concept_id = 99604
                                  AND o.voided =0
                                  AND p.voided = 0
                                  AND o.value_numeric > 0)) Enrollment USING (indicator_id)
         GROUP BY q4indicator) ind4 ON (ind3.indicator_id = ind4.indicator_id)
        LEFT JOIN
        (SELECT indicator_id,
           q5indicator,
           SUM(IF(gender = 'M'
                  AND age < 2, 1, 0)) AS q5MBabies,
           SUM(IF(gender = 'F'
                  AND age < 2, 1, 0)) AS q5FBabies,
           SUM(IF(gender = 'M'
                  AND age >= 2
                  AND age <= 4, 1, 0)) AS q5MToddlers,
           SUM(IF(gender = 'F'
                  AND age >= 2
                  AND age <= 4, 1, 0)) AS q5FToddlers,
           SUM(IF(gender = 'M'
                  AND age >= 5
                  AND age <= 14, 1, 0)) AS q5MTeens,
           SUM(IF(gender = 'F'
                  AND age >= 5
                  AND age <= 14, 1, 0)) AS q5FTeens,
           SUM(IF(gender = 'M'
                  AND age > 14, 1, 0)) AS q5MSeniors,
           SUM(IF(gender = 'F'
                  AND age > 14, 1, 0)) AS q5FSeniors,
           SUM(IF((gender = 'F'
                   OR gender = 'M'), 1, 0)) AS q5Total
         FROM
           (SELECT 1 AS indicator_id,
                   'Cumulative number of clients ever enrolled in HIV care at this facility at the end of the previous quarter (row 1 + row 2)' AS q5indicator ) Indicators
           LEFT JOIN
           (SELECT DISTINCT 1 AS indicator_id,
              pp.gender,
              pp.person_id,
                            TIMESTAMPDIFF(YEAR, pp.birthdate, (MAKEDATE(start_year,1) + INTERVAL start_quarter QUARTER - INTERVAL 1 DAY)) AS age
            FROM person pp
              INNER JOIN encounter e ON (e.patient_id = pp.person_id
                                         AND e.encounter_type = (select encounter_type_id from encounter_type where locate('art',name) > 0 and locate('summary',name) > 0)
                                         AND e.voided = 0
                                         AND e.encounter_datetime <= MAKEDATE(start_year, 1) + INTERVAL start_quarter QUARTER - INTERVAL 1 DAY)) Enrollment USING (indicator_id)
         GROUP BY q5indicator) ind5 ON (ind4.indicator_id = ind5.indicator_id)
        LEFT JOIN
        (SELECT indicator_id,
           q6indicator,
           SUM(IF((gender = 'F'
                   OR gender = 'M')
                  AND age BETWEEN 0 AND 100, 1, 0)) AS q6Total
         FROM
           (SELECT 1 AS indicator_id,
                   'No. of persons already enrolled in HIV care who transfered from another facility during the quarter' AS q6indicator ) Indicators
           LEFT JOIN
           (SELECT DISTINCT 1 AS indicator_id,
              pp.gender,
              pp.person_id,
                            TIMESTAMPDIFF(YEAR, pp.birthdate, (MAKEDATE(start_year,1) + INTERVAL start_quarter QUARTER - INTERVAL 1 DAY)) AS age
            FROM person pp
              INNER JOIN encounter e ON (e.patient_id = pp.person_id
                                         AND e.encounter_type = (select encounter_type_id from encounter_type where locate('art',name) > 0 and locate('summary',name) > 0)
                                         AND QUARTER(e.encounter_datetime) = start_quarter
                                         AND YEAR(e.encounter_datetime) = start_year)
              INNER JOIN obs o ON (e.encounter_id = o.encounter_id
                                   AND o.concept_id = 99110
                                   AND o.value_coded = 90003)) Enrollment USING (indicator_id)
         GROUP BY q6indicator) ind6 ON (ind5.indicator_id = ind6.indicator_id)
        LEFT JOIN
        (SELECT
    indicator_id,
    q7indicator,
    SUM(IF(age <= 14, 1, 0)) AS q71,
    SUM(IF(age > 14, 1, 0)) AS q72,
    SUM(1) AS q7Total
FROM
    (SELECT
        1 AS indicator_id,
            'Number of active clients on pre-ART Care in the quarter' AS q7indicator
    ) Indicators
        LEFT JOIN
    (SELECT DISTINCT
        1 AS indicator_id,
            pp.gender,
            pp.person_id,
            TIMESTAMPDIFF(YEAR, pp.birthdate, (MAKEDATE(start_year, 1) + INTERVAL 1 QUARTER - INTERVAL 1 DAY)) AS age
    FROM
        person pp
    INNER JOIN encounter e ON (e.patient_id = pp.person_id
        AND QUARTER(e.encounter_datetime) = start_quarter
        AND YEAR(e.encounter_datetime) = start_year
        AND e.encounter_type in(select encounter_type_id from encounter_type where locate('art',name) > 0 and locate('card',name) > 0 and locate('encounter',name) > 0 and locate('education',name) = 0)
        AND e.voided = 0
        AND e.patient_id NOT IN (SELECT
            oi.person_id
        FROM
            obs oi
        WHERE
            oi.voided = 0
            AND ((oi.concept_id = 90315 AND oi.value_coded > 0) OR (oi.concept_id = 99061 AND oi.value_coded > 0))
                AND oi.obs_datetime <= (MAKEDATE(start_year, 1) + INTERVAL start_quarter QUARTER - INTERVAL 1 DAY)))
    GROUP BY pp.person_id) enrollment USING (indicator_id)
GROUP BY q7indicator) ind7 ON (ind6.indicator_id = ind7.indicator_id)
        LEFT JOIN
        (SELECT indicator_id,
           q8indicator,
           SUM(IF(age <= 14, 1, 0)) AS q81,
           SUM(IF(age > 14, 1, 0)) AS q82,
           SUM(IF(age BETWEEN 0 AND 100, 1, 0)) AS q8Total
         FROM
           (SELECT 1 AS indicator_id,
                   'Number active on pre-ART who received CPT/Daspone at last  visit in the quarter' AS q8indicator ) Indicators
           LEFT JOIN
           (SELECT DISTINCT 1 AS indicator_id,
              pp.gender,
              pp.person_id,
                            MAX(e.encounter_datetime) en_date,
                            TIMESTAMPDIFF(YEAR, pp.birthdate, CURRENT_DATE()) AS age
            FROM person pp
              INNER JOIN encounter e ON (e.patient_id = pp.person_id
                                         AND e.encounter_type = (select encounter_type_id from encounter_type where locate('art',name) > 0 and locate('card',name) > 0 and locate('encounter',name) > 0 and locate('education',name) = 0)
                                         AND QUARTER(e.encounter_datetime) = start_quarter
                                         AND YEAR(e.encounter_datetime) = start_year
                                         AND e.voided = 0
                                         AND e.patient_id NOT IN
                                             (SELECT DISTINCT oi.person_id
                                              FROM obs oi
                                              WHERE oi.concept_id = 90315
                                                    AND oi.value_coded > 0
                                                    AND oi.voided = 0
                                                    AND QUARTER(oi.obs_datetime) = start_quarter
                                                    AND YEAR(oi.obs_datetime) = start_year))
              INNER JOIN obs o ON (e.encounter_id = o.encounter_id
                                   AND o.voided = 0
                                   AND o.concept_id = 99037
                                   AND o.value_numeric > 0)
            GROUP BY pp.person_id) enrollment USING (indicator_id)
         GROUP BY q8indicator) ind8 ON (ind7.indicator_id = ind8.indicator_id)
        LEFT JOIN
        (SELECT indicator_id,
           q9indicator,
           SUM(IF((gender = 'F'
                   OR gender = 'M')
                  AND age BETWEEN 0 AND 100, 1, 0)) AS q9Total
         FROM
           (SELECT 1 AS indicator_id,
                   'No. active on pre-ART Care assessed for TB at last visit in the quarter' AS q9indicator ) Indicators
           LEFT JOIN
           (SELECT DISTINCT 1 AS indicator_id,
              pp.gender,
              pp.person_id,
                            MAX(e.encounter_datetime) en_date,
                            TIMESTAMPDIFF(YEAR, pp.birthdate, CURRENT_DATE()) AS age
            FROM person pp
              INNER JOIN encounter e ON (e.patient_id = pp.person_id
                                         AND QUARTER(e.encounter_datetime) = start_quarter
                                         AND YEAR(e.encounter_datetime) = start_year
                                         AND e.voided = 0
                                         AND e.patient_id NOT IN
                                             (SELECT DISTINCT person_id
                                              FROM obs oi
                                              WHERE oi.concept_id = 90315
                                                    AND oi.value_coded > 0
                                                    AND oi.voided = 0
                                                    AND QUARTER(oi.obs_datetime) = start_quarter
                                                    AND YEAR(oi.obs_datetime) = start_year))
              INNER JOIN obs o ON (e.encounter_id = o.encounter_id
                                   AND o.voided = 0
                                   AND o.concept_id = 90216
                                   AND o.value_coded > 0)
            GROUP BY pp.person_id) enrollment USING (indicator_id)
         GROUP BY q9indicator) ind9 ON (ind8.indicator_id = ind9.indicator_id)
        LEFT JOIN
        (SELECT indicator_id,
           q10indicator,
           SUM(IF((gender = 'F'
                   OR gender = 'M')
                  AND age BETWEEN 0 AND 100, 1, 0)) AS q10Total
         FROM
           (SELECT 1 AS indicator_id,
                   'No. active on pre-ART Care diagnosed with TB in the quarter' AS q10indicator ) Indicators
           LEFT JOIN
           (SELECT DISTINCT 1 AS indicator_id,
              pp.gender,
              pp.person_id,
                            MAX(e.encounter_datetime) en_date,
                            TIMESTAMPDIFF(YEAR, pp.birthdate, CURRENT_DATE()) AS age
            FROM person pp
              INNER JOIN patient p ON (pp.person_id = p.patient_id
                                       AND p.voided = 0)
              INNER JOIN encounter e ON (e.patient_id = p.patient_id
                                         AND QUARTER(e.encounter_datetime) = start_quarter
                                         AND YEAR(e.encounter_datetime) = start_year
                                         AND e.voided = 0
                                         AND e.patient_id NOT IN
                                             (SELECT DISTINCT oi.person_id
                                              FROM obs oi WHERE oi.concept_id = 90315
                                                                AND oi.value_coded > 0
                                                                AND oi.voided = 0
                                                                AND QUARTER(oi.obs_datetime) = start_quarter
                                                                AND YEAR(oi.obs_datetime) = start_year))
              INNER JOIN obs o ON (e.encounter_id = o.encounter_id
                                   AND o.voided = 0
                                   AND o.concept_id = 90216
                                   AND o.value_coded = 90078)
            GROUP BY pp.person_id) enrollment USING (indicator_id)
         GROUP BY q10indicator) ind10 ON (ind9.indicator_id = ind10.indicator_id)
        LEFT JOIN
        (SELECT indicator_id,
           q11indicator,
           SUM(IF((gender = 'F'
                   OR gender = 'M')
                  AND age BETWEEN 0 AND 100, 1, 0)) AS q11Total
         FROM
           (SELECT 1 AS indicator_id,
                   'No. active on pre-ART Care started on anti-TB treatment during the quarter' AS q11indicator ) Indicators
           LEFT JOIN
           (SELECT DISTINCT 1 AS indicator_id,
              pp.gender,
              pp.person_id,
                            MAX(e.encounter_datetime) en_date,
                            TIMESTAMPDIFF(YEAR, pp.birthdate, CURRENT_DATE()) AS age
            FROM person pp
              INNER JOIN patient p ON (pp.person_id = p.patient_id
                                       AND p.voided = 0)
              INNER JOIN encounter e ON (e.patient_id = p.patient_id
                                         AND form_id = 12
                                         AND QUARTER(e.encounter_datetime) = 1
                                         AND YEAR(e.encounter_datetime) = start_year
                                         AND e.voided = 0
                                         AND e.patient_id NOT IN
                                             (SELECT DISTINCT oi.person_id
                                              FROM obs oi WHERE oi.concept_id = 90315
                                                                AND oi.value_coded > 0
                                                                AND oi.voided = 0
                                                                AND QUARTER(oi.obs_datetime) = start_quarter
                                                                AND YEAR(oi.obs_datetime) = start_year))
              INNER JOIN obs o ON (e.encounter_id = o.encounter_id
                                   AND o.voided = 0
                                   AND o.concept_id = 90216
                                   AND o.value_coded = 90071)
            GROUP BY pp.person_id) enrollment USING (indicator_id)
         GROUP BY q11indicator) ind11 ON (ind10.indicator_id = ind11.indicator_id)
        LEFT JOIN
        (SELECT indicator_id,
           q12indicator,
           SUM(IF((gender = 'F'
                   OR gender = 'M')
                  AND age BETWEEN 0 AND 100, 1, 0)) AS q12Total
         FROM
           (SELECT 1 AS indicator_id,
                   'No. active on pre-ART Care assessed for Malnutrition at their visit in the quarter' AS q12indicator ) Indicators
           LEFT JOIN
           (SELECT DISTINCT 1 AS indicator_id,
              pp.gender,
              pp.person_id,
                            MAX(e.encounter_datetime) en_date,
                            TIMESTAMPDIFF(YEAR, pp.birthdate, CURRENT_DATE()) AS age
            FROM person pp
              INNER JOIN encounter e ON (e.patient_id = pp.person_id
                                         AND QUARTER(e.encounter_datetime) = start_quarter
                                         AND YEAR(e.encounter_datetime) = start_year
                                         AND e.voided = 0
                                         AND e.patient_id NOT IN
                                             (SELECT DISTINCT oi.person_id
                                              FROM obs oi WHERE oi.concept_id = 90315
                                                                AND oi.value_coded > 0
                                                                AND oi.voided = 0
                                                                AND QUARTER(oi.obs_datetime) = start_quarter
                                                                AND YEAR(oi.obs_datetime) = start_year))
              INNER JOIN obs o ON (e.encounter_id = o.encounter_id
                                   AND o.voided = 0
                                   AND o.concept_id IN (90236,5090,99030,99069) AND (o.value_numeric > 0 OR o.value_coded > 0))
            GROUP BY pp.person_id) enrollment USING (indicator_id)
         GROUP BY q12indicator) ind12 ON (ind11.indicator_id = ind12.indicator_id)
        INNER JOIN
        (SELECT indicator_id,
           q13indicator,
           SUM(IF((gender = 'F'
                   OR gender = 'M')
                  AND age BETWEEN 0 AND 100, 1, 0)) AS q13Total
         FROM
           (SELECT 1 AS indicator_id,
                   'No. active on pre-ART Care who are malnourished at their last visit in the quarter' AS q13indicator ) Indicators
           LEFT JOIN
           (SELECT DISTINCT 1 AS indicator_id,
              pp.gender,
              pp.person_id,
                            MAX(e.encounter_datetime) en_date,
                            TIMESTAMPDIFF(YEAR, pp.birthdate, CURRENT_DATE()) AS age
            FROM person pp
              INNER JOIN patient p ON (pp.person_id = p.patient_id
                                       AND p.voided = 0)
              INNER JOIN encounter e ON (e.patient_id = p.patient_id
                                         AND QUARTER(e.encounter_datetime) = start_year
                                         AND YEAR(e.encounter_datetime) = start_year
                                         AND e.voided = 0
                                         AND e.patient_id NOT IN
                                             (SELECT DISTINCT oi.person_id
                                              FROM  obs oi WHERE oi.concept_id = 90315
                                                                 AND oi.value_coded > 0
                                                                 AND oi.voided = 0
                                                                 AND QUARTER(oi.obs_datetime) = start_quarter
                                                                 AND YEAR(oi.obs_datetime) = start_year))
              INNER JOIN obs o ON (e.encounter_id = o.encounter_id
                                   AND o.voided = 0
                                   AND ((o.concept_id = 68 AND o.value_coded IN (99271,99272,99273)) OR (o.concept_id = 99030 AND o.value_coded IN (99028,99029)) OR (o.concept_id = 460 AND o.value_coded = 90003)))
            GROUP BY pp.person_id) enrollment USING (indicator_id)
         GROUP BY q13indicator) ind13 ON (ind12.indicator_id = ind13.indicator_id)
        INNER JOIN
        (SELECT indicator_id,
           q14indicator,
           SUM(IF((gender = 'F'
                   OR gender = 'M')
                  AND age BETWEEN 0 AND 100, 1, 0)) AS q14Total
         FROM
           (SELECT 1 AS indicator_id,
                   'No. active on pre-ART Care eligible and ready but not started on ART by the end of the quarter' AS q14indicator ) Indicators
           LEFT JOIN
           (SELECT DISTINCT 1 AS indicator_id,
              pp.gender,
              pp.person_id,
                            TIMESTAMPDIFF(YEAR, pp.birthdate, CURRENT_DATE()) AS age
            FROM person pp
              INNER JOIN patient p ON (pp.person_id = p.patient_id
                                       AND p.voided = 0)
              INNER JOIN encounter e ON (e.patient_id = p.patient_id
                                         AND form_id = 12
                                         AND e.voided = 0
                                         AND e.patient_id NOT IN
                                             (SELECT DISTINCT oi.person_id FROM obs oi WHERE oi.concept_id = 90315
                                                                                             AND oi.value_coded > 0
                                                                                             AND oi.voided = 0))
              INNER JOIN obs o ON (e.encounter_id = o.encounter_id
                                   AND o.voided = 0
                                   AND YEAR(o.value_datetime) = start_year
                                   AND QUARTER(o.value_datetime) = start_quarter AND o.concept_id = 90299)
            GROUP BY pp.person_id) enrollment USING (indicator_id)
         GROUP BY q14indicator) ind14 ON (ind13.indicator_id = ind14.indicator_id)
        INNER JOIN
        (SELECT indicator_id,
           q15indicator,
           SUM(IF(gender = 'M'
                  AND age < 2, 1, 0)) AS q15MBabies,
           SUM(IF(gender = 'F'
                  AND age < 2, 1, 0)) AS q15FBabies,
           SUM(IF(gender = 'M'
                  AND age BETWEEN 2 AND 4, 1, 0)) AS q15MToddlers,
           SUM(IF(gender = 'F'
                  AND age BETWEEN 2 AND 4, 1, 0)) AS q15FToddlers,
           SUM(IF(gender = 'M'
                  AND age BETWEEN 5 AND 14, 1, 0)) AS q15MTeens,
           SUM(IF(gender = 'F'
                  AND age BETWEEN 5 AND 14, 1, 0)) AS q15FTeens,
           SUM(IF(gender = 'M'
                  AND age > 14, 1, 0)) AS q15MSeniors,
           SUM(IF(gender = 'F'
                  AND age > 14, 1, 0)) AS q15FSeniors,
           SUM(IF((gender = 'F'
                   OR gender = 'M')
                  AND age BETWEEN 0 AND 100, 1, 0)) AS q15Total
         FROM
           (SELECT 1 AS indicator_id,
                   'Cumulative No. of clients ever enrolled on ART at this facility at the end of the previous  quarter' AS q15indicator ) Indicators
           LEFT JOIN
           (SELECT DISTINCT 1 AS indicator_id,
              pp.gender,
              pp.person_id,
                            TIMESTAMPDIFF(YEAR, pp.birthdate, CURRENT_DATE()) AS age
            FROM person pp
              INNER JOIN encounter e ON (e.patient_id = pp.person_id
                                         AND e.voided = 0
                                         AND e.encounter_datetime <= MAKEDATE(start_year, 1) + INTERVAL start_quarter - 1 QUARTER - INTERVAL 1 DAY)
              INNER JOIN obs o ON (e.encounter_id = o.encounter_id
                                   AND o.voided = 0
                                   AND o.concept_id  IN (99161,99160))
            GROUP BY pp.person_id) enrollment USING (indicator_id)
         GROUP BY q15indicator) ind15 ON (ind14.indicator_id = ind15.indicator_id)
        INNER JOIN
        (SELECT indicator_id,
           q16indicator,
           SUM(IF(gender = 'M'
                  AND age < 2, 1, 0)) AS q16MBabies,
           SUM(IF(gender = 'F'
                  AND age < 2, 1, 0)) AS q16FBabies,
           SUM(IF(gender = 'M'
                  AND age BETWEEN 2 AND 4, 1, 0)) AS q16MToddlers,
           SUM(IF(gender = 'F'
                  AND age BETWEEN 2 AND 4, 1, 0)) AS q16FToddlers,
           SUM(IF(gender = 'M'
                  AND age BETWEEN 5 AND 14, 1, 0)) AS q16MTeens,
           SUM(IF(gender = 'F'
                  AND age BETWEEN 5 AND 14, 1, 0)) AS q16FTeens,
           SUM(IF(gender = 'M'
                  AND age > 14, 1, 0)) AS q16MSeniors,
           SUM(IF(gender = 'F'
                  AND age > 14, 1, 0)) AS q16FSeniors,
           SUM(IF((gender = 'F'
                   OR gender = 'M')
                  AND age BETWEEN 0 AND 100, 1, 0)) AS q16Total
         FROM
           (SELECT 1 AS indicator_id,
                   'No. of new clients started on ART at this facility during the quarter' AS q16indicator ) Indicators
           LEFT JOIN
           (SELECT DISTINCT 1 AS indicator_id,
              pp.gender,
              pp.person_id,
                            TIMESTAMPDIFF(YEAR, pp.birthdate, CURRENT_DATE()) AS age
            FROM person pp
              INNER JOIN encounter e ON (e.patient_id = pp.person_id
                                         AND e.voided = 0
                                         AND QUARTER(e.encounter_datetime) = start_quarter
                                         AND YEAR(e.encounter_datetime) = start_year)
              INNER JOIN obs o ON (e.encounter_id = o.encounter_id
                                   AND o.voided = 0
                                   AND o.concept_id IN (99161,99160))
            GROUP BY pp.person_id) enrollment USING (indicator_id)
         GROUP BY q16indicator) ind16 ON (ind15.indicator_id = ind16.indicator_id)
        INNER JOIN
        (SELECT indicator_id,
           q17indicator,
           SUM(IF((gender = 'F'
                   OR gender = 'M')
                  AND age BETWEEN 0 AND 100, 1, 0)) AS q17Total
         FROM
           (SELECT 1 AS indicator_id,
                   'No. Of new clients started on ART at this facility during the quarter based on CD4 count' AS q17indicator ) Indicators
           LEFT JOIN
           (SELECT DISTINCT 1 AS indicator_id,
              pp.gender,
              pp.person_id,
                            TIMESTAMPDIFF(YEAR, pp.birthdate, CURRENT_DATE()) AS age
            FROM person pp
              INNER JOIN encounter e ON (e.patient_id = pp.person_id
                                         AND e.voided = 0
                                         AND QUARTER(e.encounter_datetime) = start_quarter
                                         AND YEAR(e.encounter_datetime) = start_year)
                                        AND e.patient_id IN (SELECT DISTINCT oi.person_id FROM obs oi WHERE oi.concept_id = 99082 AND oi.value_numeric > 0 AND oi.voided = 0)
              INNER JOIN obs o ON (e.encounter_id = o.encounter_id AND o.voided = 0 AND o.concept_id = 99161)
            GROUP BY pp.person_id) enrollment USING (indicator_id)
         GROUP BY q17indicator) ind17 ON (ind16.indicator_id = ind17.indicator_id)
        INNER JOIN
        (SELECT indicator_id,
           q18indicator,
           SUM(IF(gender = 'F'
                  AND age BETWEEN 5 AND 14, 1, 0)) AS q18FTeens,
           SUM(IF(gender = 'F'
                  AND age > 14, 1, 0)) AS q18FSeniors,
           SUM(IF((gender = 'F'
                   OR gender = 'M')
                  AND age BETWEEN 0 AND 100, 1, 0)) AS q18Total
         FROM
           (SELECT 1 AS indicator_id,
                   'No. of pregnant women started on ART at this facility during the quarter (Subset of row 16 above)' AS q18indicator ) Indicators
           LEFT JOIN
           (SELECT DISTINCT 1 AS indicator_id,
              pp.gender,
              pp.person_id,
                            TIMESTAMPDIFF(YEAR, pp.birthdate, CURRENT_DATE()) AS age
            FROM person pp
              INNER JOIN encounter e ON (e.patient_id = pp.person_id
                                         AND e.voided = 0
                                         AND QUARTER(e.encounter_datetime) = start_quarter
                                         AND YEAR(e.encounter_datetime) = start_year)
                                        AND e.patient_id IN
                                            (SELECT DISTINCT ei.patient_id
                                             FROM encounter ei
                                               INNER JOIN obs oi ON (oi.encounter_id = ei.encounter_id
                                                                     AND ((oi.concept_id = 90012 AND oi.value_coded = 90003))
                                                                     AND oi.voided = 0))
              INNER JOIN obs o ON (e.encounter_id = o.encounter_id
                                   AND o.voided = 0
                                   AND o.concept_id IN(99161,99160))
            GROUP BY pp.person_id) enrollment USING (indicator_id)
         GROUP BY q18indicator) ind18 ON (ind17.indicator_id = ind18.indicator_id)
        INNER JOIN
        (SELECT indicator_id,
           q19indicator,
           SUM(IF(gender = 'M'
                  AND age < 2, 1, 0)) AS q19MBabies,
           SUM(IF(gender = 'F'
                  AND age < 2, 1, 0)) AS q19FBabies,
           SUM(IF(gender = 'M'
                  AND age BETWEEN 2 AND 4, 1, 0)) AS q19MToddlers,
           SUM(IF(gender = 'F'
                  AND age BETWEEN 2 AND 4, 1, 0)) AS q19FToddlers,
           SUM(IF(gender = 'M'
                  AND age BETWEEN 5 AND 14, 1, 0)) AS q19MTeens,
           SUM(IF(gender = 'F'
                  AND age BETWEEN 5 AND 14, 1, 0)) AS q19FTeens,
           SUM(IF(gender = 'M'
                  AND age > 14, 1, 0)) AS q19MSeniors,
           SUM(IF(gender = 'F'
                  AND age > 14, 1, 0)) AS q19FSeniors,
           SUM(IF((gender = 'F'
                   OR gender = 'M')
                  AND age BETWEEN 0 AND 100, 1, 0)) AS q19Total
         FROM
           (SELECT 1 AS indicator_id,
                   'Cumulative No. of individuals ever started on ART (row 15 + row 16)' AS q19indicator ) Indicators
           LEFT JOIN
           (SELECT DISTINCT 1 AS indicator_id,
              pp.gender,
              pp.person_id,
                            TIMESTAMPDIFF(YEAR, pp.birthdate, CURRENT_DATE()) AS age
            FROM person pp
              INNER JOIN encounter e ON (e.patient_id = pp.person_id
                                         AND e.voided = 0
                                         AND e.encounter_datetime <= MAKEDATE(start_year, 1) + INTERVAL start_quarter QUARTER - INTERVAL 1 DAY)
              INNER JOIN obs o ON (e.encounter_id = o.encounter_id
                                   AND o.voided = 0
                                   AND o.concept_id IN(99161,99160))
            GROUP BY pp.person_id) enrollment USING (indicator_id)
         GROUP BY q19indicator) ind19 ON (ind18.indicator_id = ind19.indicator_id)
        INNER JOIN
        (SELECT indicator_id,
           q20indicator,
           SUM(IF(gender = 'M'
                  AND age < 2, 1, 0)) AS q20MBabies,
           SUM(IF(gender = 'F'
                  AND age < 2, 1, 0)) AS q20FBabies,
           SUM(IF(gender = 'M'
                  AND age BETWEEN 2 AND 4, 1, 0)) AS q20MToddlers,
           SUM(IF(gender = 'F'
                  AND age BETWEEN 2 AND 4, 1, 0)) AS q20FToddlers,
           SUM(IF(gender = 'M'
                  AND age BETWEEN 5 AND 14, 1, 0)) AS q20MTeens,
           SUM(IF(gender = 'F'
                  AND age BETWEEN 5 AND 14, 1, 0)) AS q20FTeens,
           SUM(IF(gender = 'M'
                  AND age > 14, 1, 0)) AS q20MSeniors,
           SUM(IF(gender = 'F'
                  AND age > 14, 1, 0)) AS q20FSeniors,
           SUM(IF((gender = 'F'
                   OR gender = 'M')
                  AND age BETWEEN 0 AND 100, 1, 0)) AS q20Total
         FROM
           (SELECT 1 AS indicator_id,
                   'No. active on ART on 1st line ARV regimen' AS q20indicator ) Indicators
           LEFT JOIN
           (SELECT DISTINCT 1 AS indicator_id,
              pp.gender,
              pp.person_id,
                            TIMESTAMPDIFF(YEAR, pp.birthdate, CURRENT_DATE()) AS age
            FROM person pp
              INNER JOIN encounter e ON (e.patient_id = pp.person_id
                                         AND e.voided = 0)
              INNER JOIN obs o ON (e.encounter_id = o.encounter_id
                                   AND o.voided = 0
                                   AND YEAR(e.encounter_datetime) = start_year
                                   AND QUARTER(e.encounter_datetime) = start_quarter
                                   AND o.concept_id = 90315
                                   AND o.value_coded IN (99015,
                99016,
                99005,
                99006,
                99039,
                99040,
                99041,
                163017,
                99042,
                99884,
                99885,
                                                         99143))
            GROUP BY pp.person_id) enrollment USING (indicator_id)
         GROUP BY q20indicator) ind20 ON (ind19.indicator_id = ind20.indicator_id)
        INNER JOIN
        (SELECT indicator_id,
           q21indicator,
           SUM(IF(gender = 'M'
                  AND age < 2, 1, 0)) AS q21MBabies,
           SUM(IF(gender = 'F'
                  AND age < 2, 1, 0)) AS q21FBabies,
           SUM(IF(gender = 'M'
                  AND age BETWEEN 2 AND 4, 1, 0)) AS q21MToddlers,
           SUM(IF(gender = 'F'
                  AND age BETWEEN 2 AND 4, 1, 0)) AS q21FToddlers,
           SUM(IF(gender = 'M'
                  AND age BETWEEN 5 AND 14, 1, 0)) AS q21MTeens,
           SUM(IF(gender = 'F'
                  AND age BETWEEN 5 AND 14, 1, 0)) AS q21FTeens,
           SUM(IF(gender = 'M'
                  AND age > 14, 1, 0)) AS q21MSeniors,
           SUM(IF(gender = 'F'
                  AND age > 14, 1, 0)) AS q21FSeniors,
           SUM(IF((gender = 'F'
                   OR gender = 'M')
                  AND age BETWEEN 0 AND 100, 1, 0)) AS q21Total
         FROM
           (SELECT 1 AS indicator_id,
                   'No. active on ART on 2nd line ARV regimen' AS q21indicator ) Indicators
           LEFT JOIN
           (SELECT DISTINCT 1 AS indicator_id,
              pp.gender,
              pp.person_id,
                            TIMESTAMPDIFF(YEAR, pp.birthdate, CURRENT_DATE()) AS age
            FROM person pp
              INNER JOIN encounter e ON (e.patient_id = pp.person_id
                                         AND e.voided = 0)
              INNER JOIN obs o ON (e.encounter_id = o.encounter_id
                                   AND o.voided = 0
                                   AND YEAR(e.encounter_datetime) = start_year
                                   AND QUARTER(e.encounter_datetime) = start_quarter
                                   AND o.concept_id = 90315
                                   AND o.value_coded IN (99007,
                99008,
                99044,
                99043,
                99282,
                99283,
                99046,
                99017,
                99018,
                99019,
                99045,
                                                         99284,
                                                         99285,
                                                         99286,
                                                         99046,
                                                         99887,
                                                         99888,
                                                         99144))
            GROUP BY pp.person_id) enrollment USING (indicator_id)
         GROUP BY q21indicator) ind21 ON (ind20.indicator_id = ind21.indicator_id)
        INNER JOIN
        (SELECT indicator_id,
           q22indicator,
           SUM(IF(gender = 'M'
                  AND age < 2, 1, 0)) AS q22MBabies,
           SUM(IF(gender = 'F'
                  AND age < 2, 1, 0)) AS q22FBabies,
           SUM(IF(gender = 'M'
                  AND age BETWEEN 2 AND 4, 1, 0)) AS q22MToddlers,
           SUM(IF(gender = 'F'
                  AND age BETWEEN 2 AND 4, 1, 0)) AS q22FToddlers,
           SUM(IF(gender = 'M'
                  AND age BETWEEN 5 AND 14, 1, 0)) AS q22MTeens,
           SUM(IF(gender = 'F'
                  AND age BETWEEN 5 AND 14, 1, 0)) AS q22FTeens,
           SUM(IF(gender = 'M'
                  AND age > 14, 1, 0)) AS q22MSeniors,
           SUM(IF(gender = 'F'
                  AND age > 14, 1, 0)) AS q22FSeniors,
           SUM(IF((gender = 'F'
                   OR gender = 'M')
                  AND age BETWEEN 0 AND 100, 1, 0)) AS q22Total
         FROM
           (SELECT 1 AS indicator_id,
                   'No. active on ART on 3rd line or higher ARV regimen' AS q22indicator ) Indicators
           LEFT JOIN
           (SELECT DISTINCT 1 AS indicator_id,
              pp.gender,
              pp.person_id,
                            TIMESTAMPDIFF(YEAR, pp.birthdate, CURRENT_DATE()) AS age
            FROM person pp
              INNER JOIN encounter e ON (e.patient_id = pp.person_id
                                         AND e.voided = 0)
              INNER JOIN obs o ON (e.encounter_id = o.encounter_id
                                   AND o.voided = 0
                                   AND YEAR(e.encounter_datetime) = start_year
                                   AND QUARTER(e.encounter_datetime) = start_quarter
                                   AND o.concept_id = 162990
                                   AND o.value_coded IN (162986,
                                                         90002,
                                                         162987))
            GROUP BY pp.person_id) enrollment USING (indicator_id)
         GROUP BY q22indicator) ind22 ON (ind21.indicator_id = ind22.indicator_id)
        INNER JOIN
        (SELECT indicator_id,
           q23indicator,
           SUM(IF(gender = 'M'
                  AND age < 2, 1, 0)) AS q23MBabies,
           SUM(IF(gender = 'F'
                  AND age < 2, 1, 0)) AS q23FBabies,
           SUM(IF(gender = 'M'
                  AND age BETWEEN 2 AND 4, 1, 0)) AS q23MToddlers,
           SUM(IF(gender = 'F'
                  AND age BETWEEN 2 AND 4, 1, 0)) AS q23FToddlers,
           SUM(IF(gender = 'M'
                  AND age BETWEEN 5 AND 14, 1, 0)) AS q23MTeens,
           SUM(IF(gender = 'F'
                  AND age BETWEEN 5 AND 14, 1, 0)) AS q23FTeens,
           SUM(IF(gender = 'M'
                  AND age > 14, 1, 0)) AS q23MSeniors,
           SUM(IF(gender = 'F'
                  AND age > 14, 1, 0)) AS q23FSeniors,
           SUM(IF((gender = 'F'
                   OR gender = 'M')
                  AND age BETWEEN 0 AND 100, 1, 0)) AS q23Total
         FROM
           (SELECT 1 AS indicator_id,
                   'No. active on ART who received CPT/Dapsone at the last visit in the quarter' AS q23indicator ) Indicators
           LEFT JOIN
           (SELECT DISTINCT 1 AS indicator_id,
              pp.gender,
              pp.person_id,
                            MAX(e.encounter_datetime) en_date,
                            TIMESTAMPDIFF(YEAR, pp.birthdate, CURRENT_DATE()) AS age
            FROM person pp
              INNER JOIN encounter e ON (e.patient_id = pp.person_id
                                         AND QUARTER(e.encounter_datetime) = start_quarter
                                         AND YEAR(e.encounter_datetime) = start_year
                                         AND e.voided = 0)
              INNER JOIN obs o ON (e.encounter_id = o.encounter_id
                                   AND o.concept_id = 99037
                                   AND o.value_numeric > 0
                                   AND o.voided = 0
                                   AND e.patient_id IN
                                       (SELECT DISTINCT patient_id
                                        FROM  obs oi WHERE oi.concept_id = 90315
                                                           AND oi.value_coded > 0
                                                           AND oi.voided = 0
                                                           AND QUARTER(oi.obs_datetime) = start_quarter
                                                           AND YEAR(oi.obs_datetime) = start_year))
            GROUP BY pp.person_id) enrollment USING (indicator_id)
         GROUP BY q23indicator) ind23 ON (ind22.indicator_id = ind23.indicator_id)
        INNER JOIN
        (SELECT indicator_id,
           q24indicator,
           SUM(IF((gender = 'F'
                   OR gender = 'M')
                  AND age BETWEEN 0 AND 100, 1, 0)) AS q24Total
         FROM
           (SELECT 1 AS indicator_id,
                   'No. active on ART assessed for TB at last visit in the  quarter' AS q24indicator ) Indicators
           LEFT JOIN
           (SELECT DISTINCT 1 AS indicator_id,
              pp.gender,
              pp.person_id,
                            MAX(e.encounter_datetime) en_date,
                            TIMESTAMPDIFF(YEAR, pp.birthdate, CURRENT_DATE()) AS age
            FROM person pp
              INNER JOIN encounter e ON (e.patient_id = pp.person_id
                                         AND QUARTER(e.encounter_datetime) = start_quarter
                                         AND YEAR(e.encounter_datetime) = start_year
                                         AND e.voided = 0
                                         AND e.patient_id IN
                                             (SELECT DISTINCT patient_id
                                              FROM encounter ei
                                                JOIN obs oi ON (ei.encounter_id = oi.encounter_id
                                                                AND oi.concept_id = 90315
                                                                AND oi.value_coded > 0
                                                                AND oi.voided = 0
                                                                AND QUARTER(ei.encounter_datetime) = start_quarter
                                                                AND YEAR(ei.encounter_datetime) = start_year)))
              INNER JOIN obs o ON (e.encounter_id = o.encounter_id
                                   AND o.voided = 0
                                   AND o.concept_id = 90216
                                   AND o.value_coded > 0)
            GROUP BY pp.person_id) enrollment USING (indicator_id)
         GROUP BY q24indicator) ind24 ON (ind23.indicator_id = ind24.indicator_id)
        INNER JOIN
        (SELECT indicator_id,
           q25indicator,
           SUM(IF((gender = 'F'
                   OR gender = 'M')
                  AND age BETWEEN 0 AND 100, 1, 0)) AS q25Total
         FROM
           (SELECT 1 AS indicator_id,
                   'No. active on ART diagnosed with TB during the quarter' AS q25indicator ) Indicators
           LEFT JOIN
           (SELECT DISTINCT 1 AS indicator_id,
              pp.gender,
              pp.person_id,
                            MAX(e.encounter_datetime) en_date,
                            TIMESTAMPDIFF(YEAR, pp.birthdate, CURRENT_DATE()) AS age
            FROM person pp
              INNER JOIN encounter e ON (e.patient_id = pp.person_id
                                         AND QUARTER(e.encounter_datetime) = start_quarter
                                         AND YEAR(e.encounter_datetime) = start_year
                                         AND e.voided = 0
                                         AND e.patient_id IN
                                             (SELECT DISTINCT patient_id
                                              FROM obs oi WHERE oi.concept_id = 90315
                                                                AND oi.value_coded > 0
                                                                AND oi.voided = 0
                                                                AND QUARTER(oi.obs_datetime) = start_quarter
                                                                AND YEAR(oi.obs_datetime) = start_year))
              INNER JOIN obs o ON (e.encounter_id = o.encounter_id
                                   AND o.voided = 0
                                   AND o.concept_id = 90216
                                   AND o.value_coded = 90078)
            GROUP BY pp.person_id) enrollment USING (indicator_id)
         GROUP BY q25indicator) ind25 ON (ind24.indicator_id = ind25.indicator_id)
        INNER JOIN
        (SELECT indicator_id,
           q26indicator,
           SUM(IF((gender = 'F'
                   OR gender = 'M')
                  AND age BETWEEN 0 AND 100, 1, 0)) AS q26Total
         FROM
           (SELECT 1 AS indicator_id,
                   'No. active on ART started on TB treatment during the quarter(New TB cases)' AS q26indicator ) Indicators
           LEFT JOIN
           (SELECT DISTINCT 1 AS indicator_id,
              pp.gender,
              pp.person_id,
                            MAX(e.encounter_datetime) en_date,
                            TIMESTAMPDIFF(YEAR, pp.birthdate, CURRENT_DATE()) AS age
            FROM person pp
              INNER JOIN encounter e ON (e.patient_id = pp.person_id
                                         AND QUARTER(e.encounter_datetime) = start_quarter
                                         AND YEAR(e.encounter_datetime) = start_year
                                         AND e.voided = 0
                                         AND e.patient_id IN
                                             (SELECT DISTINCT patient_id
                                              FROM obs oi WHERE oi.concept_id = 90315
                                                                AND oi.value_coded > 0
                                                                AND oi.voided = 0
                                                                AND QUARTER(oi.obs_datetime) = start_quarter
                                                                AND YEAR(oi.obs_datetime) = start_year))
              INNER JOIN obs o ON (e.encounter_id = o.encounter_id
                                   AND o.voided = 0
                                   AND o.concept_id = 90217
                                   AND QUARTER(o.value_datetime) = start_quarter
                                   AND YEAR(o.value_datetime) = start_year)
            GROUP BY pp.person_id) enrollment USING (indicator_id)
         GROUP BY q26indicator) ind26 ON (ind25.indicator_id = ind26.indicator_id)
        INNER JOIN
        (SELECT indicator_id,
           q27indicator,
           SUM(IF((gender = 'F'
                   OR gender = 'M')
                  AND age BETWEEN 0 AND 100, 1, 0)) AS q27Total
         FROM
           (SELECT 1 AS indicator_id,
                   'Total No. active on ART  and on TB treatment during the quarter' AS q27indicator ) Indicators
           LEFT JOIN
           (SELECT DISTINCT 1 AS indicator_id,
              pp.gender,
              pp.person_id,
                            MAX(e.encounter_datetime) en_date,
                            TIMESTAMPDIFF(YEAR, pp.birthdate, CURRENT_DATE()) AS age
            FROM person pp
              INNER JOIN encounter e ON (e.patient_id = pp.person_id
                                         AND form_id = 12
                                         AND QUARTER(e.encounter_datetime) = start_quarter
                                         AND YEAR(e.encounter_datetime) = start_year
                                         AND e.voided = 0
                                         AND e.patient_id IN
                                             (SELECT DISTINCT patient_id
                                              FROM encounter ei
                                                JOIN obs oi ON (ei.encounter_id = oi.encounter_id
                                                                AND oi.concept_id = 90315
                                                                AND oi.value_coded > 0
                                                                AND oi.voided = 0
                                                                AND QUARTER(ei.encounter_datetime) = start_quarter
                                                                AND YEAR(ei.encounter_datetime) = start_year)))
              INNER JOIN obs o ON (e.encounter_id = o.encounter_id
                                   AND o.voided = 0
                                   AND o.concept_id = 90216
                                   AND o.value_coded = 90071)
            GROUP BY pp.person_id) enrollment USING (indicator_id)
         GROUP BY q27indicator) ind27 ON (ind26.indicator_id = ind27.indicator_id)
        INNER JOIN
        (SELECT indicator_id,
           q28indicator,
           SUM(IF((gender = 'F'
                   OR gender = 'M')
                  AND age BETWEEN 0 AND 100, 1, 0)) AS q28Total
         FROM
           (SELECT 1 AS indicator_id,
                   'No. active on ART with Good adherence(>95%) during the quarter' AS q28indicator ) Indicators
           LEFT JOIN
           (SELECT DISTINCT 1 AS indicator_id,
              pp.gender,
              pp.person_id,
                            MAX(e.encounter_datetime) en_date,
                            TIMESTAMPDIFF(YEAR, pp.birthdate, CURRENT_DATE()) AS age
            FROM person pp
              INNER JOIN encounter e ON (e.patient_id = pp.person_id
                                         AND QUARTER(e.encounter_datetime) = start_quarter
                                         AND YEAR(e.encounter_datetime) = start_year
                                         AND e.voided = 0)
              INNER JOIN obs o ON (e.encounter_id = o.encounter_id
                                   AND o.voided = 0
                                   AND o.concept_id = 90221
                                   AND o.value_coded = 90156)
            GROUP BY pp.person_id) enrollment USING (indicator_id)
         GROUP BY q28indicator) ind28 ON (ind27.indicator_id = ind28.indicator_id)
        INNER JOIN
        (SELECT indicator_id,
           q29indicator,
           SUM(IF((gender = 'F'
                   OR gender = 'M')
                  AND age BETWEEN 0 AND 100, 1, 0)) AS q29Total
         FROM
           (SELECT 1 AS indicator_id,
                   'No. active on ART Care assessed for malnutrition at their visit in the quarter' AS q29indicator ) Indicators
           LEFT JOIN
           (SELECT DISTINCT 1 AS indicator_id,
              pp.gender,
              pp.person_id,
                            MAX(e.encounter_datetime) en_date,
                            TIMESTAMPDIFF(YEAR, pp.birthdate, CURRENT_DATE()) AS age
            FROM person pp
              INNER JOIN patient p ON (pp.person_id = p.patient_id
                                       AND p.voided = 0)
              INNER JOIN encounter e ON (e.patient_id = p.patient_id
                                         AND form_id = 12
                                         AND QUARTER(e.encounter_datetime) = 1
                                         AND YEAR(e.encounter_datetime) = start_year
                                         AND e.voided = 0
                                         AND e.patient_id IN
                                             (SELECT DISTINCT patient_id
                                              FROM encounter ei
                                                JOIN obs oi ON (ei.encounter_id = oi.encounter_id
                                                                AND oi.concept_id = 90315
                                                                AND oi.value_coded > 0
                                                                AND oi.voided = 0
                                                                AND QUARTER(ei.encounter_datetime) = start_quarter
                                                                AND YEAR(ei.encounter_datetime) = start_year)))
              INNER JOIN obs o ON (e.encounter_id = o.encounter_id
                                   AND o.voided = 0
                                   AND o.concept_id IN (90236,5090,99030,99069) AND (o.value_numeric > 0 OR o.value_coded > 0))
            GROUP BY pp.person_id) enrollment USING (indicator_id)
         GROUP BY q29indicator) ind29 ON (ind28.indicator_id = ind29.indicator_id)
        INNER JOIN
        (SELECT indicator_id,
           q30indicator,
           SUM(IF((gender = 'F'
                   OR gender = 'M')
                  AND age BETWEEN 0 AND 100, 1, 0)) AS q30Total
         FROM
           (SELECT 1 AS indicator_id,
                   'No. active on ART who are malnuourished at their last visit in the quarter' AS q30indicator ) Indicators
           LEFT JOIN
           (SELECT DISTINCT 1 AS indicator_id,
              pp.gender,
              pp.person_id,
                            MAX(e.encounter_datetime) en_date,
                            TIMESTAMPDIFF(YEAR, pp.birthdate, CURRENT_DATE()) AS age
            FROM person pp
              INNER JOIN patient p ON (pp.person_id = p.patient_id
                                       AND p.voided = 0)
              INNER JOIN encounter e ON (e.patient_id = p.patient_id
                                         AND form_id = 12
                                         AND QUARTER(e.encounter_datetime) = 1
                                         AND YEAR(e.encounter_datetime) = start_year
                                         AND e.voided = 0
                                         AND e.patient_id IN
                                             (SELECT DISTINCT patient_id
                                              FROM encounter ei
                                                JOIN obs oi ON (ei.encounter_id = oi.encounter_id
                                                                AND form_id = 12
                                                                AND oi.concept_id = 90315
                                                                AND oi.value_coded > 0
                                                                AND oi.voided = 0
                                                                AND QUARTER(ei.encounter_datetime) = start_quarter
                                                                AND YEAR(ei.encounter_datetime) = start_year)))
              INNER JOIN obs o ON (e.encounter_id = o.encounter_id
                                   AND o.voided = 0
                                   AND o.concept_id = 68
                                   AND o.value_coded IN (99271,
                                                         99272,
                                                         99273))
            GROUP BY pp.person_id) enrollment USING (indicator_id)
         GROUP BY q30indicator) ind30 ON (ind29.indicator_id = ind30.indicator_id);

    END$$
  DELIMITER ;

  DELIMITER $$
  CREATE DEFINER=`openmrs`@`localhost` PROCEDURE `hmis106a1aYouth`(IN start_year INT, IN start_quarter INT)
  BEGIN

      SELECT *
      FROM
        (SELECT
           indicator_id,
           q1indicator,
           SUM(IF(gender = 'M' AND age BETWEEN 9 AND 14, 1, 0))  AS q1MTeens,
           SUM(IF(gender = 'F' AND age BETWEEN 9 AND 14, 1, 0))  AS q1FTeens,
           SUM(IF(gender = 'M' AND age BETWEEN 15 AND 19, 1, 0)) AS q1MSeniors,
           SUM(IF(gender = 'F' AND age BETWEEN 15 AND 19, 1, 0)) AS q1FSeniors,
           SUM(IF((gender = 'F' OR gender = 'M') AND (age BETWEEN 9 AND 19), 1, 0))               AS q1Total
         FROM
           (SELECT
              1                                                                                                          AS indicator_id,
              'Cummulative No. of clients ever enrolled in HIV care at this facility at the end of the previous quarter' AS q1indicator
           ) Indicators
           LEFT JOIN
           (SELECT DISTINCT 1 AS indicator_id,
              pp.gender,
              pp.person_id,
                            TIMESTAMPDIFF(YEAR, pp.birthdate, (MAKEDATE(start_year,1) + INTERVAL start_quarter QUARTER - INTERVAL 1 DAY)) AS age
            FROM person pp
              INNER JOIN encounter e ON (e.patient_id = pp.person_id
                                         AND e.encounter_type = (select encounter_type_id from encounter_type where locate('art',name) > 0 and locate('summary',name) > 0)
                                         AND e.voided = 0
                                         AND e.encounter_datetime <= MAKEDATE(start_year, 1) + INTERVAL start_quarter - 1 QUARTER - INTERVAL 1 DAY)) Enrollment USING (indicator_id)
         GROUP BY q1indicator) ind1
        LEFT JOIN
        (SELECT
           indicator_id,
           q2indicator,
           SUM(IF(gender = 'M' AND age BETWEEN 9 AND 14, 1, 0))                 AS q2MTeens,
           SUM(IF(gender = 'F' AND age BETWEEN 9 AND 14, 1, 0))                 AS q2FTeens,
           SUM(IF(gender = 'M' AND age BETWEEN 15 AND 19, 1, 0))                AS q2MSeniors,
           SUM(IF(gender = 'F' AND age BETWEEN 15 AND 19, 1, 0))                AS q2FSeniors,
           SUM(IF((gender = 'F' OR gender = 'M') AND (age BETWEEN 9 AND 19), 1, 0)) AS Total
         FROM
           (SELECT
              1                                                                                 AS indicator_id,
              'Number of new patients enrolled in HIV care at this  facility during the period' AS q2indicator
           ) Indicators
           LEFT JOIN (SELECT DISTINCT 1 AS indicator_id,
              pp.gender,
              pp.person_id,
                            TIMESTAMPDIFF(YEAR, pp.birthdate, (MAKEDATE(start_year,1) + INTERVAL start_quarter QUARTER - INTERVAL 1 DAY)) AS age
            FROM person pp
              INNER JOIN encounter e ON (e.patient_id = pp.person_id
                                         AND e.encounter_type = (select encounter_type_id from encounter_type where locate('art',name) > 0 and locate('summary',name) > 0)
                                         AND e.voided = 0
                                         AND e.encounter_datetime BETWEEN MAKEDATE(start_year, 1) + INTERVAL start_quarter - 1 QUARTER AND MAKEDATE(start_year, 1) + INTERVAL start_quarter QUARTER - INTERVAL 1 DAY)) Enrollment USING (indicator_id)
         GROUP BY q2indicator) ind2 ON (ind1.indicator_id = ind2.indicator_id)
        LEFT JOIN
        (SELECT
           indicator_id,
           q3indicator,
           SUM(IF(gender = 'F' AND age BETWEEN 9 AND 14, 1, 0))  AS q3FTeens,
           SUM(IF(gender = 'F' AND age BETWEEN 15 AND 19, 1, 0)) AS q3FSeniors,
           SUM(IF(gender = 'F' AND age BETWEEN 9 AND 19, 1, 0))  AS q3Total
         FROM
           (SELECT
              1                                                                                                                 AS indicator_id,
              'Number of pregnant and lactating women enrolled into care during the reporting quarter. (subset of row 2 above)' AS q3indicator
           ) Indicators
           LEFT JOIN (SELECT DISTINCT 1 AS indicator_id,
              pp.gender,
              pp.person_id,
                            TIMESTAMPDIFF(YEAR, pp.birthdate, (MAKEDATE(start_year,1) + INTERVAL start_quarter QUARTER - INTERVAL 1 DAY)) AS age
            FROM person pp
              INNER JOIN encounter e ON (e.patient_id = pp.person_id
  									   AND e.encounter_type = (select encounter_type_id from encounter_type where locate('art',name) > 0 and locate('summary',name) > 0)
                                         AND QUARTER(e.encounter_datetime) = start_quarter
                                         AND YEAR(e.encounter_datetime) = start_year)
              INNER JOIN obs o ON (e.encounter_id = o.encounter_id
                                   AND o.concept_id = 90200
                                   AND o.value_coded = 90012)) Enrollment USING (indicator_id)
         GROUP BY q3indicator) ind3 ON (ind2.indicator_id = ind3.indicator_id)
        LEFT JOIN
        (SELECT
           indicator_id,
           q4indicator,
           SUM(IF((gender = 'F' OR gender = 'M')
                  AND age BETWEEN 0 AND 100, 1, 0)) AS q4Total
         FROM
           (SELECT
              1                                                                                                   AS indicator_id,
              'Number of clients started on INH Prophylaxis during the reporting quarter (Subset of row 2 above)' AS q4indicator
           ) Indicators
           LEFT JOIN (SELECT DISTINCT 1 AS indicator_id,
              p.gender,
              p.person_id,
                            TIMESTAMPDIFF(YEAR, p.birthdate, (MAKEDATE(start_year,1) + INTERVAL start_quarter QUARTER - INTERVAL 1 DAY)) AS age,
                            YEAR(o.obs_datetime) AS 'Year',
                            QUARTER(o.obs_datetime) AS 'quarter'
            FROM person p
              INNER JOIN obs o ON(p.person_id = o.person_id
                                  AND o.concept_id = 99604
                                  AND o.voided =0
                                  AND p.voided = 0
                                  AND o.value_numeric > 0) group by p.person_id having count(*) = 1) Enrollment USING (indicator_id)
         GROUP BY q4indicator) ind4 ON (ind3.indicator_id = ind4.indicator_id)
        LEFT JOIN
        (SELECT
           indicator_id,
           q5indicator,
           SUM(IF(gender = 'M' AND age BETWEEN 9 AND 14, 1, 0))  AS q5MTeens,
           SUM(IF(gender = 'F' AND age BETWEEN 9 AND 14, 1, 0))  AS q5FTeens,
           SUM(IF(gender = 'M' AND age BETWEEN 15 AND 19, 1, 0)) AS q5MSeniors,
           SUM(IF(gender = 'F' AND age BETWEEN 15 AND 19, 1, 0)) AS q5FSeniors,
           SUM(IF((gender = 'F' OR gender = 'M') AND (age BETWEEN 9 AND 19), 1, 0))               AS q5Total
         FROM
           (SELECT
              1                                                                                                                            AS indicator_id,
              'Cumulative number of clients ever enrolled in HIV care at this facility at the end of the previous quarter (row 1 + row 2)' AS q5indicator
           ) Indicators
           LEFT JOIN (SELECT DISTINCT 1 AS indicator_id,
              pp.gender,
              pp.person_id,
                            TIMESTAMPDIFF(YEAR, pp.birthdate, (MAKEDATE(start_year,1) + INTERVAL start_quarter QUARTER - INTERVAL 1 DAY)) AS age
            FROM person pp
              INNER JOIN encounter e ON (e.patient_id = pp.person_id
                                         AND e.encounter_type = (select encounter_type_id from encounter_type where locate('art',name) > 0 and locate('summary',name) > 0)
                                         AND e.voided = 0
                                         AND e.encounter_datetime <= MAKEDATE(start_year, 1) + INTERVAL start_quarter QUARTER - INTERVAL 1 DAY)) Enrollment USING (indicator_id)
         GROUP BY q5indicator) ind5 ON (ind4.indicator_id = ind5.indicator_id)
        LEFT JOIN
        (SELECT
           indicator_id,
           q6indicator,
           SUM(IF((gender = 'F' OR gender = 'M')
                  AND age BETWEEN 9 AND 19, 1, 0)) AS q6Total
         FROM
           (SELECT
              1                                                                                                     AS indicator_id,
              'No. of persons already enrolled in HIV care who transfered from another facility during the quarter' AS q6indicator
           ) Indicators
           LEFT JOIN (SELECT DISTINCT 1 AS indicator_id,
              pp.gender,
              pp.person_id,
                            TIMESTAMPDIFF(YEAR, pp.birthdate, (MAKEDATE(start_year,1) + INTERVAL start_quarter QUARTER - INTERVAL 1 DAY)) AS age
            FROM person pp
              INNER JOIN encounter e ON (e.patient_id = pp.person_id
                                         AND e.encounter_type = (select encounter_type_id from encounter_type where locate('art',name) > 0 and locate('summary',name) > 0)
                                         AND QUARTER(e.encounter_datetime) = start_quarter
                                         AND YEAR(e.encounter_datetime) = start_year)
              INNER JOIN obs o ON (e.encounter_id = o.encounter_id
                                   AND o.concept_id = 99110
                                   AND o.value_coded = 90003)) Enrollment USING (indicator_id)
         GROUP BY q6indicator) ind6 ON (ind5.indicator_id = ind6.indicator_id)
        LEFT JOIN
        (SELECT
           indicator_id,
           q7indicator,
           SUM(IF(age BETWEEN 9 AND 14, 1, 0))  AS q71,
           SUM(IF(age BETWEEN 15 AND 19, 1, 0)) AS q72,
           SUM(IF(age BETWEEN 9 AND 19, 1, 0))  AS q7Total
         FROM
           (SELECT
              1                                                         AS indicator_id,
              'Number of active clients on pre-ART Care in the quarter' AS q7indicator
           ) Indicators
           LEFT JOIN (SELECT DISTINCT 1 AS indicator_id,
              pp.gender,
              pp.person_id,
                            MAX(e.encounter_datetime) en_date,
                            TIMESTAMPDIFF(YEAR, pp.birthdate, CURRENT_DATE()) AS age
            FROM person pp
              INNER JOIN encounter e ON (e.patient_id = pp.person_id
                                         AND QUARTER(e.encounter_datetime) = start_quarter
                                         AND YEAR(e.encounter_datetime) = start_year
                                         AND e.voided = 0
                                         AND e.patient_id NOT IN
                                             (SELECT DISTINCT oi.person_id
                                              FROM obs oi
                                              WHERE oi.concept_id = 90315
                                                    AND oi.value_coded > 0
                                                    AND oi.voided = 0
                                                    AND QUARTER(oi.obs_datetime) = start_quarter
                                                    AND YEAR(oi.obs_datetime) = start_year))
              INNER JOIN obs o ON (e.encounter_id = o.encounter_id
                                   AND o.voided = 0)
            GROUP BY pp.person_id) enrollment USING (indicator_id)
         GROUP BY q7indicator) ind7 ON (ind6.indicator_id = ind7.indicator_id)
        LEFT JOIN
        (SELECT
           indicator_id,
           q8indicator,
           SUM(IF(age BETWEEN 9 AND 14, 1, 0))  AS q81,
           SUM(IF(age BETWEEN 15 AND 19, 1, 0)) AS q82,
           SUM(IF(age BETWEEN 9 AND 19, 1, 0))  AS q8Total
         FROM
           (SELECT
              1                                                                                 AS indicator_id,
              'Number active on pre-ART who received CPT/Daspone at last  visit in the quarter' AS q8indicator
           ) Indicators
           LEFT JOIN (SELECT DISTINCT 1 AS indicator_id,
              pp.gender,
              pp.person_id,
                            MAX(e.encounter_datetime) en_date,
                            TIMESTAMPDIFF(YEAR, pp.birthdate, CURRENT_DATE()) AS age
            FROM person pp
              INNER JOIN encounter e ON (e.patient_id = pp.person_id
                                         AND e.encounter_type = (select encounter_type_id from encounter_type where locate('art',name) > 0 and locate('card',name) > 0 and locate('encounter',name) > 0 and locate('education',name) = 0)
                                         AND QUARTER(e.encounter_datetime) = start_quarter
                                         AND YEAR(e.encounter_datetime) = start_year
                                         AND e.voided = 0
                                         AND e.patient_id NOT IN
                                             (SELECT DISTINCT oi.person_id
                                              FROM obs oi
                                              WHERE oi.concept_id = 90315
                                                    AND oi.value_coded > 0
                                                    AND oi.voided = 0
                                                    AND QUARTER(oi.obs_datetime) = start_quarter
                                                    AND YEAR(oi.obs_datetime) = start_year))
              INNER JOIN obs o ON (e.encounter_id = o.encounter_id
                                   AND o.voided = 0
                                   AND o.concept_id = 99037
                                   AND o.value_numeric > 0)
            GROUP BY pp.person_id) enrollment USING (indicator_id)
         GROUP BY q8indicator) ind8 ON (ind7.indicator_id = ind8.indicator_id)
        LEFT JOIN
        (SELECT
           indicator_id,
           q9indicator,
           SUM(IF((gender = 'F' OR gender = 'M')
                  AND age BETWEEN 9 AND 19, 1, 0)) AS q9Total
         FROM
           (SELECT
              1                                                                         AS indicator_id,
              'No. active on pre-ART Care assessed for TB at last visit in the quarter' AS q9indicator
           ) Indicators
           LEFT JOIN (SELECT DISTINCT 1 AS indicator_id,
              pp.gender,
              pp.person_id,
                            MAX(e.encounter_datetime) en_date,
                            TIMESTAMPDIFF(YEAR, pp.birthdate, CURRENT_DATE()) AS age
            FROM person pp
              INNER JOIN encounter e ON (e.patient_id = pp.person_id
                                         AND QUARTER(e.encounter_datetime) = start_quarter
                                         AND YEAR(e.encounter_datetime) = start_year
                                         AND e.voided = 0
                                         AND e.patient_id NOT IN
                                             (SELECT DISTINCT person_id
                                              FROM obs oi
                                              WHERE oi.concept_id = 90315
                                                    AND oi.value_coded > 0
                                                    AND oi.voided = 0
                                                    AND QUARTER(oi.obs_datetime) = start_quarter
                                                    AND YEAR(oi.obs_datetime) = start_year))
              INNER JOIN obs o ON (e.encounter_id = o.encounter_id
                                   AND o.voided = 0
                                   AND o.concept_id = 90216
                                   AND o.value_coded > 0)
            GROUP BY pp.person_id) enrollment USING (indicator_id)
         GROUP BY q9indicator) ind9 ON (ind8.indicator_id = ind9.indicator_id)
        LEFT JOIN
        (SELECT
           indicator_id,
           q10indicator,
           SUM(IF((gender = 'F' OR gender = 'M')
                  AND age BETWEEN 9 AND 19, 1, 0)) AS q10Total
         FROM
           (SELECT
              1                                                             AS indicator_id,
              'No. active on pre-ART Care diagnosed with TB in the quarter' AS q10indicator
           ) Indicators
           LEFT JOIN (SELECT DISTINCT 1 AS indicator_id,
              pp.gender,
              pp.person_id,
                            MAX(e.encounter_datetime) en_date,
                            TIMESTAMPDIFF(YEAR, pp.birthdate, CURRENT_DATE()) AS age
            FROM person pp
              INNER JOIN patient p ON (pp.person_id = p.patient_id
                                       AND p.voided = 0)
              INNER JOIN encounter e ON (e.patient_id = p.patient_id
                                         AND QUARTER(e.encounter_datetime) = start_quarter
                                         AND YEAR(e.encounter_datetime) = start_year
                                         AND e.voided = 0
                                         AND e.patient_id NOT IN
                                             (SELECT DISTINCT oi.person_id
                                              FROM obs oi WHERE oi.concept_id = 90315
                                                                AND oi.value_coded > 0
                                                                AND oi.voided = 0
                                                                AND QUARTER(oi.obs_datetime) = start_quarter
                                                                AND YEAR(oi.obs_datetime) = start_year))
              INNER JOIN obs o ON (e.encounter_id = o.encounter_id
                                   AND o.voided = 0
                                   AND o.concept_id = 90216
                                   AND o.value_coded = 90078)
            GROUP BY pp.person_id) enrollment USING (indicator_id)
         GROUP BY q10indicator) ind10 ON (ind9.indicator_id = ind10.indicator_id)
        LEFT JOIN
        (SELECT
           indicator_id,
           q11indicator,
           SUM(IF((gender = 'F' OR gender = 'M')
                  AND age BETWEEN 9 AND 19, 1, 0)) AS q11Total
         FROM
           (SELECT
              1                                                                            AS indicator_id,
              'No. active on pre-ART Care started on anti-TB treatment during the quarter' AS q11indicator
           ) Indicators
           LEFT JOIN (SELECT DISTINCT 1 AS indicator_id,
              pp.gender,
              pp.person_id,
                            MAX(e.encounter_datetime) en_date,
                            TIMESTAMPDIFF(YEAR, pp.birthdate, CURRENT_DATE()) AS age
            FROM person pp
              INNER JOIN patient p ON (pp.person_id = p.patient_id
                                       AND p.voided = 0)
              INNER JOIN encounter e ON (e.patient_id = p.patient_id
                                         AND form_id = 12
                                         AND QUARTER(e.encounter_datetime) = 1
                                         AND YEAR(e.encounter_datetime) = start_year
                                         AND e.voided = 0
                                         AND e.patient_id NOT IN
                                             (SELECT DISTINCT oi.person_id
                                              FROM obs oi WHERE oi.concept_id = 90315
                                                                AND oi.value_coded > 0
                                                                AND oi.voided = 0
                                                                AND QUARTER(oi.obs_datetime) = start_quarter
                                                                AND YEAR(oi.obs_datetime) = start_year))
              INNER JOIN obs o ON (e.encounter_id = o.encounter_id
                                   AND o.voided = 0
                                   AND o.concept_id = 90216
                                   AND o.value_coded = 90071)
            GROUP BY pp.person_id) enrollment USING (indicator_id)
         GROUP BY q11indicator) ind11 ON (ind10.indicator_id = ind11.indicator_id)
        LEFT JOIN
        (SELECT
           indicator_id,
           q12indicator,
           SUM(IF((gender = 'F' OR gender = 'M')
                  AND age BETWEEN 9 AND 19, 1, 0)) AS q12Total
         FROM
           (SELECT
              1                                                                                    AS indicator_id,
              'No. active on pre-ART Care assessed for Malnutrition at their visit in the quarter' AS q12indicator
           ) Indicators
           LEFT JOIN (SELECT DISTINCT 1 AS indicator_id,
              pp.gender,
              pp.person_id,
                            MAX(e.encounter_datetime) en_date,
                            TIMESTAMPDIFF(YEAR, pp.birthdate, CURRENT_DATE()) AS age
            FROM person pp
              INNER JOIN encounter e ON (e.patient_id = pp.person_id
                                         AND QUARTER(e.encounter_datetime) = start_quarter
                                         AND YEAR(e.encounter_datetime) = start_year
                                         AND e.voided = 0
                                         AND e.patient_id NOT IN
                                             (SELECT DISTINCT oi.person_id
                                              FROM obs oi WHERE oi.concept_id = 90315
                                                                AND oi.value_coded > 0
                                                                AND oi.voided = 0
                                                                AND QUARTER(oi.obs_datetime) = start_quarter
                                                                AND YEAR(oi.obs_datetime) = start_year))
              INNER JOIN obs o ON (e.encounter_id = o.encounter_id
                                   AND o.voided = 0
                                   AND o.concept_id IN (90236,5090,99030,99069) AND (o.value_numeric > 0 OR o.value_coded > 0))
            GROUP BY pp.person_id) enrollment USING (indicator_id)
         GROUP BY q12indicator) ind12 ON (ind11.indicator_id = ind12.indicator_id)
        INNER JOIN
        (SELECT
           indicator_id,
           q13indicator,
           SUM(IF((gender = 'F' OR gender = 'M')
                  AND age BETWEEN 9 AND 19, 1, 0)) AS q13Total
         FROM
           (SELECT
              1                                                                                    AS indicator_id,
              'No. active on pre-ART Care who are malnourished at their last visit in the quarter' AS q13indicator
           ) Indicators
           LEFT JOIN (SELECT DISTINCT 1 AS indicator_id,
              pp.gender,
              pp.person_id,
                            MAX(e.encounter_datetime) en_date,
                            TIMESTAMPDIFF(YEAR, pp.birthdate, CURRENT_DATE()) AS age
            FROM person pp
              INNER JOIN patient p ON (pp.person_id = p.patient_id
                                       AND p.voided = 0)
              INNER JOIN encounter e ON (e.patient_id = p.patient_id
                                         AND QUARTER(e.encounter_datetime) = start_year
                                         AND YEAR(e.encounter_datetime) = start_year
                                         AND e.voided = 0
                                         AND e.patient_id NOT IN
                                             (SELECT DISTINCT oi.person_id
                                              FROM  obs oi WHERE oi.concept_id = 90315
                                                                 AND oi.value_coded > 0
                                                                 AND oi.voided = 0
                                                                 AND QUARTER(oi.obs_datetime) = start_quarter
                                                                 AND YEAR(oi.obs_datetime) = start_year))
              INNER JOIN obs o ON (e.encounter_id = o.encounter_id
                                   AND o.voided = 0
                                   AND ((o.concept_id = 68 AND o.value_coded IN (99271,99272,99273)) OR (o.concept_id = 99030 AND o.value_coded IN (99028,99029)) OR (o.concept_id = 460 AND o.value_coded = 90003)))
            GROUP BY pp.person_id) enrollment USING (indicator_id)
         GROUP BY q13indicator) ind13 ON (ind12.indicator_id = ind13.indicator_id)
        INNER JOIN
        (SELECT
           indicator_id,
           q14indicator,
           SUM(IF((gender = 'F' OR gender = 'M')
                  AND age BETWEEN 9 AND 19, 1, 0)) AS q14Total
         FROM
           (SELECT
              1                                                                                                AS indicator_id,
              'No. active on pre-ART Care eligible and ready but not started on ART by the end of the quarter' AS q14indicator
           ) Indicators
           LEFT JOIN (SELECT DISTINCT 1 AS indicator_id,
              pp.gender,
              pp.person_id,
                            TIMESTAMPDIFF(YEAR, pp.birthdate, CURRENT_DATE()) AS age
            FROM person pp
              INNER JOIN patient p ON (pp.person_id = p.patient_id
                                       AND p.voided = 0)
              INNER JOIN encounter e ON (e.patient_id = p.patient_id
                                         AND form_id = 12
                                         AND e.voided = 0
                                         AND e.patient_id NOT IN
                                             (SELECT DISTINCT oi.person_id FROM obs oi WHERE oi.concept_id = 90315
                                                                                             AND oi.value_coded > 0
                                                                                             AND oi.voided = 0))
              INNER JOIN obs o ON (e.encounter_id = o.encounter_id
                                   AND o.voided = 0
                                   AND YEAR(o.value_datetime) = start_year
                                   AND QUARTER(o.value_datetime) = start_quarter AND o.concept_id = 90299)
            GROUP BY pp.person_id) enrollment USING (indicator_id)
         GROUP BY q14indicator) ind14 ON (ind13.indicator_id = ind14.indicator_id)
        INNER JOIN
        (SELECT
           indicator_id,
           q15indicator,
           SUM(IF(gender = 'M' AND age BETWEEN 9 AND 14, 1, 0))  AS q15MTeens,
           SUM(IF(gender = 'F' AND age BETWEEN 9 AND 14, 1, 0))  AS q15FTeens,
           SUM(IF(gender = 'M' AND age BETWEEN 15 AND 19, 1, 0)) AS q15MSeniors,
           SUM(IF(gender = 'F' AND age BETWEEN 15 AND 19, 1, 0)) AS q15FSeniors,
           SUM(IF((gender = 'F' OR gender = 'M')
                  AND age BETWEEN 9 AND 19, 1, 0))               AS q15Total
         FROM
           (SELECT
              1                                                                                                     AS indicator_id,
              'Cumulative No. of clients ever enrolled on ART at this facility at the end of the previous  quarter' AS q15indicator
           ) Indicators
           LEFT JOIN (SELECT DISTINCT 1 AS indicator_id,
              pp.gender,
              pp.person_id,
                            TIMESTAMPDIFF(YEAR, pp.birthdate, CURRENT_DATE()) AS age
            FROM person pp
              INNER JOIN encounter e ON (e.patient_id = pp.person_id
                                         AND e.voided = 0
                                         AND e.encounter_datetime <= MAKEDATE(start_year, 1) + INTERVAL start_quarter - 1 QUARTER - INTERVAL 1 DAY)
              INNER JOIN obs o ON (e.encounter_id = o.encounter_id
                                   AND o.voided = 0
                                   AND o.concept_id  IN (99161,99160))
            GROUP BY pp.person_id) enrollment USING (indicator_id)
         GROUP BY q15indicator) ind15 ON (ind14.indicator_id = ind15.indicator_id)
        INNER JOIN
        (SELECT
           indicator_id,
           q16indicator,
           SUM(IF(gender = 'M' AND age BETWEEN 9 AND 14, 1, 0))  AS q16MTeens,
           SUM(IF(gender = 'F' AND age BETWEEN 9 AND 14, 1, 0))  AS q16FTeens,
           SUM(IF(gender = 'M' AND age BETWEEN 15 AND 19, 1, 0)) AS q16MSeniors,
           SUM(IF(gender = 'F' AND age BETWEEN 15 AND 19, 1, 0)) AS q16FSeniors,
           SUM(IF((gender = 'F' OR gender = 'M')
                  AND age BETWEEN 9 AND 19, 1, 0))               AS q16Total
         FROM
           (SELECT
              1                                                                       AS indicator_id,
              'No. of new clients started on ART at this facility during the quarter' AS q16indicator
           ) Indicators
           LEFT JOIN (SELECT DISTINCT 1 AS indicator_id,
              pp.gender,
              pp.person_id,
                            TIMESTAMPDIFF(YEAR, pp.birthdate, CURRENT_DATE()) AS age
            FROM person pp
              INNER JOIN encounter e ON (e.patient_id = pp.person_id
                                         AND e.voided = 0
                                         AND QUARTER(e.encounter_datetime) = start_quarter
                                         AND YEAR(e.encounter_datetime) = start_year)
              INNER JOIN obs o ON (e.encounter_id = o.encounter_id
                                   AND o.voided = 0
                                   AND o.concept_id IN (99161,99160))
            GROUP BY pp.person_id) enrollment USING (indicator_id)
         GROUP BY q16indicator) ind16 ON (ind15.indicator_id = ind16.indicator_id)
        INNER JOIN
        (SELECT
           indicator_id,
           q17indicator,
           SUM(IF((gender = 'F' OR gender = 'M')
                  AND age BETWEEN 9 AND 19, 1, 0)) AS q17Total
         FROM
           (SELECT
              1                                                                                          AS indicator_id,
              'No. Of new clients started on ART at this facility during the quarter based on CD4 count' AS q17indicator
           ) Indicators
           LEFT JOIN (SELECT DISTINCT 1 AS indicator_id,
              pp.gender,
              pp.person_id,
                            TIMESTAMPDIFF(YEAR, pp.birthdate, CURRENT_DATE()) AS age
            FROM person pp
              INNER JOIN encounter e ON (e.patient_id = pp.person_id
                                         AND e.voided = 0
                                         AND QUARTER(e.encounter_datetime) = start_quarter
                                         AND YEAR(e.encounter_datetime) = start_year)
                                        AND e.patient_id IN (SELECT DISTINCT oi.person_id FROM obs oi WHERE oi.concept_id = 99082 AND oi.value_numeric > 0 AND oi.voided = 0)
              INNER JOIN obs o ON (e.encounter_id = o.encounter_id AND o.voided = 0 AND o.concept_id = 99161)
            GROUP BY pp.person_id) enrollment USING (indicator_id)
         GROUP BY q17indicator) ind17 ON (ind16.indicator_id = ind17.indicator_id)
        INNER JOIN
        (SELECT
           indicator_id,
           q18indicator,
           SUM(IF(gender = 'F' AND age BETWEEN 9 AND 14, 1, 0))  AS q18FTeens,
           SUM(IF(gender = 'F' AND age BETWEEN 15 AND 19, 1, 0)) AS q18FSeniors,
           SUM(IF((gender = 'F' OR gender = 'M')
                  AND age BETWEEN 9 AND 19, 1, 0))               AS q18Total
         FROM
           (SELECT
              1                                                                                                   AS indicator_id,
              'No. of pregnant women started on ART at this facility during the quarter (Subset of row 16 above)' AS q18indicator
           ) Indicators
           LEFT JOIN (SELECT DISTINCT 1 AS indicator_id,
              pp.gender,
              pp.person_id,
                            TIMESTAMPDIFF(YEAR, pp.birthdate, CURRENT_DATE()) AS age
            FROM person pp
              INNER JOIN encounter e ON (e.patient_id = pp.person_id
                                         AND e.voided = 0
                                         AND QUARTER(e.encounter_datetime) = start_quarter
                                         AND YEAR(e.encounter_datetime) = start_year)
                                        AND e.patient_id IN
                                            (SELECT DISTINCT ei.patient_id
                                             FROM encounter ei
                                               INNER JOIN obs oi ON (oi.encounter_id = ei.encounter_id
                                                                     AND ((oi.concept_id = 90012 AND oi.value_coded = 90003))
                                                                     AND oi.voided = 0))
              INNER JOIN obs o ON (e.encounter_id = o.encounter_id
                                   AND o.voided = 0
                                   AND o.concept_id IN(99161,99160))
            GROUP BY pp.person_id) enrollment USING (indicator_id)
         GROUP BY q18indicator) ind18 ON (ind17.indicator_id = ind18.indicator_id)
        INNER JOIN
        (SELECT
           indicator_id,
           q19indicator,
           SUM(IF(gender = 'M' AND age BETWEEN 9 AND 14, 1, 0))  AS q19MTeens,
           SUM(IF(gender = 'F' AND age BETWEEN 9 AND 14, 1, 0))  AS q19FTeens,
           SUM(IF(gender = 'M' AND age BETWEEN 15 AND 19, 1, 0)) AS q19MSeniors,
           SUM(IF(gender = 'F' AND age BETWEEN 15 AND 19, 1, 0)) AS q19FSeniors,
           SUM(IF((gender = 'F' OR gender = 'M')
                  AND age BETWEEN 9 AND 19, 1, 0))               AS q19Total
         FROM
           (SELECT
              1                                                                     AS indicator_id,
              'Cumulative No. of individuals ever started on ART (row 15 + row 16)' AS q19indicator
           ) Indicators
           LEFT JOIN (SELECT DISTINCT 1 AS indicator_id,
              pp.gender,
              pp.person_id,
                            TIMESTAMPDIFF(YEAR, pp.birthdate, CURRENT_DATE()) AS age
            FROM person pp
              INNER JOIN encounter e ON (e.patient_id = pp.person_id
                                         AND e.voided = 0
                                         AND e.encounter_datetime <= MAKEDATE(start_year, 1) + INTERVAL start_quarter QUARTER - INTERVAL 1 DAY)
              INNER JOIN obs o ON (e.encounter_id = o.encounter_id
                                   AND o.voided = 0
                                   AND o.concept_id IN(99161,99160))
            GROUP BY pp.person_id) enrollment USING (indicator_id)
         GROUP BY q19indicator) ind19 ON (ind18.indicator_id = ind19.indicator_id)
        INNER JOIN
        (SELECT
           indicator_id,
           q20indicator,
           SUM(IF(gender = 'M' AND age BETWEEN 9 AND 14, 1, 0))  AS q20MTeens,
           SUM(IF(gender = 'F' AND age BETWEEN 9 AND 14, 1, 0))  AS q20FTeens,
           SUM(IF(gender = 'M' AND age BETWEEN 15 AND 19, 1, 0)) AS q20MSeniors,
           SUM(IF(gender = 'F' AND age BETWEEN 15 AND 19, 1, 0)) AS q20FSeniors,
           SUM(IF((gender = 'F' OR gender = 'M')
                  AND age BETWEEN 9 AND 19, 1, 0))               AS q20Total
         FROM
           (SELECT
              1                                           AS indicator_id,
              'No. active on ART on 1st line ARV regimen' AS q20indicator
           ) Indicators
           LEFT JOIN (SELECT DISTINCT 1 AS indicator_id,
              pp.gender,
              pp.person_id,
                            TIMESTAMPDIFF(YEAR, pp.birthdate, CURRENT_DATE()) AS age
            FROM person pp
              INNER JOIN encounter e ON (e.patient_id = pp.person_id
                                         AND e.voided = 0)
              INNER JOIN obs o ON (e.encounter_id = o.encounter_id
                                   AND o.voided = 0
                                   AND YEAR(e.encounter_datetime) = start_year
                                   AND QUARTER(e.encounter_datetime) = start_quarter
                                   AND o.concept_id = 90315
                                   AND o.value_coded IN (99015,
                99016,
                99005,
                99006,
                99039,
                99040,
                99041,
                163017,
                99042,
                99884,
                99885,
                                                         99143))
            GROUP BY pp.person_id) enrollment USING (indicator_id)
         GROUP BY q20indicator) ind20 ON (ind19.indicator_id = ind20.indicator_id)
        INNER JOIN
        (SELECT
           indicator_id,
           q21indicator,
           SUM(IF(gender = 'M' AND age BETWEEN 9 AND 14, 1, 0))  AS q21MTeens,
           SUM(IF(gender = 'F' AND age BETWEEN 9 AND 14, 1, 0))  AS q21FTeens,
           SUM(IF(gender = 'M' AND age BETWEEN 15 AND 19, 1, 0)) AS q21MSeniors,
           SUM(IF(gender = 'F' AND age BETWEEN 15 AND 19, 1, 0)) AS q21FSeniors,
           SUM(IF((gender = 'F' OR gender = 'M')
                  AND age BETWEEN 9 AND 19, 1, 0))               AS q21Total
         FROM
           (SELECT
              1                                           AS indicator_id,
              'No. active on ART on 2nd line ARV regimen' AS q21indicator
           ) Indicators
           LEFT JOIN (SELECT DISTINCT 1 AS indicator_id,
              pp.gender,
              pp.person_id,
                            TIMESTAMPDIFF(YEAR, pp.birthdate, CURRENT_DATE()) AS age
            FROM person pp
              INNER JOIN encounter e ON (e.patient_id = pp.person_id
                                         AND e.voided = 0)
              INNER JOIN obs o ON (e.encounter_id = o.encounter_id
                                   AND o.voided = 0
                                   AND YEAR(e.encounter_datetime) = start_year
                                   AND QUARTER(e.encounter_datetime) = start_quarter
                                   AND o.concept_id = 90315
                                   AND o.value_coded IN (99007,
                99008,
                99044,
                99043,
                99282,
                99283,
                99046,
                99017,
                99018,
                99019,
                99045,
                                                         99284,
                                                         99285,
                                                         99286,
                                                         99046,
                                                         99887,
                                                         99888,
                                                         99144))
            GROUP BY pp.person_id) enrollment USING (indicator_id)
         GROUP BY q21indicator) ind21 ON (ind20.indicator_id = ind21.indicator_id)
        INNER JOIN
        (SELECT
           indicator_id,
           q22indicator,
           SUM(IF(gender = 'M' AND age BETWEEN 9 AND 14, 1, 0))  AS q22MTeens,
           SUM(IF(gender = 'F' AND age BETWEEN 9 AND 14, 1, 0))  AS q22FTeens,
           SUM(IF(gender = 'M' AND age BETWEEN 15 AND 19, 1, 0)) AS q22MSeniors,
           SUM(IF(gender = 'F' AND age BETWEEN 15 AND 19, 1, 0)) AS q22FSeniors,
           SUM(IF((gender = 'F' OR gender = 'M')
                  AND age BETWEEN 9 AND 19, 1, 0))               AS q22Total
         FROM
           (SELECT
              1                                                     AS indicator_id,
              'No. active on ART on 3rd line or higher ARV regimen' AS q22indicator
           ) Indicators
           LEFT JOIN (SELECT DISTINCT 1 AS indicator_id,
              pp.gender,
              pp.person_id,
                            TIMESTAMPDIFF(YEAR, pp.birthdate, CURRENT_DATE()) AS age
            FROM person pp
              INNER JOIN encounter e ON (e.patient_id = pp.person_id
                                         AND e.voided = 0)
              INNER JOIN obs o ON (e.encounter_id = o.encounter_id
                                   AND o.voided = 0
                                   AND YEAR(e.encounter_datetime) = start_year
                                   AND QUARTER(e.encounter_datetime) = start_quarter
                                   AND o.concept_id = 162990
                                   AND o.value_coded IN (162986,
                                                         90002,
                                                         162987))
            GROUP BY pp.person_id) enrollment USING (indicator_id)
         GROUP BY q22indicator) ind22 ON (ind21.indicator_id = ind22.indicator_id)
        INNER JOIN
        (SELECT
           indicator_id,
           q23indicator,
           SUM(IF(gender = 'M' AND age BETWEEN 9 AND 14, 1, 0))  AS q23MTeens,
           SUM(IF(gender = 'F' AND age BETWEEN 9 AND 14, 1, 0))  AS q23FTeens,
           SUM(IF(gender = 'M' AND age BETWEEN 15 AND 19, 1, 0)) AS q23MSeniors,
           SUM(IF(gender = 'F' AND age BETWEEN 15 AND 19, 1, 0)) AS q23FSeniors,
           SUM(IF((gender = 'F' OR gender = 'M')
                  AND age BETWEEN 9 AND 19, 1, 0))               AS q23Total
         FROM
           (SELECT
              1                                                                             AS indicator_id,
              'No. active on ART who received CPT/Dapsone at the last visit in the quarter' AS q23indicator
           ) Indicators
           LEFT JOIN (SELECT DISTINCT 1 AS indicator_id,
              pp.gender,
              pp.person_id,
                            MAX(e.encounter_datetime) en_date,
                            TIMESTAMPDIFF(YEAR, pp.birthdate, CURRENT_DATE()) AS age
            FROM person pp
              INNER JOIN encounter e ON (e.patient_id = pp.person_id
                                         AND QUARTER(e.encounter_datetime) = start_quarter
                                         AND YEAR(e.encounter_datetime) = start_year
                                         AND e.voided = 0)
              INNER JOIN obs o ON (e.encounter_id = o.encounter_id
                                   AND o.concept_id = 99037
                                   AND o.value_numeric > 0
                                   AND o.voided = 0
                                   AND e.patient_id IN
                                       (SELECT DISTINCT patient_id
                                        FROM  obs oi WHERE oi.concept_id = 90315
                                                           AND oi.value_coded > 0
                                                           AND oi.voided = 0
                                                           AND QUARTER(oi.obs_datetime) = start_quarter
                                                           AND YEAR(oi.obs_datetime) = start_year))
            GROUP BY pp.person_id) enrollment USING (indicator_id)
         GROUP BY q23indicator) ind23 ON (ind22.indicator_id = ind23.indicator_id)
        INNER JOIN
        (SELECT
           indicator_id,
           q24indicator,
           SUM(IF((gender = 'F' OR gender = 'M')
                  AND age BETWEEN 9 AND 19, 1, 0)) AS q24Total
         FROM
           (SELECT
              1                                                                 AS indicator_id,
              'No. active on ART assessed for TB at last visit in the  quarter' AS q24indicator
           ) Indicators
           LEFT JOIN (SELECT DISTINCT 1 AS indicator_id,
              pp.gender,
              pp.person_id,
                            MAX(e.encounter_datetime) en_date,
                            TIMESTAMPDIFF(YEAR, pp.birthdate, CURRENT_DATE()) AS age
            FROM person pp
              INNER JOIN encounter e ON (e.patient_id = pp.person_id
                                         AND QUARTER(e.encounter_datetime) = start_quarter
                                         AND YEAR(e.encounter_datetime) = start_year
                                         AND e.voided = 0
                                         AND e.patient_id IN
                                             (SELECT DISTINCT patient_id
                                              FROM encounter ei
                                                JOIN obs oi ON (ei.encounter_id = oi.encounter_id
                                                                AND oi.concept_id = 90315
                                                                AND oi.value_coded > 0
                                                                AND oi.voided = 0
                                                                AND QUARTER(ei.encounter_datetime) = start_quarter
                                                                AND YEAR(ei.encounter_datetime) = start_year)))
              INNER JOIN obs o ON (e.encounter_id = o.encounter_id
                                   AND o.voided = 0
                                   AND o.concept_id = 90216
                                   AND o.value_coded > 0)
            GROUP BY pp.person_id) enrollment USING (indicator_id)
         GROUP BY q24indicator) ind24 ON (ind23.indicator_id = ind24.indicator_id)
        INNER JOIN
        (SELECT
           indicator_id,
           q25indicator,
           SUM(IF((gender = 'F' OR gender = 'M')
                  AND age BETWEEN 9 AND 19, 1, 0)) AS q25Total
         FROM
           (SELECT
              1                                                        AS indicator_id,
              'No. active on ART diagnosed with TB during the quarter' AS q25indicator
           ) Indicators
           LEFT JOIN (SELECT DISTINCT 1 AS indicator_id,
              pp.gender,
              pp.person_id,
                            MAX(e.encounter_datetime) en_date,
                            TIMESTAMPDIFF(YEAR, pp.birthdate, CURRENT_DATE()) AS age
            FROM person pp
              INNER JOIN encounter e ON (e.patient_id = pp.person_id
                                         AND QUARTER(e.encounter_datetime) = start_quarter
                                         AND YEAR(e.encounter_datetime) = start_year
                                         AND e.voided = 0
                                         AND e.patient_id IN
                                             (SELECT DISTINCT patient_id
                                              FROM obs oi WHERE oi.concept_id = 90315
                                                                AND oi.value_coded > 0
                                                                AND oi.voided = 0
                                                                AND QUARTER(oi.obs_datetime) = start_quarter
                                                                AND YEAR(oi.obs_datetime) = start_year))
              INNER JOIN obs o ON (e.encounter_id = o.encounter_id
                                   AND o.voided = 0
                                   AND o.concept_id = 90216
                                   AND o.value_coded = 90078)
            GROUP BY pp.person_id) enrollment USING (indicator_id)
         GROUP BY q25indicator) ind25 ON (ind24.indicator_id = ind25.indicator_id)
        INNER JOIN
        (SELECT
           indicator_id,
           q26indicator,
           SUM(IF((gender = 'F' OR gender = 'M')
                  AND age BETWEEN 9 AND 19, 1, 0)) AS q26Total
         FROM
           (SELECT
              1                                                                            AS indicator_id,
              'No. active on ART started on TB treatment during the quarter(New TB cases)' AS q26indicator
           ) Indicators
           LEFT JOIN (SELECT DISTINCT 1 AS indicator_id,
              pp.gender,
              pp.person_id,
                            MAX(e.encounter_datetime) en_date,
                            TIMESTAMPDIFF(YEAR, pp.birthdate, CURRENT_DATE()) AS age
            FROM person pp
              INNER JOIN encounter e ON (e.patient_id = pp.person_id
                                         AND QUARTER(e.encounter_datetime) = start_quarter
                                         AND YEAR(e.encounter_datetime) = start_year
                                         AND e.voided = 0
                                         AND e.patient_id IN
                                             (SELECT DISTINCT patient_id
                                              FROM obs oi WHERE oi.concept_id = 90315
                                                                AND oi.value_coded > 0
                                                                AND oi.voided = 0
                                                                AND QUARTER(oi.obs_datetime) = start_quarter
                                                                AND YEAR(oi.obs_datetime) = start_year))
              INNER JOIN obs o ON (e.encounter_id = o.encounter_id
                                   AND o.voided = 0
                                   AND o.concept_id = 90217
                                   AND QUARTER(o.value_datetime) = start_quarter
                                   AND YEAR(o.value_datetime) = start_year)
            GROUP BY pp.person_id) enrollment USING (indicator_id)
         GROUP BY q26indicator) ind26 ON (ind25.indicator_id = ind26.indicator_id)
        INNER JOIN
        (SELECT
           indicator_id,
           q27indicator,
           SUM(IF((gender = 'F' OR gender = 'M')
                  AND age BETWEEN 9 AND 19, 1, 0)) AS q27Total
         FROM
           (SELECT
              1                                                                 AS indicator_id,
              'Total No. active on ART  and on TB treatment during the quarter' AS q27indicator
           ) Indicators
           LEFT JOIN (SELECT DISTINCT 1 AS indicator_id,
              pp.gender,
              pp.person_id,
                            MAX(e.encounter_datetime) en_date,
                            TIMESTAMPDIFF(YEAR, pp.birthdate, CURRENT_DATE()) AS age
            FROM person pp
              INNER JOIN encounter e ON (e.patient_id = pp.person_id
                                         AND form_id = 12
                                         AND QUARTER(e.encounter_datetime) = start_quarter
                                         AND YEAR(e.encounter_datetime) = start_year
                                         AND e.voided = 0
                                         AND e.patient_id IN
                                             (SELECT DISTINCT patient_id
                                              FROM encounter ei
                                                JOIN obs oi ON (ei.encounter_id = oi.encounter_id
                                                                AND oi.concept_id = 90315
                                                                AND oi.value_coded > 0
                                                                AND oi.voided = 0
                                                                AND QUARTER(ei.encounter_datetime) = start_quarter
                                                                AND YEAR(ei.encounter_datetime) = start_year)))
              INNER JOIN obs o ON (e.encounter_id = o.encounter_id
                                   AND o.voided = 0
                                   AND o.concept_id = 90216
                                   AND o.value_coded = 90071)
            GROUP BY pp.person_id) enrollment USING (indicator_id)
         GROUP BY q27indicator) ind27 ON (ind26.indicator_id = ind27.indicator_id)
        INNER JOIN
        (SELECT
           indicator_id,
           q28indicator,
           SUM(IF((gender = 'F' OR gender = 'M')
                  AND age BETWEEN 9 AND 19, 1, 0)) AS q28Total
         FROM
           (SELECT
              1                                                                AS indicator_id,
              'No. active on ART with Good adherence(>95%) during the quarter' AS q28indicator
           ) Indicators
           LEFT JOIN (SELECT DISTINCT 1 AS indicator_id,
              pp.gender,
              pp.person_id,
                            MAX(e.encounter_datetime) en_date,
                            TIMESTAMPDIFF(YEAR, pp.birthdate, CURRENT_DATE()) AS age
            FROM person pp
              INNER JOIN encounter e ON (e.patient_id = pp.person_id
                                         AND QUARTER(e.encounter_datetime) = start_quarter
                                         AND YEAR(e.encounter_datetime) = start_year
                                         AND e.voided = 0)
              INNER JOIN obs o ON (e.encounter_id = o.encounter_id
                                   AND o.voided = 0
                                   AND o.concept_id = 90221
                                   AND o.value_coded = 90156)
            GROUP BY pp.person_id) enrollment USING (indicator_id)
         GROUP BY q28indicator) ind28 ON (ind27.indicator_id = ind28.indicator_id)
        INNER JOIN
        (SELECT
           indicator_id,
           q29indicator,
           SUM(IF((gender = 'F' OR gender = 'M')
                  AND age BETWEEN 9 AND 19, 1, 0)) AS q29Total
         FROM
           (SELECT
              1                                                                                AS indicator_id,
              'No. active on ART Care assessed for malnutrition at their visit in the quarter' AS q29indicator
           ) Indicators
           LEFT JOIN (SELECT DISTINCT 1 AS indicator_id,
              pp.gender,
              pp.person_id,
                            MAX(e.encounter_datetime) en_date,
                            TIMESTAMPDIFF(YEAR, pp.birthdate, CURRENT_DATE()) AS age
            FROM person pp
              INNER JOIN patient p ON (pp.person_id = p.patient_id
                                       AND p.voided = 0)
              INNER JOIN encounter e ON (e.patient_id = p.patient_id
                                         AND form_id = 12
                                         AND QUARTER(e.encounter_datetime) = 1
                                         AND YEAR(e.encounter_datetime) = start_year
                                         AND e.voided = 0
                                         AND e.patient_id IN
                                             (SELECT DISTINCT patient_id
                                              FROM encounter ei
                                                JOIN obs oi ON (ei.encounter_id = oi.encounter_id
                                                                AND oi.concept_id = 90315
                                                                AND oi.value_coded > 0
                                                                AND oi.voided = 0
                                                                AND QUARTER(ei.encounter_datetime) = start_quarter
                                                                AND YEAR(ei.encounter_datetime) = start_year)))
              INNER JOIN obs o ON (e.encounter_id = o.encounter_id
                                   AND o.voided = 0
                                   AND o.concept_id IN (90236,5090,99030,99069) AND (o.value_numeric > 0 OR o.value_coded > 0))
            GROUP BY pp.person_id) enrollment USING (indicator_id)
         GROUP BY q29indicator) ind29 ON (ind28.indicator_id = ind29.indicator_id)
        INNER JOIN
        (SELECT
           indicator_id,
           q30indicator,
           SUM(IF((gender = 'F' OR gender = 'M')
                  AND age BETWEEN 9 AND 19, 1, 0)) AS q30Total
         FROM
           (SELECT
              1                                                                            AS indicator_id,
              'No. active on ART who are malnuourished at their last visit in the quarter' AS q30indicator
           ) Indicators
           LEFT JOIN (SELECT DISTINCT 1 AS indicator_id,
              pp.gender,
              pp.person_id,
                            MAX(e.encounter_datetime) en_date,
                            TIMESTAMPDIFF(YEAR, pp.birthdate, CURRENT_DATE()) AS age
            FROM person pp
              INNER JOIN patient p ON (pp.person_id = p.patient_id
                                       AND p.voided = 0)
              INNER JOIN encounter e ON (e.patient_id = p.patient_id
                                         AND form_id = 12
                                         AND QUARTER(e.encounter_datetime) = 1
                                         AND YEAR(e.encounter_datetime) = start_year
                                         AND e.voided = 0
                                         AND e.patient_id IN
                                             (SELECT DISTINCT patient_id
                                              FROM encounter ei
                                                JOIN obs oi ON (ei.encounter_id = oi.encounter_id
                                                                AND form_id = 12
                                                                AND oi.concept_id = 90315
                                                                AND oi.value_coded > 0
                                                                AND oi.voided = 0
                                                                AND QUARTER(ei.encounter_datetime) = start_quarter
                                                                AND YEAR(ei.encounter_datetime) = start_year)))
              INNER JOIN obs o ON (e.encounter_id = o.encounter_id
                                   AND o.voided = 0
                                   AND o.concept_id = 68
                                   AND o.value_coded IN (99271,
                                                         99272,
                                                         99273))
            GROUP BY pp.person_id) enrollment USING (indicator_id)
         GROUP BY q30indicator) ind30 ON (ind29.indicator_id = ind30.indicator_id);

    END$$
  DELIMITER ;

  DELIMITER $$
  CREATE DEFINER=`root`@`localhost` PROCEDURE `hmis106a1b`(IN start_year INTEGER, IN start_quarter INTEGER)
  BEGIN
      DECLARE h11a CHAR(255) DEFAULT 'All patients 6 months';
      DECLARE h12a CHAR(100) DEFAULT getCohortMonth(start_year, start_quarter, 6);
      DECLARE h13a INT DEFAULT getCohortAllBefore3(start_year, start_quarter, 6,0);
      DECLARE h14a CHAR(20) DEFAULT CONCAT(getCohortAllBefore4a(start_year, start_quarter, 6,0), '/',
                                           getCohortAllBefore4b(start_year, start_quarter, 6,0));
      DECLARE h15a INT DEFAULT getCohortAllBefore5(start_year, start_quarter, 6,0);
      DECLARE h16a INT DEFAULT getCohortAllBefore6(start_year, start_quarter, 6,0);
      DECLARE h17a INT DEFAULT getCohortAllBefore7(start_year, start_quarter, 6,0);
      DECLARE h18a INT DEFAULT h13a + h16a - h17a;
      DECLARE h19a INT DEFAULT getCohortAllBefore9(start_year, start_quarter, 6,0);
      DECLARE h110a INT DEFAULT getCohortAllBefore10(start_year, start_quarter, 6,0);
      DECLARE h111a INT DEFAULT getCohortAllBefore11(start_year, start_quarter, 6,0);
      DECLARE h112a INT DEFAULT getCohortAllBefore12(start_year, start_quarter, 6,0);


      DECLARE h113a INT DEFAULT h18a - h19a - h112a;

      DECLARE h114a DECIMAL DEFAULT (h113a / h18a) * 100;
      DECLARE h115a CHAR(20) DEFAULT CONCAT(getCohortAllBefore15a(start_year, start_quarter, 6,0), '/',
                                            getCohortAllBefore15b(start_year, start_quarter, 6,0));
      DECLARE h116a INT DEFAULT getCohortAllBefore16(start_year, start_quarter, 6,0);

      DECLARE h21a CHAR(255) DEFAULT 'All patients 12 months';
      DECLARE h22a CHAR(100) DEFAULT getCohortMonth(start_year, start_quarter, 12);
      DECLARE h23a INT DEFAULT getCohortAllBefore3(start_year, start_quarter, 12,0);
      DECLARE h24a CHAR(20) DEFAULT CONCAT(getCohortAllBefore4a(start_year, start_quarter, 12,0), '/',
                                           getCohortAllBefore4b(start_year, start_quarter, 12,0));
      DECLARE h25a INT DEFAULT getCohortAllBefore5(start_year, start_quarter, 12,0);
      DECLARE h26a INT DEFAULT getCohortAllBefore6(start_year, start_quarter, 12,0);
      DECLARE h27a INT DEFAULT getCohortAllBefore7(start_year, start_quarter, 12,0);
      DECLARE h28a INT DEFAULT h23a + h26a - h27a;
      DECLARE h29a INT DEFAULT getCohortAllBefore9(start_year, start_quarter, 12,0);
      DECLARE h210a INT DEFAULT getCohortAllBefore10(start_year, start_quarter, 12,0);
      DECLARE h211a INT DEFAULT getCohortAllBefore11(start_year, start_quarter, 12,0);
      DECLARE h212a INT DEFAULT getCohortAllBefore12(start_year, start_quarter, 12,0);
      DECLARE h213a INT DEFAULT h28a - h29a - h210a - h211a - h212a;
      DECLARE h214a DECIMAL DEFAULT (h213a / h28a) * 100;
      DECLARE h215a CHAR(20) DEFAULT CONCAT(getCohortAllBefore15a(start_year, start_quarter, 12,0), '/',
                                            getCohortAllBefore15b(start_year, start_quarter, 12,0));
      DECLARE h216a INT DEFAULT getCohortAllBefore16(start_year, start_quarter, 12,0);

      DECLARE h31a CHAR(255) DEFAULT 'All patients 24 months';
      DECLARE h32a CHAR(100) DEFAULT getCohortMonth(start_year, start_quarter, 24);
      DECLARE h33a INT DEFAULT getCohortAllBefore3(start_year, start_quarter, 24,0);
      DECLARE h34a CHAR(20) DEFAULT CONCAT(getCohortAllBefore4a(start_year, start_quarter, 24,0), '/',
                                           getCohortAllBefore4b(start_year, start_quarter, 24,0));
      DECLARE h35a INT DEFAULT getCohortAllBefore5(start_year, start_quarter, 24,0);
      DECLARE h36a INT DEFAULT getCohortAllBefore6(start_year, start_quarter, 24,0);
      DECLARE h37a INT DEFAULT getCohortAllBefore7(start_year, start_quarter, 24,0);
      DECLARE h38a INT DEFAULT h33a + h36a - h37a;
      DECLARE h39a INT DEFAULT getCohortAllBefore9(start_year, start_quarter, 24,0);
      DECLARE h310a INT DEFAULT getCohortAllBefore10(start_year, start_quarter, 24,0);
      DECLARE h311a INT DEFAULT getCohortAllBefore11(start_year, start_quarter, 24,0);
      DECLARE h312a INT DEFAULT getCohortAllBefore12(start_year, start_quarter, 24,0);
      DECLARE h313a INT DEFAULT h38a - h39a - h310a - h312a;

      DECLARE h314a DECIMAL DEFAULT (h313a / h38a) * 100;
      DECLARE h315a CHAR(20) DEFAULT CONCAT(getCohortAllBefore15a(start_year, start_quarter, 24,0), '/',
                                            getCohortAllBefore15b(start_year, start_quarter, 24,0));
      DECLARE h316a INT DEFAULT getCohortAllBefore16(start_year, start_quarter, 24,0);

      DECLARE h41a CHAR(255) DEFAULT 'All patients 36 months';
      DECLARE h42a CHAR(100) DEFAULT getCohortMonth(start_year, start_quarter, 36);
      DECLARE h43a INT DEFAULT getCohortAllBefore3(start_year, start_quarter, 36,0);
      DECLARE h44a CHAR(20) DEFAULT CONCAT(getCohortAllBefore4a(start_year, start_quarter, 36,0), '/',
                                           getCohortAllBefore4b(start_year, start_quarter, 36,0));
      DECLARE h45a INT DEFAULT getCohortAllBefore5(start_year, start_quarter, 36,0);
      DECLARE h46a INT DEFAULT getCohortAllBefore6(start_year, start_quarter, 36,0);
      DECLARE h47a INT DEFAULT getCohortAllBefore7(start_year, start_quarter, 36,0);
      DECLARE h48a INT DEFAULT h43a + h46a - h47a;
      DECLARE h49a INT DEFAULT getCohortAllBefore9(start_year, start_quarter, 36,0);
      DECLARE h410a INT DEFAULT getCohortAllBefore10(start_year, start_quarter, 36,0);
      DECLARE h411a INT DEFAULT getCohortAllBefore11(start_year, start_quarter, 36,0);
      DECLARE h412a INT DEFAULT getCohortAllBefore12(start_year, start_quarter, 36,0);
      DECLARE h413a INT DEFAULT h48a - h49a - h410a - h412a;

      DECLARE h414a DECIMAL DEFAULT (h413a / h48a) * 100;
      DECLARE h415a CHAR(20) DEFAULT CONCAT(getCohortAllBefore15a(start_year, start_quarter, 36,0), '/',
                                            getCohortAllBefore15b(start_year, start_quarter, 36,0));
      DECLARE h416a INT DEFAULT getCohortAllBefore16(start_year, start_quarter, 36,0);

      DECLARE h51a CHAR(255) DEFAULT 'All patients 48 months';
      DECLARE h52a CHAR(100) DEFAULT getCohortMonth(start_year, start_quarter, 48);
      DECLARE h53a INT DEFAULT getCohortAllBefore3(start_year, start_quarter, 48,0);
      DECLARE h54a CHAR(20) DEFAULT CONCAT(getCohortAllBefore4a(start_year, start_quarter, 48,0), '/',
                                           getCohortAllBefore4b(start_year, start_quarter, 48,0));
      DECLARE h55a INT DEFAULT getCohortAllBefore5(start_year, start_quarter, 48,0);
      DECLARE h56a INT DEFAULT getCohortAllBefore6(start_year, start_quarter, 48,0);
      DECLARE h57a INT DEFAULT getCohortAllBefore7(start_year, start_quarter, 48,0);
      DECLARE h58a INT DEFAULT h53a + h56a - h57a;
      DECLARE h59a INT DEFAULT getCohortAllBefore9(start_year, start_quarter, 48,0);
      DECLARE h510a INT DEFAULT getCohortAllBefore10(start_year, start_quarter, 48,0);
      DECLARE h511a INT DEFAULT getCohortAllBefore11(start_year, start_quarter, 48,0);
      DECLARE h512a INT DEFAULT getCohortAllBefore12(start_year, start_quarter, 48,0);
      DECLARE h513a INT DEFAULT h58a - h59a - h510a - h512a;

      DECLARE h514a DECIMAL DEFAULT (h513a / h58a) * 100;
      DECLARE h515a CHAR(20) DEFAULT CONCAT(getCohortAllBefore15a(start_year, start_quarter, 48,0), '/',
                                            getCohortAllBefore15b(start_year, start_quarter, 48,0));
      DECLARE h516a INT DEFAULT getCohortAllBefore16(start_year, start_quarter, 48,0);

      DECLARE h61a CHAR(255) DEFAULT 'All patients 60 months';
      DECLARE h62a CHAR(100) DEFAULT getCohortMonth(start_year, start_quarter, 60);
      DECLARE h63a INT DEFAULT getCohortAllBefore3(start_year, start_quarter, 60,0);
      DECLARE h64a CHAR(20) DEFAULT CONCAT(getCohortAllBefore4a(start_year, start_quarter, 60,0), '/',
                                           getCohortAllBefore4b(start_year, start_quarter, 60,0));
      DECLARE h65a INT DEFAULT getCohortAllBefore5(start_year, start_quarter, 60,0);
      DECLARE h66a INT DEFAULT getCohortAllBefore6(start_year, start_quarter, 60,0);
      DECLARE h67a INT DEFAULT getCohortAllBefore7(start_year, start_quarter, 60,0);
      DECLARE h68a INT DEFAULT h63a + h66a - h67a;
      DECLARE h69a INT DEFAULT getCohortAllBefore9(start_year, start_quarter, 60,0);
      DECLARE h610a INT DEFAULT getCohortAllBefore10(start_year, start_quarter, 60,0);
      DECLARE h611a INT DEFAULT getCohortAllBefore11(start_year, start_quarter, 60,0);
      DECLARE h612a INT DEFAULT getCohortAllBefore12(start_year, start_quarter, 60,0);
      DECLARE h613a INT DEFAULT h68a - h69a - h610a - h612a;

      DECLARE h614a DECIMAL DEFAULT (h613a / h68a) * 100;
      DECLARE h615a CHAR(20) DEFAULT CONCAT(getCohortAllBefore15a(start_year, start_quarter, 60,0), '/',
                                            getCohortAllBefore15b(start_year, start_quarter, 60,0));
      DECLARE h616a INT DEFAULT getCohortAllBefore16(start_year, start_quarter, 60,0);

      DECLARE h71a CHAR(255) DEFAULT 'All patients 72 months';
      DECLARE h72a CHAR(100) DEFAULT getCohortMonth(start_year, start_quarter, 72);
      DECLARE h73a INT DEFAULT getCohortAllBefore3(start_year, start_quarter, 72,0);
      DECLARE h74a CHAR(20) DEFAULT CONCAT(getCohortAllBefore4a(start_year, start_quarter, 72,0), '/',
                                           getCohortAllBefore4b(start_year, start_quarter, 72,0));
      DECLARE h75a INT DEFAULT getCohortAllBefore5(start_year, start_quarter, 72,0);
      DECLARE h76a INT DEFAULT getCohortAllBefore6(start_year, start_quarter, 72,0);
      DECLARE h77a INT DEFAULT getCohortAllBefore7(start_year, start_quarter, 72,0);
      DECLARE h78a INT DEFAULT h73a + h76a - h77a;
      DECLARE h79a INT DEFAULT getCohortAllBefore9(start_year, start_quarter, 72,0);
      DECLARE h710a INT DEFAULT getCohortAllBefore10(start_year, start_quarter, 72,0);
      DECLARE h711a INT DEFAULT getCohortAllBefore11(start_year, start_quarter, 72,0);
      DECLARE h712a INT DEFAULT getCohortAllBefore12(start_year, start_quarter, 72,0);
      DECLARE h713a INT DEFAULT h78a - h79a - h710a - h712a;

      DECLARE h714a DECIMAL DEFAULT (h713a / h78a) * 100;
      DECLARE h715a CHAR(20) DEFAULT CONCAT(getCohortAllBefore15a(start_year, start_quarter, 72,0), '/',
                                            getCohortAllBefore15b(start_year, start_quarter, 72,0));
      DECLARE h716a INT DEFAULT getCohortAllBefore16(start_year, start_quarter, 72,0);

      DECLARE h11b CHAR(255) DEFAULT 'eMTCT Mothers 6 months';
      DECLARE h12b CHAR(100) DEFAULT getCohortMonth(start_year, start_quarter, 6);
      DECLARE h13b INT DEFAULT getCohortAllBefore3(start_year, start_quarter, 6, 1);
      DECLARE h14b CHAR(20) DEFAULT CONCAT(getCohortAllBefore4b(start_year, start_quarter, 6, 1), '/',
                                           getCohortAllBefore4b(start_year, start_quarter, 6, 1));
      DECLARE h15b INT DEFAULT getCohortAllBefore5(start_year, start_quarter, 6, 1);
      DECLARE h16b INT DEFAULT getCohortAllBefore6(start_year, start_quarter, 6, 1);
      DECLARE h17b INT DEFAULT getCohortAllBefore7(start_year, start_quarter, 6, 1);
      DECLARE h18b INT DEFAULT h13b + h16b - h17b;
      DECLARE h19b INT DEFAULT getCohortAllBefore9(start_year, start_quarter, 6, 1);
      DECLARE h110b INT DEFAULT getCohortAllBefore10(start_year, start_quarter, 6, 1);
      DECLARE h111b INT DEFAULT getCohortAllBefore11(start_year, start_quarter, 6, 1);
      DECLARE h112b INT DEFAULT getCohortAllBefore12(start_year, start_quarter, 6, 1);
      DECLARE h113b INT DEFAULT h18b - h19b - h110b - h112b;

      DECLARE h114b DECIMAL DEFAULT (h113b / h18b) * 100;
      DECLARE h115b CHAR(20) DEFAULT CONCAT(getCohortAllBefore15b(start_year, start_quarter, 6, 1), '/',
                                            getCohortAllBefore15b(start_year, start_quarter, 6, 1));
      DECLARE h116b INT DEFAULT getCohortAllBefore16(start_year, start_quarter, 6, 1);

      DECLARE h21b CHAR(255) DEFAULT 'eMTCT Mothers 12 months';
      DECLARE h22b CHAR(100) DEFAULT getCohortMonth(start_year, start_quarter, 12);
      DECLARE h23b INT DEFAULT getCohortAllBefore3(start_year, start_quarter, 12, 1);
      DECLARE h24b CHAR(20) DEFAULT CONCAT(getCohortAllBefore4b(start_year, start_quarter, 12, 1), '/',
                                           getCohortAllBefore4b(start_year, start_quarter, 12, 1));
      DECLARE h25b INT DEFAULT getCohortAllBefore5(start_year, start_quarter, 12, 1);
      DECLARE h26b INT DEFAULT getCohortAllBefore6(start_year, start_quarter, 12, 1);
      DECLARE h27b INT DEFAULT getCohortAllBefore7(start_year, start_quarter, 12, 1);
      DECLARE h28b INT DEFAULT h23b + h26b - h27b;
      DECLARE h29b INT DEFAULT getCohortAllBefore9(start_year, start_quarter, 12, 1);
      DECLARE h210b INT DEFAULT getCohortAllBefore10(start_year, start_quarter, 12, 1);
      DECLARE h211b INT DEFAULT getCohortAllBefore11(start_year, start_quarter, 12, 1);
      DECLARE h212b INT DEFAULT getCohortAllBefore12(start_year, start_quarter, 12, 1);
      DECLARE h213b INT DEFAULT h28b - h29b - h210b - h212b;

      DECLARE h214b DECIMAL DEFAULT (h213b / h28b) * 100;
      DECLARE h215b CHAR(20) DEFAULT CONCAT(getCohortAllBefore15b(start_year, start_quarter, 12, 1), '/',
                                            getCohortAllBefore15b(start_year, start_quarter, 12, 1));
      DECLARE h216b INT DEFAULT getCohortAllBefore16(start_year, start_quarter, 12, 1);

      DECLARE h31b CHAR(255) DEFAULT 'eMTCT Mothers 24 months';
      DECLARE h32b CHAR(100) DEFAULT getCohortMonth(start_year, start_quarter, 24);
      DECLARE h33b INT DEFAULT getCohortAllBefore3(start_year, start_quarter, 24, 1);
      DECLARE h34b CHAR(20) DEFAULT CONCAT(getCohortAllBefore4b(start_year, start_quarter, 24, 1), '/',
                                           getCohortAllBefore4b(start_year, start_quarter, 24, 1));
      DECLARE h35b INT DEFAULT getCohortAllBefore5(start_year, start_quarter, 24, 1);
      DECLARE h36b INT DEFAULT getCohortAllBefore6(start_year, start_quarter, 24, 1);
      DECLARE h37b INT DEFAULT getCohortAllBefore7(start_year, start_quarter, 24, 1);
      DECLARE h38b INT DEFAULT h33b + h36b - h37b;
      DECLARE h39b INT DEFAULT getCohortAllBefore9(start_year, start_quarter, 24, 1);
      DECLARE h310b INT DEFAULT getCohortAllBefore10(start_year, start_quarter, 24, 1);
      DECLARE h311b INT DEFAULT getCohortAllBefore11(start_year, start_quarter, 24, 1);
      DECLARE h312b INT DEFAULT getCohortAllBefore12(start_year, start_quarter, 24, 1);
      DECLARE h313b INT DEFAULT h38b - h39b - h310b - h312b;

      DECLARE h314b DECIMAL DEFAULT (h313b / h38b) * 100;
      DECLARE h315b CHAR(20) DEFAULT CONCAT(getCohortAllBefore15b(start_year, start_quarter, 24, 1), '/',
                                            getCohortAllBefore15b(start_year, start_quarter, 24, 1));
      DECLARE h316b INT DEFAULT getCohortAllBefore16(start_year, start_quarter, 24, 1);

      DECLARE h41b CHAR(255) DEFAULT 'eMTCT Mothers 36 months';
      DECLARE h42b CHAR(100) DEFAULT getCohortMonth(start_year, start_quarter, 36);
      DECLARE h43b INT DEFAULT getCohortAllBefore3(start_year, start_quarter, 36, 1);
      DECLARE h44b CHAR(20) DEFAULT CONCAT(getCohortAllBefore4b(start_year, start_quarter, 36, 1), '/',
                                           getCohortAllBefore4b(start_year, start_quarter, 36, 1));
      DECLARE h45b INT DEFAULT getCohortAllBefore5(start_year, start_quarter, 36, 1);
      DECLARE h46b INT DEFAULT getCohortAllBefore6(start_year, start_quarter, 36, 1);
      DECLARE h47b INT DEFAULT getCohortAllBefore7(start_year, start_quarter, 36, 1);
      DECLARE h48b INT DEFAULT h43b + h46b - h47b;
      DECLARE h49b INT DEFAULT getCohortAllBefore9(start_year, start_quarter, 36, 1);
      DECLARE h410b INT DEFAULT getCohortAllBefore10(start_year, start_quarter, 36, 1);
      DECLARE h411b INT DEFAULT getCohortAllBefore11(start_year, start_quarter, 36, 1);
      DECLARE h412b INT DEFAULT getCohortAllBefore12(start_year, start_quarter, 36, 1);
      DECLARE h413b INT DEFAULT h48b - h49b - h410b - h412b;

      DECLARE h414b DECIMAL DEFAULT (h413b / h48b) * 100;
      DECLARE h415b CHAR(20) DEFAULT CONCAT(getCohortAllBefore15b(start_year, start_quarter, 36, 1), '/',
                                            getCohortAllBefore15b(start_year, start_quarter, 36, 1));
      DECLARE h416b INT DEFAULT getCohortAllBefore16(start_year, start_quarter, 36, 1);

      DECLARE h51b CHAR(255) DEFAULT 'eMTCT Mothers 48 months';
      DECLARE h52b CHAR(100) DEFAULT getCohortMonth(start_year, start_quarter, 48);
      DECLARE h53b INT DEFAULT getCohortAllBefore3(start_year, start_quarter, 48, 1);
      DECLARE h54b CHAR(20) DEFAULT CONCAT(getCohortAllBefore4b(start_year, start_quarter, 48, 1), '/',
                                           getCohortAllBefore4b(start_year, start_quarter, 48, 1));
      DECLARE h55b INT DEFAULT getCohortAllBefore5(start_year, start_quarter, 48, 1);
      DECLARE h56b INT DEFAULT getCohortAllBefore6(start_year, start_quarter, 48, 1);
      DECLARE h57b INT DEFAULT getCohortAllBefore7(start_year, start_quarter, 48, 1);
      DECLARE h58b INT DEFAULT h53b + h56b - h57b;
      DECLARE h59b INT DEFAULT getCohortAllBefore9(start_year, start_quarter, 48, 1);
      DECLARE h510b INT DEFAULT getCohortAllBefore10(start_year, start_quarter, 48, 1);
      DECLARE h511b INT DEFAULT getCohortAllBefore11(start_year, start_quarter, 48, 1);
      DECLARE h512b INT DEFAULT getCohortAllBefore12(start_year, start_quarter, 48, 1);
      DECLARE h513b INT DEFAULT h58b - h59b - h510b - h512b;

      DECLARE h514b DECIMAL DEFAULT (h513b / h58b) * 100;
      DECLARE h515b CHAR(20) DEFAULT CONCAT(getCohortAllBefore15b(start_year, start_quarter, 48, 1), '/',
                                            getCohortAllBefore15b(start_year, start_quarter, 48, 1));
      DECLARE h516b INT DEFAULT getCohortAllBefore16(start_year, start_quarter, 48, 1);

      DECLARE h61b CHAR(255) DEFAULT 'eMTCT Mothers 60 months';
      DECLARE h62b CHAR(100) DEFAULT getCohortMonth(start_year, start_quarter, 60);
      DECLARE h63b INT DEFAULT getCohortAllBefore3(start_year, start_quarter, 60, 1);
      DECLARE h64b CHAR(20) DEFAULT CONCAT(getCohortAllBefore4b(start_year, start_quarter, 60, 1), '/',
                                           getCohortAllBefore4b(start_year, start_quarter, 60, 1));
      DECLARE h65b INT DEFAULT getCohortAllBefore5(start_year, start_quarter, 60, 1);
      DECLARE h66b INT DEFAULT getCohortAllBefore6(start_year, start_quarter, 60, 1);
      DECLARE h67b INT DEFAULT getCohortAllBefore7(start_year, start_quarter, 60, 1);
      DECLARE h68b INT DEFAULT h63b + h66b - h67b;
      DECLARE h69b INT DEFAULT getCohortAllBefore9(start_year, start_quarter, 60, 1);
      DECLARE h610b INT DEFAULT getCohortAllBefore10(start_year, start_quarter, 60, 1);
      DECLARE h611b INT DEFAULT getCohortAllBefore11(start_year, start_quarter, 60, 1);
      DECLARE h612b INT DEFAULT getCohortAllBefore12(start_year, start_quarter, 60, 1);
      DECLARE h613b INT DEFAULT h68b - h69b - h610b - h612b;

      DECLARE h614b DECIMAL DEFAULT (h613b / h68b) * 100;
      DECLARE h615b CHAR(20) DEFAULT CONCAT(getCohortAllBefore15b(start_year, start_quarter, 60, 1), '/',
                                            getCohortAllBefore15b(start_year, start_quarter, 60, 1));
      DECLARE h616b INT DEFAULT getCohortAllBefore16(start_year, start_quarter, 60, 1);

      DECLARE h71b CHAR(255) DEFAULT 'eMTCT Mothers 72 months';
      DECLARE h72b CHAR(100) DEFAULT getCohortMonth(start_year, start_quarter, 72);
      DECLARE h73b INT DEFAULT getCohortAllBefore3(start_year, start_quarter, 72, 1);
      DECLARE h74b CHAR(20) DEFAULT CONCAT(getCohortAllBefore4b(start_year, start_quarter, 72, 1), '/',
                                           getCohortAllBefore4b(start_year, start_quarter, 72, 1));
      DECLARE h75b INT DEFAULT getCohortAllBefore5(start_year, start_quarter, 72, 1);
      DECLARE h76b INT DEFAULT getCohortAllBefore6(start_year, start_quarter, 72, 1);
      DECLARE h77b INT DEFAULT getCohortAllBefore7(start_year, start_quarter, 72, 1);
      DECLARE h78b INT DEFAULT h73b + h76b - h77b;
      DECLARE h79b INT DEFAULT getCohortAllBefore9(start_year, start_quarter, 72, 1);
      DECLARE h710b INT DEFAULT getCohortAllBefore10(start_year, start_quarter, 72, 1);
      DECLARE h711b INT DEFAULT getCohortAllBefore11(start_year, start_quarter, 72, 1);
      DECLARE h712b INT DEFAULT getCohortAllBefore12(start_year, start_quarter, 72, 1);
      DECLARE h713b INT DEFAULT h78b - h79b - h110b - h712b;

      DECLARE h714b DECIMAL DEFAULT (h713b / h78b) * 100;
      DECLARE h715b CHAR(20) DEFAULT CONCAT(getCohortAllBefore15b(start_year, start_quarter, 72, 1), '/',
                                            getCohortAllBefore15b(start_year, start_quarter, 72, 1));
      DECLARE h716b INT DEFAULT getCohortAllBefore16(start_year, start_quarter, 72, 1);

      SELECT
        h11a,
        h12a,
        h13a,
        h14a,
        h15a,
        h16a,
        h17a,
        h18a,
        h19a,
        h110a,
        h111a,
        h112a,
        h113a,
        h114a,
        h115a,
        h116a,

        h21a,
        h22a,
        h23a,
        h24a,
        h25a,
        h26a,
        h27a,
        h28a,
        h29a,
        h210a,
        h211a,
        h212a,
        h213a,
        h214a,
        h215a,
        h216a,

        h31a,
        h32a,
        h33a,
        h34a,
        h35a,
        h36a,
        h37a,
        h38a,
        h39a,
        h310a,
        h311a,
        h312a,
        h313a,
        h314a,
        h315a,
        h316a,

        h41a,
        h42a,
        h43a,
        h44a,
        h45a,
        h46a,
        h47a,
        h48a,
        h49a,
        h410a,
        h411a,
        h412a,
        h413a,
        h414a,
        h415a,
        h416a,

        h51a,
        h52a,
        h53a,
        h54a,
        h55a,
        h56a,
        h57a,
        h58a,
        h59a,
        h510a,
        h511a,
        h512a,
        h513a,
        h514a,
        h515a,
        h516a,

        h61a,
        h62a,
        h63a,
        h64a,
        h65a,
        h66a,
        h67a,
        h68a,
        h69a,
        h610a,
        h611a,
        h612a,
        h613a,
        h614a,
        h615a,
        h616a,

        h71a,
        h72a,
        h73a,
        h74a,
        h75a,
        h76a,
        h77a,
        h78a,
        h79a,
        h710a,
        h711a,
        h712a,
        h713a,
        h714a,
        h715a,
        h716a,

        h11b,
        h12b,
        h13b,
        h14b,
        h15b,
        h16b,
        h17b,
        h18b,
        h19b,
        h110b,
        h111b,
        h112b,
        h113b,
        h114b,
        h115b,
        h116b,

        h21b,
        h22b,
        h23b,
        h24b,
        h25b,
        h26b,
        h27b,
        h28b,
        h29b,
        h210b,
        h211b,
        h212b,
        h213b,
        h214b,
        h215b,
        h216b,

        h31b,
        h32b,
        h33b,
        h34b,
        h35b,
        h36b,
        h37b,
        h38b,
        h39b,
        h310b,
        h311b,
        h312b,
        h313b,
        h314b,
        h315b,
        h316b,

        h41b,
        h42b,
        h43b,
        h44b,
        h45b,
        h46b,
        h47b,
        h48b,
        h49b,
        h410b,
        h411b,
        h412b,
        h413b,
        h414b,
        h415b,
        h416b,

        h51b,
        h52b,
        h53b,
        h54b,
        h55b,
        h56b,
        h57b,
        h58b,
        h59b,
        h510b,
        h511b,
        h512b,
        h513b,
        h514b,
        h515b,
        h516b,

        h61b,
        h62b,
        h63b,
        h64b,
        h65b,
        h66b,
        h67b,
        h68b,
        h69b,
        h610b,
        h611b,
        h612b,
        h613b,
        h614b,
        h615b,
        h616b,

        h71b,
        h72b,
        h73b,
        h74b,
        h75b,
        h76b,
        h77b,
        h78b,
        h79b,
        h710b,
        h711b,
        h712b,
        h713b,
        h714b,
        h715b,
        h716b;
    END$$
  DELIMITER ;

  DELIMITER $$
  CREATE DEFINER=`openmrs`@`localhost` PROCEDURE `mergeSummaryPages`()
  BEGIN

  	DECLARE patient TEXT;
  	DECLARE ecnounter TEXT;
  	DECLARE total TEXT;
  	DECLARE found_string TEXT;
  	DECLARE occurance INT;
  	DECLARE i INT DEFAULT 2;
  	DECLARE done INT DEFAULT FALSE;
  	DECLARE cursor_i CURSOR FOR select patient_id,encounter_type,count(*) from encounter where encounter_type = 14 group by patient_id,encounter_type HAVING COUNT(*) > 1;
  	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

  	DROP TEMPORARY TABLE IF EXISTS tb;
  	CREATE TEMPORARY TABLE IF NOT EXISTS tb(`name` TEXT);

  	OPEN cursor_i;
  		read_loop: LOOP
  			FETCH cursor_i INTO patient,ecnounter,total;
  			IF done THEN
  			  LEAVE read_loop;
  			END IF;

        select GROUP_CONCAT(encounter_id) INTO found_string from encounter where patient_id = patient and encounter_type = 14;
  			select LENGTH(found_string) - LENGTH(REPLACE(found_string, ',', '')) INTO occurance;

        SET i=1;
  			WHILE i <= occurance DO
  				update obs set encounter_id = SUBSTRING_INDEX( found_string, ',', 1 ) where encounter_id = SUBSTRING_INDEX( SUBSTRING_INDEX(found_string , ',', i + 1 ), ',', -1 );
          delete from encounter where encounter_id = SUBSTRING_INDEX( SUBSTRING_INDEX(found_string , ',', i + 1 ), ',', -1 );
          SET i = i + 1;
  			END WHILE;

  		END LOOP;
  	CLOSE cursor_i;

  END$$
  DELIMITER ;

  DELIMITER $$
  CREATE DEFINER=`openmrs`@`localhost` PROCEDURE `transfer`()
  BEGIN
      DECLARE t_name TEXT;

      DECLARE t1_columns TEXT;
      DECLARE t2_columns TEXT;
      DECLARE inter_columns TEXT;
      DECLARE inter_columns_insert TEXT;
      DECLARE pri_columns TEXT;
      DECLARE pri_col TEXT;
      DECLARE where_clause TEXT;
      DECLARE provider_column CHAR(20);
      DECLARE n INT DEFAULT 0;
      DECLARE i INT DEFAULT 0;

      DECLARE done INT DEFAULT FALSE;
      DECLARE done_primary_keys INT DEFAULT FALSE;

      DECLARE cursor_i CURSOR FOR SELECT table_name FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'openmrs_backup'  AND table_rows > 0 AND lower(table_name) not like '%liquibase%' AND lower(table_name) not in ('form','location','encounter_type');
      DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

      DROP TEMPORARY TABLE IF EXISTS tb;
      CREATE TEMPORARY TABLE IF NOT EXISTS tb(`name` TEXT);

      OPEN cursor_i;
      read_loop: LOOP
        FETCH cursor_i INTO t_name;
        IF done THEN
          LEAVE read_loop;
        END IF;

        SELECT GROUP_CONCAT(COLUMN_NAME) INTO t1_columns FROM INFORMATION_SCHEMA.COLUMNS WHERE table_name = t_name AND table_schema = 'openmrs_backup';

        SELECT GROUP_CONCAT(COLUMN_NAME) INTO t2_columns FROM INFORMATION_SCHEMA.COLUMNS WHERE table_name = t_name AND table_schema = 'openmrs';

        SELECT COUNT(*) INTO n FROM INFORMATION_SCHEMA.COLUMNS WHERE table_name = t_name AND table_schema = 'openmrs_backup' AND COLUMN_KEY = 'PRI';
        SET i=0;
        SET where_clause = '';
        WHILE i < n DO
          SELECT COLUMN_NAME INTO pri_col FROM INFORMATION_SCHEMA.COLUMNS WHERE table_name = t_name AND table_schema = 'openmrs_backup' AND COLUMN_KEY = 'PRI' LIMIT i,1;
          SET where_clause = CONCAT(where_clause,'openmrs_backup.',t_name,'.',pri_col,' not in (select ',pri_col,' from openmrs.',t_name,') AND ');
          SET i = i + 1;
        END WHILE;


        SELECT fn_intersect_string(t1_columns,t2_columns) INTO inter_columns;

        IF(inter_columns is not null AND inter_columns <> '') THEN
          IF t_name in ('encounter','obs','location_tag_map') THEN
            SET inter_columns_insert = REPLACE(inter_columns, 'location_id', '2');
          ELSE
            SET inter_columns_insert = inter_columns;
          END IF;
          SET @q_statment = CONCAT('insert into openmrs.',t_name,'(',inter_columns,') select ',inter_columns_insert,' from openmrs_backup.',t_name,if(where_clause <> '',CONCAT(' where ',SUBSTRING(where_clause, 1, CHAR_LENGTH(where_clause) - 4)),''));
        END IF;

        PREPARE stmt FROM @q_statment;
        EXECUTE stmt;
        DEALLOCATE PREPARE stmt;

      END LOOP;
      CLOSE cursor_i;



      UPDATE openmrs.location  AS c1, openmrs_backup.location AS c2 SET c1.location_id = c1.location_id, c1.name= c2.name,c1.description = c2.description,c1.address1 = c2.address1,c1.address2 = c2.address2,c1.city_village = c2.city_village,c1.state_province = c2.state_province,c1.postal_code =c1.postal_code,c1.country = c2.country,c1.latitude = c2.latitude,c1.longitude = c2.longitude ,c1.date_created = c2.date_created,c1.county_district = c2.county_district,c1.retired = c2.retired,c1.date_retired =c1.date_retired,c1.retire_reason = c2.retire_reason WHERE c2.location_id = 1  AND c1.location_id = 2;




      INSERT INTO provider (person_id, creator, date_created, uuid) SELECT person_id, 2, NOW(), UUID() FROM users u WHERE user_id NOT IN (SELECT user_id FROM user_role WHERE role = 'Provider');
      INSERT INTO user_role (user_id, role) SELECT user_id, 'Provider' FROM users u WHERE user_id NOT IN (SELECT user_id FROM user_role WHERE role = 'Provider') AND u.user_id IN (SELECT user_id FROM user_role WHERE (role = 'Data Manager' OR role = 'Data Entry'));


      SELECT COUNT(*) INTO provider_column FROM INFORMATION_SCHEMA.COLUMNS WHERE table_name = 'encounter' AND table_schema = 'openmrs_backup' AND COLUMN_NAME = 'provider_id';

      IF provider_column > 0 THEN
        INSERT INTO openmrs.encounter_provider(encounter_id,provider_id,encounter_role_id,creator,date_created,voided,uuid) select encounter_id,(select openmrs.provider.provider_id from openmrs.provider where person_id = openmrs_backup.encounter.provider_id),2,2,NOW(),0,UUID() from openmrs_backup.encounter;
      END IF;
    END$$
  DELIMITER ;
  DELIMITER $$
  CREATE DEFINER=`openmrs`@`localhost` FUNCTION `fn_intersect_string`(arg_str1 TEXT, arg_str2 TEXT) RETURNS text CHARSET utf8
  BEGIN
      SET arg_str1 = CONCAT(arg_str1, ",");
      SET @var_result = "";

      WHILE(INSTR(arg_str1, ",") > 0)
      DO
        SET @var_val = SUBSTRING_INDEX(arg_str1, ",", 1);
        SET arg_str1 = SUBSTRING(arg_str1, INSTR(arg_str1, ",") + 1);

        IF(FIND_IN_SET(@var_val, arg_str2) > 0)
        THEN
          SET @var_result = CONCAT(@var_result, @var_val, ",");
        END IF;
      END WHILE;

      RETURN TRIM(BOTH "," FROM @var_result);
    END$$
  DELIMITER ;

  DELIMITER $$
  CREATE DEFINER=`root`@`localhost` FUNCTION `get_adherence_Count`(AdherenceType INT, StartDate DATE, EndDate DATE) RETURNS int(11)
      DETERMINISTIC
  BEGIN
      DECLARE result INT DEFAULT -1;

      SELECT Adherence
      INTO result
      FROM (
             SELECT count(A.person_id) AS Adherence
             FROM (
                    SELECT
                      person_id,
                      obs_id,
                      max(obs_datetime)
                    FROM obs
                    WHERE concept_id = 90221 AND voided = 0
                          AND obs_datetime BETWEEN StartDate AND EndDate
                    GROUP BY person_id
                  ) A
           ) AA;
      RETURN result;
    END$$
  DELIMITER ;

  DELIMITER $$
  CREATE DEFINER=`root`@`localhost` FUNCTION `get_adherenceType_Count`(AdherenceType INT, StartDate DATE, EndDate DATE) RETURNS int(11)
      DETERMINISTIC
  BEGIN
      DECLARE result INT DEFAULT -1;

      SELECT Adherence
      INTO result
      FROM (
             SELECT count(A.person_id) AS Adherence
             FROM (
                    SELECT
                      person_id,
                      obs_id,
                      max(obs_datetime)
                    FROM obs
                    WHERE concept_id = 90221 AND voided = 0
                          AND obs_datetime BETWEEN StartDate AND EndDate
                    GROUP BY person_id
                  ) A
               INNER JOIN obs B ON A.obs_id = B.obs_id
             WHERE b.value_coded = AdherenceType
           ) AA;
      RETURN result;
    END$$
  DELIMITER ;

  DELIMITER $$
  CREATE DEFINER=`openmrs`@`localhost` FUNCTION `getADHStatusTxt`(patient_id INT, start_date DATE, end_date DATE) RETURNS char(1) CHARSET latin1
  BEGIN

      RETURN (SELECT if(value_coded = 90156, 'G',
                        if(value_coded = 90157, 'F',
                           if(value_coded = 90158, 'P', NULL))) AS adh_status
              FROM obs
              WHERE concept_id = 90221 AND person_id = patient_id AND obs_datetime BETWEEN start_date AND end_date AND
                    voided = 0
              LIMIT 1
      );
    END$$
  DELIMITER ;

  DELIMITER $$
  CREATE DEFINER=`root`@`localhost` FUNCTION `getAncNumberTxt`(`encounterid` INTEGER) RETURNS char(15) CHARSET latin1
      READS SQL DATA
  BEGIN


      RETURN (SELECT value_text
              FROM obs
              WHERE concept_id = 99026
                    AND encounterid = encounter_id
                    AND voided = 0
              LIMIT 1

      );
    END$$
  DELIMITER ;

  DELIMITER $$
  CREATE DEFINER=`root`@`localhost` FUNCTION `getAppKeepTxt`(`encounterid` INTEGER) RETURNS char(3) CHARSET latin1
      READS SQL DATA
  BEGIN


      RETURN (SELECT if(value_numeric = 1, "Y", "N") AS app_keep
              FROM obs
              WHERE concept_id = 90069
                    AND voided = 0
                    AND encounterid = encounter_id
              LIMIT 1

      );

    END$$
  DELIMITER ;

  DELIMITER $$
  CREATE DEFINER=`root`@`localhost` FUNCTION `getArtBaseTransferDate`(`personid` INTEGER) RETURNS date
      READS SQL DATA
  BEGIN


      RETURN
      (SELECT value_datetime
       FROM obs
       WHERE concept_id IN (99161, 99160)
             AND person_id = personid
             AND voided = 0
       LIMIT 1);


    END$$
  DELIMITER ;

  DELIMITER $$
  CREATE DEFINER=`root`@`localhost` FUNCTION `getArtEligibilityAndReadyDate`(`personid` INTEGER) RETURNS date
      READS SQL DATA
  BEGIN


      RETURN (SELECT value_datetime AS eligible_and_ready_date
              FROM obs
              WHERE concept_id = 90299
                    AND voided = 0
                    AND personid = person_id
              LIMIT 1
      );

    END$$
  DELIMITER ;

  DELIMITER $$
  CREATE DEFINER=`root`@`localhost` FUNCTION `getArtEligibilityDate`(`personid` INTEGER) RETURNS date
      READS SQL DATA
  BEGIN


      RETURN (SELECT value_datetime AS eligible_date
              FROM obs
              WHERE concept_id = 90297
                    AND voided = 0
                    AND personid = person_id
              LIMIT 1
      );

    END$$
  DELIMITER ;

  DELIMITER $$
  CREATE DEFINER=`root`@`localhost` FUNCTION `getArtEligibilityReasonTxt`(`personid` INTEGER) RETURNS char(15) CHARSET latin1
      READS SQL DATA
  BEGIN


      RETURN (SELECT if(concept_id = 99083, "Clinical",
                        if(concept_id = 99082 AND value_numeric >= 0, concat("CD4: ", value_numeric),
                           if(concept_id = 99123, "Presumptive",
                              if(concept_id = 99149, "PCR-Infant", ''
                              )))) AS e_reason
              FROM obs
              WHERE concept_id IN (99123, 99149, 99083, 99082)
                    AND voided = 0
                    AND personid = person_id
              LIMIT 1
      );

    END$$
  DELIMITER ;

  DELIMITER $$
  CREATE DEFINER=`root`@`localhost` FUNCTION `getArtRegCoded`(`encounterid` INTEGER) RETURNS char(12) CHARSET latin1
      READS SQL DATA
  BEGIN


      RETURN (SELECT value_coded AS freg
              FROM obs
              WHERE concept_id IN (99061, 90315)
                    AND voided = 0
                    AND encounterid = encounter_id
              LIMIT 1);
    END$$
  DELIMITER ;

  DELIMITER $$
  CREATE DEFINER=`root`@`localhost` FUNCTION `getArtRegCoded2`(`personid` INTEGER, `obsdatetime` DATE) RETURNS int(11)
      READS SQL DATA
  BEGIN


      RETURN (SELECT value_coded AS freg
              FROM obs
              WHERE concept_id IN (99061, 90315)
                    AND voided = 0
                    AND personid = person_id
                    AND obsdatetime = obs_datetime
              LIMIT 1);
    END$$
  DELIMITER ;

  DELIMITER $$
  CREATE DEFINER=`root`@`localhost` FUNCTION `getArtRegTxt`(`encounterid` INTEGER) RETURNS char(6) CHARSET latin1
      READS SQL DATA
  BEGIN


      RETURN (SELECT min(if(value_coded = 99015, '1a',
                            if(value_coded = 99016, '1b',
                               if(value_coded = 99005, '1c',
                                  if(value_coded = 99006, '1d',
                                     if(value_coded = 99039, '1e',
                                        if(value_coded = 99040, '1f',
                                           if(value_coded = 99041, '1g',
                                              if(value_coded = 99042, '1h',
                                                 if(value_coded = 99007, '2a2',
                                                    if(value_coded = 99008, '2a4',
                                                       if(value_coded = 99044, '2b',
                                                          if(value_coded = 99043, '2c',
                                                             if(value_coded = 99282, '2d2',
                                                                if(value_coded = 99283, '2d4',
                                                                   if(value_coded = 99046, '2e',
                                                                      if(value_coded = 99017, '5a',
                                                                         if(value_coded = 99018, '5b',
                                                                            if(value_coded = 99045, '5f',
                                                                               if(value_coded = 99284, '5g',
                                                                                  if(value_coded = 99285, '5h',
                                                                                     if(value_coded = 99286, '5j',
                                                                                        if(value_coded = 90002, 'othr', ''
                                                                                        ))))))))))))))))))))))) AS freg
              FROM obs
              WHERE concept_id IN (99061, 90315) AND voided = 0
                    AND encounterid = encounter_id
              LIMIT 1);
    END$$
  DELIMITER ;

  DELIMITER $$
  CREATE DEFINER=`root`@`localhost` FUNCTION `getArtRegTxt2`(`personid` INTEGER, `obsdatetime` DATE) RETURNS char(10) CHARSET latin1
      READS SQL DATA
  BEGIN


      RETURN (SELECT min(if(value_coded = 99015, '1a',
                            if(value_coded = 99016, '1b',
                               if(value_coded = 99005, '1c',
                                  if(value_coded = 99006, '1d',
                                     if(value_coded = 99039, '1e',
                                        if(value_coded = 99040, '1f',
                                           if(value_coded = 99041, '1g',
                                              if(value_coded = 99042, '1h',
                                                 if(value_coded = 99007, '2a2',
                                                    if(value_coded = 99008, '2a4',
                                                       if(value_coded = 99044, '2b',
                                                          if(value_coded = 99043, '2c',
                                                             if(value_coded = 99282, '2d2',
                                                                if(value_coded = 99283, '2d4',
                                                                   if(value_coded = 99046, '2e',
                                                                      if(value_coded = 99017, '5a',
                                                                         if(value_coded = 99018, '5b',
                                                                            if(value_coded = 99045, '5f',
                                                                               if(value_coded = 99284, '5g',
                                                                                  if(value_coded = 99285, '5h',
                                                                                     if(value_coded = 99286, '5j',
                                                                                        if(value_coded = 90002, 'othr', ''
                                                                                        ))))))))))))))))))))))) AS freg
              FROM obs
              WHERE concept_id IN (99061, 90315) AND voided = 0
                    AND personid = person_id
                    AND obsdatetime = obs_datetime
              LIMIT 1);
    END$$
  DELIMITER ;

  DELIMITER $$
  CREATE DEFINER=`root`@`localhost` FUNCTION `getArtRestartDate`(`personid` INTEGER, `encdt` CHAR(6)) RETURNS date
      READS SQL DATA
  BEGIN


      RETURN (
        SELECT value_datetime
        FROM obs
        WHERE concept_id = 99085
              AND voided = 0
              AND personid = person_id
              AND concat(year(value_datetime), month(value_datetime)) = encdt
        LIMIT 1
      );

    END$$
  DELIMITER ;

  DELIMITER $$
  CREATE DEFINER=`root`@`localhost` FUNCTION `getArtStartDate`(`personid` INTEGER) RETURNS date
      READS SQL DATA
  BEGIN


      RETURN
      (SELECT value_datetime
       FROM obs
       WHERE concept_id IN (99160, 99161)
             AND personid = person_id
             AND voided = 0
       ORDER BY value_datetime ASC
       LIMIT 1);


    END$$
  DELIMITER ;

  DELIMITER $$
  CREATE DEFINER=`root`@`localhost` FUNCTION `getArtStartDate2`(`personid` INTEGER, `reportdt` DATE) RETURNS date
      READS SQL DATA
  BEGIN


      RETURN
      (SELECT value_datetime
       FROM obs
       WHERE concept_id IN (99160, 99161)
             AND person_id = personid
             AND value_datetime <= reportdt
             AND voided = 0
       ORDER BY value_datetime ASC
       LIMIT 1);


    END$$
  DELIMITER ;

  DELIMITER $$
  CREATE DEFINER=`root`@`localhost` FUNCTION `getArtStartRegTxt`(`personid` INTEGER) RETURNS char(10) CHARSET latin1
      READS SQL DATA
  BEGIN


      RETURN (SELECT min(if(value_coded = 99015, '1a',
                            if(value_coded = 99016, '1b',
                               if(value_coded = 99005, '1c',
                                  if(value_coded = 99006, '1d',
                                     if(value_coded = 99039, '1e',
                                        if(value_coded = 99040, '1f',
                                           if(value_coded = 99041, '1g',
                                              if(value_coded = 99042, '1h',
                                                 if(value_coded = 99007, '2a2',
                                                    if(value_coded = 99008, '2a4',
                                                       if(value_coded = 99044, '2b',
                                                          if(value_coded = 99043, '2c',
                                                             if(value_coded = 99282, '2d2',
                                                                if(value_coded = 99283, '2d4',
                                                                   if(value_coded = 99046, '2e',
                                                                      if(value_coded = 99017, '5a',
                                                                         if(value_coded = 99018, '5b',
                                                                            if(value_coded = 99045, '5f',
                                                                               if(value_coded = 99284, '5g',
                                                                                  if(value_coded = 99285, '5h',
                                                                                     if(value_coded = 99286, '5j',
                                                                                        if(value_coded = 90002, 'othr', ''
                                                                                        ))))))))))))))))))))))) AS freg
              FROM obs
              WHERE concept_id IN (99061, 99064) AND voided = 0
                    AND personid = person_id
              LIMIT 1);
    END$$
  DELIMITER ;

  DELIMITER $$
  CREATE DEFINER=`root`@`localhost` FUNCTION `getArtStopDate`(`personid` INTEGER, `obsdatetime` DATE) RETURNS date
      READS SQL DATA
  BEGIN


      RETURN
      (
        SELECT value_datetime
        FROM obs
        WHERE
          concept_id = 99084 AND voided = 0
          AND personid = person_id
          AND obsdatetime = value_datetime
        LIMIT 1);


    END$$
  DELIMITER ;

  DELIMITER $$
  CREATE DEFINER=`root`@`localhost` FUNCTION `getArtStopDate1`(`personid` INTEGER, `encdt` CHAR(6)) RETURNS date
      READS SQL DATA
  BEGIN


      RETURN (
        SELECT value_datetime
        FROM obs
        WHERE concept_id = 99084
              AND voided = 0
              AND personid = person_id
              AND
              encdt = concat(year(value_datetime), month(value_datetime))
        LIMIT 1
      );

    END$$
  DELIMITER ;

  DELIMITER $$
  CREATE DEFINER=`root`@`localhost` FUNCTION `getArtStopReasonTxt`(`personid` INTEGER, `encdt` CHAR) RETURNS char(2) CHARSET latin1
      READS SQL DATA
  BEGIN


      RETURN (
        SELECT if(a.value_coded = 90040, "1",
                  if(a.value_coded = 90041, "2",
                     if(a.value_coded = 90046, "3",
                        if(a.value_coded = 90049, "4",
                           if(a.value_coded = 90050, "5",
                              if(a.value_coded = 90045, "6",
                                 if(a.value_coded = 90051, "7",
                                    if(a.value_coded = 90052, "8",
                                       if(a.value_coded = 90066, "9",
                                          if(a.value_coded = 90002, "10",
                                             if(a.value_coded = 99289, "11", ''))))))))))) stop_r


        FROM obs a, obs b
        WHERE b.concept_id = 99084
              AND a.voided = 0
              AND b.voided = 0
              AND a.concept_id = 1252
              AND a.obs_group_id = b.obs_group_id
              AND personid = b.person_id
              AND encdt = concat(year(b.value_datetime), month(b.value_datetime))
        LIMIT 1

      );

    END$$
  DELIMITER ;

  DELIMITER $$
  CREATE DEFINER=`root`@`localhost` FUNCTION `getBaseWeightValue`(`personid` INTEGER, `artstartdt` DATE) RETURNS int(11)
      READS SQL DATA
  BEGIN


      RETURN (SELECT if(concept_id = 99069, value_numeric,
                        if(concept_id = 90236 AND obs_datetime = artstartdt, value_numeric, NULL)) wt
              FROM obs
              WHERE concept_id IN (99069, 90236)
                    AND personid = person_id
                    AND voided = 0
              HAVING wt IS NOT NULL
              LIMIT 1
      );

    END$$
  DELIMITER ;

  DELIMITER $$
  CREATE DEFINER=`root`@`localhost` FUNCTION `getCareEntryTxt`(`personid` INT) RETURNS char(15) CHARSET latin1
      READS SQL DATA
  BEGIN


      RETURN (SELECT if(value_coded = 90012, "eMTCT",
                        if(value_coded = 90013, "Outpatient",
                           if(value_coded = 99593, "YCC",
                              if(value_coded = 90016, "TB",
                                 if(value_coded = 90015, "STI",
                                    if(value_coded = 90018, "Inpatient",
                                       if(value_coded = 90019, "Outreach",
                                          if(value_coded = 99087, "Exposed Infant",
                                             if(value_coded = 99002, "Other",
                                                if(value_coded = 99610, "SMC", '')))))))))) AS care_entry
              FROM obs
              WHERE concept_id = 90200
                    AND voided = 0
                    AND personid = person_id
              LIMIT 1
      );

    END$$
  DELIMITER ;

  DELIMITER $$
  CREATE DEFINER=`root`@`localhost` FUNCTION `getCd4BaseValue`(`personid` INTEGER, `artstartdt` DATE) RETURNS int(11)
      READS SQL DATA
  BEGIN


      RETURN (SELECT if(concept_id = 99071, value_numeric,
                        if(concept_id = 5497 AND datediff(artstartdt, obs_datetime) BETWEEN 0 AND 31, value_numeric,
                           NULL)) AS bcd4
              FROM obs
              WHERE concept_id IN (99071, 5497)
                    AND voided = 0
                    AND personid = person_id
                    AND artstartdt = artstartdt
              HAVING bcd4 IS NOT NULL
              LIMIT 1
      );
    END$$
  DELIMITER ;

  DELIMITER $$
  CREATE DEFINER=`root`@`localhost` FUNCTION `get_CD4_count`(StartDate VARCHAR(12), EndDate VARCHAR(12), Patient_ID INTEGER) RETURNS varchar(10) CHARSET latin1
      DETERMINISTIC
  RETURN
    (
      SELECT IFNULL(CD4Count, CD4Percentage) AS CD4_Count
      FROM (
             SELECT
               (SELECT value_numeric
                FROM obs
                WHERE concept_id = 5497 AND person_id = LatestEncounter.patient_id AND
                      encounter_id = LatestEncounter.encounter_id) AS CD4Count,
               (SELECT value_numeric
                FROM obs
                WHERE concept_id = 730 AND person_id = LatestEncounter.patient_id AND
                      encounter_id = LatestEncounter.encounter_id) AS CD4Percentage
             FROM (
                    SELECT
                      patient_id,
                      max(encounter_datetime),
                      encounter_id
                    FROM encounter
                    WHERE
                      encounter_datetime BETWEEN str_to_date(StartDate, "%d/%m/%Y") AND str_to_date(EndDate, "%d/%m/%Y")
                      AND patient_id = Patient_ID AND form_id = (select form_id from form where locate('art',name) > 0 and locate('card',name) > 0 and locate('encounter',name) > 0)
                    GROUP BY patient_id
                  ) LatestEncounter
           ) CD4
    )$$
  DELIMITER ;

  DELIMITER $$
  CREATE DEFINER=`root`@`localhost` FUNCTION `getCd4SevereBaseValue`(`personid` INTEGER, `artstartdt` DATE) RETURNS int(11)
      READS SQL DATA
  BEGIN


      RETURN (SELECT if(value_coded = 99150 AND datediff(artstartdt, obs_datetime) BETWEEN 0 AND 31, 0, NULL) AS bsevere
              FROM obs
              WHERE concept_id = 99151
                    AND voided = 0
                    AND personid = person_id
                    AND artstartdt = artstartdt
              LIMIT 1
      );
    END$$
  DELIMITER ;

  DELIMITER $$
  CREATE DEFINER=`root`@`localhost` FUNCTION `getCD4Value`(`personid` INTEGER, `obsdatetime` DATE) RETURNS int(11)
      READS SQL DATA
  BEGIN


      RETURN (SELECT value_numeric
              FROM obs
              WHERE concept_id IN
                    (99071, 5497)
                    AND voided = 0
                    AND obsdatetime = obs_datetime
                    AND personid = person_id
              LIMIT 1
      );
    END$$
  DELIMITER ;

  DELIMITER $$
  CREATE DEFINER=`root`@`localhost` FUNCTION `getCodedDeathDate`(`personid` INTEGER) RETURNS date
      READS SQL DATA
  BEGIN


      RETURN (SELECT value_datetime
              FROM obs
              WHERE concept_id = 90272 AND voided = 0
                    AND personid = person_id
              LIMIT 1
      );

    END$$
  DELIMITER ;

  DELIMITER $$
  CREATE DEFINER=`root`@`localhost` FUNCTION `getCohortAllBefore10`(start_year INT, start_quarter INT, months_before INT,
                                                                    only_preg  TINYINT(1)) RETURNS int(11)
  BEGIN

      DECLARE number_on_cohort INT;
      DECLARE pregnant_mothers TEXT;
      DECLARE people_started TEXT;

      SELECT group_concat(distinct person_id) into people_started FROM obs oi WHERE oi.voided = 0 AND oi.concept_id = 99161 and oi.value_datetime BETWEEN MAKEDATE(start_year, 1) + INTERVAL start_quarter - 1 QUARTER - INTERVAL months_before MONTH AND MAKEDATE(start_year, 1) + INTERVAL start_quarter QUARTER - INTERVAL months_before MONTH - INTERVAL 1 DAY;

      IF (only_preg = 0) THEN

        SELECT COUNT(distinct o.person_id) INTO number_on_cohort FROM obs o WHERE o.voided = 0 AND o.concept_id = 99112 AND o.value_coded = 90003 AND FIND_IN_SET(o.person_id, people_started);

      ELSEIF (only_preg = 1) THEN
        select group_concat(person_id) INTO pregnant_mothers from obs where concept_id = 90012 and value_coded = 90003 AND voided = 0;

        SELECT COUNT(distinct o.person_id) INTO number_on_cohort FROM obs o WHERE o.voided = 0 AND o.concept_id = 99112 AND o.value_coded = 90003 AND FIND_IN_SET(o.person_id, people_started) AND FIND_IN_SET(o.person_id, pregnant_mothers);

      END IF;

      RETURN number_on_cohort;
    END$$
  DELIMITER ;

  DELIMITER $$
  CREATE DEFINER=`root`@`localhost` FUNCTION `getCohortAllBefore11`(start_year INTEGER, start_quarter INT, months_before INTEGER,
                                                                    only_preg  TINYINT(1)) RETURNS int(11)
  BEGIN

      RETURN 0;
    END$$
  DELIMITER ;

  DELIMITER $$
  CREATE DEFINER=`root`@`localhost` FUNCTION `getCohortAllBefore12`(start_year INTEGER, start_quarter INTEGER, months_before INTEGER,
                                                                    only_preg  TINYINT(1)) RETURNS int(11)
  BEGIN
      DECLARE number_on_cohort INT;
      DECLARE pregnant_mothers TEXT;
      DECLARE people_started TEXT;

      SELECT group_concat(distinct person_id) into people_started FROM obs oi WHERE oi.voided = 0 AND oi.concept_id = 99161 and oi.value_datetime BETWEEN MAKEDATE(start_year, 1) + INTERVAL start_quarter - 1 QUARTER - INTERVAL months_before MONTH AND MAKEDATE(start_year, 1) + INTERVAL start_quarter QUARTER - INTERVAL months_before MONTH - INTERVAL 1 DAY;

      IF (only_preg = 0) THEN

        SELECT COUNT(*) INTO number_on_cohort FROM obs o WHERE o.voided = 0 AND o.concept_id = 99132 AND o.value_coded = 99133 AND FIND_IN_SET(o.person_id, people_started);

      ELSEIF (only_preg = 1) THEN
        select group_concat(person_id) INTO pregnant_mothers from obs where concept_id = 90012 and value_coded = 90003 AND voided = 0;

        SELECT COUNT(*) INTO number_on_cohort FROM obs o WHERE o.voided = 0 AND o.concept_id = 99132 AND o.value_coded = 99133 AND FIND_IN_SET(o.person_id, people_started) AND FIND_IN_SET(o.person_id, pregnant_mothers);

      END IF;

      RETURN number_on_cohort;
    END$$
  DELIMITER ;

  DELIMITER $$
  CREATE DEFINER=`root`@`localhost` FUNCTION `getCohortAllBefore15a`(start_year    INTEGER, start_quarter INTEGER,
                                                                     months_before INTEGER, only_preg TINYINT(1)) RETURNS int(11)
  BEGIN
      DECLARE number_on_cohort INT;
      DECLARE pregnant_mothers TEXT;
      DECLARE people_started TEXT;

      SELECT group_concat(distinct person_id) into people_started FROM obs oi WHERE oi.voided = 0 AND oi.concept_id = 99161 and oi.value_datetime BETWEEN MAKEDATE(start_year, 1) + INTERVAL start_quarter - 1 QUARTER - INTERVAL months_before MONTH AND MAKEDATE(start_year, 1) + INTERVAL start_quarter QUARTER - INTERVAL months_before MONTH - INTERVAL 1 DAY;

      IF (only_preg = 0)
      THEN
        SELECT COUNT(*) INTO number_on_cohort FROM person pp INNER JOIN obs o ON (pp.person_id = o.person_id AND TIMESTAMPDIFF(YEAR,pp.birthdate, (MAKEDATE(start_year,1) + INTERVAL start_quarter QUARTER - INTERVAL 1 DAY)) >= 5 AND o.voided = 0 AND o.concept_id = 99071 AND o.value_numeric < 250 AND FIND_IN_SET(o.person_id, people_started));

      ELSEIF (only_preg = 1) THEN
        select group_concat(person_id) INTO pregnant_mothers from obs where concept_id = 90012 and value_coded = 90003 AND voided = 0;
        SELECT COUNT(*) INTO number_on_cohort FROM person pp INNER JOIN obs o ON (pp.person_id = o.person_id AND TIMESTAMPDIFF(YEAR,pp.birthdate, (MAKEDATE(start_year,1) + INTERVAL start_quarter QUARTER - INTERVAL 1 DAY)) >= 5 AND o.voided = 0 AND o.concept_id = 99071 AND o.value_numeric < 250 AND FIND_IN_SET(o.person_id, people_started)) AND FIND_IN_SET(o.person_id, only_preg);

      END IF;

      RETURN number_on_cohort;
    END$$
  DELIMITER ;

  DELIMITER $$
  CREATE DEFINER=`root`@`localhost` FUNCTION `getCohortAllBefore15b`(start_year    INTEGER, start_quarter INT,
                                                                     months_before INTEGER, only_preg TINYINT(1)) RETURNS int(11)
  BEGIN
      DECLARE number_on_cohort INT;
      DECLARE pregnant_mothers TEXT;
      DECLARE people_started TEXT;

      SELECT group_concat(distinct person_id) into people_started FROM obs oi WHERE oi.voided = 0 AND oi.concept_id = 99161 and oi.value_datetime BETWEEN MAKEDATE(start_year, 1) + INTERVAL start_quarter - 1 QUARTER - INTERVAL months_before MONTH AND MAKEDATE(start_year, 1) + INTERVAL start_quarter QUARTER - INTERVAL months_before MONTH - INTERVAL 1 DAY;

      IF (only_preg = 0)
      THEN
        SELECT COUNT(*) INTO number_on_cohort FROM person pp INNER JOIN obs o ON (pp.person_id = o.person_id AND TIMESTAMPDIFF(YEAR,pp.birthdate, (MAKEDATE(start_year,1) + INTERVAL start_quarter QUARTER - INTERVAL 1 DAY)) >= 5 AND o.voided = 0 AND o.concept_id = 99071 AND FIND_IN_SET(o.person_id, people_started));

      ELSEIF (only_preg = 1) THEN
        select group_concat(person_id) INTO pregnant_mothers from obs where concept_id = 90012 and value_coded = 90003 AND voided = 0;
        SELECT COUNT(*) INTO number_on_cohort FROM person pp INNER JOIN obs o ON (pp.person_id = o.person_id AND TIMESTAMPDIFF(YEAR,pp.birthdate, (MAKEDATE(start_year,1) + INTERVAL start_quarter QUARTER - INTERVAL 1 DAY)) >= 5 AND o.voided = 0 AND o.concept_id = 99071 AND FIND_IN_SET(o.person_id, people_started)) AND FIND_IN_SET(o.person_id, only_preg);

      END IF;

      RETURN number_on_cohort;
    END$$
  DELIMITER ;

  DELIMITER $$
  CREATE DEFINER=`root`@`localhost` FUNCTION `getCohortAllBefore16`(start_year INTEGER, start_quarter INTEGER, months_before INTEGER,
                                                                    only_preg  TINYINT(1)) RETURNS int(11)
  BEGIN
      DECLARE number_on_cohort INT;
      DECLARE pregnant_mothers TEXT;
      DECLARE people_started TEXT;

      SELECT group_concat(distinct person_id) into people_started FROM obs oi WHERE oi.voided = 0 AND oi.concept_id = 99161 and oi.value_datetime BETWEEN MAKEDATE(start_year, 1) + INTERVAL start_quarter - 1 QUARTER - INTERVAL months_before MONTH AND MAKEDATE(start_year, 1) + INTERVAL start_quarter QUARTER - INTERVAL months_before MONTH - INTERVAL 1 DAY;


      IF (only_preg = 0) THEN
        SELECT AVG(t1.value_numeric) AS median_val
        INTO number_on_cohort
        FROM
          (SELECT
             @rownum := @rownum + 1 AS `row_number`,
             o.value_numeric
           FROM
             obs o
             , (SELECT @rownum := 0) r
           WHERE
             o.value_numeric > 0
             AND o.concept_id = 99071
             AND FIND_IN_SET(o.person_id, people_started)
           ORDER BY o.value_numeric) AS t1,
          (SELECT COUNT(*) AS total_rows
           FROM
             obs o
           WHERE
             o.value_numeric > 0
             AND o.concept_id = 99071
             AND FIND_IN_SET(o.person_id, people_started)) AS t2
        WHERE
          t1.row_number IN (FLOOR((total_rows + 1) / 2), FLOOR((total_rows + 2) / 2));
      ELSEIF (only_preg = 1) THEN
        select group_concat(person_id) INTO pregnant_mothers from obs where concept_id = 90012 and value_coded = 90003 AND voided = 0;
        SELECT AVG(t1.value_numeric) AS median_val
        INTO number_on_cohort
        FROM
          (SELECT
             @rownum := @rownum + 1 AS `row_number`,
             o.value_numeric
           FROM
             obs o
             , (SELECT @rownum := 0) r
           WHERE
             o.value_numeric > 0
             AND o.concept_id = 99071
             AND FIND_IN_SET(o.person_id, people_started)
             AND FIND_IN_SET(o.person_id, only_preg)
           ORDER BY o.value_numeric) AS t1,
          (SELECT COUNT(*) AS total_rows
           FROM
             obs o
           WHERE
             o.value_numeric > 0
             AND o.concept_id = 99071
             AND FIND_IN_SET(o.person_id, people_started
                                          AND FIND_IN_SET(o.person_id, only_preg))) AS t2
        WHERE
          t1.row_number IN (FLOOR((total_rows + 1) / 2), FLOOR((total_rows + 2) / 2));

      END IF;


      RETURN number_on_cohort;
    END$$
  DELIMITER ;

  DELIMITER $$
  CREATE DEFINER=`root`@`localhost` FUNCTION `getCohortAllBefore3`(start_year INT, start_quarter INTEGER, months_before INTEGER,
                                                                   only_preg  TINYINT(1)) RETURNS int(11)
  BEGIN

      DECLARE number_on_cohort INT;
      DECLARE pregnant_mothers TEXT;
      DECLARE people_started TEXT;

      SELECT group_concat(distinct person_id) into people_started FROM obs oi WHERE oi.voided = 0 AND oi.concept_id = 99161 and oi.value_datetime BETWEEN MAKEDATE(start_year, 1) + INTERVAL start_quarter - 1 QUARTER - INTERVAL months_before MONTH AND MAKEDATE(start_year, 1) + INTERVAL start_quarter QUARTER - INTERVAL months_before MONTH - INTERVAL 1 DAY;

      IF (only_preg = 0) THEN
        SELECT COUNT(distinct o.person_id) INTO number_on_cohort FROM obs o WHERE o.voided = 0 AND o.person_id not in (select distinct person_id from obs where concept_id = 99110) AND o.obs_datetime BETWEEN MAKEDATE(start_year, 1) + INTERVAL start_quarter - 1 QUARTER - INTERVAL months_before MONTH AND MAKEDATE(start_year, 1) + INTERVAL start_quarter QUARTER - INTERVAL months_before MONTH - INTERVAL 1 DAY AND FIND_IN_SET(o.person_id, people_started) ;
      ELSEIF (only_preg = 1) THEN
        select group_concat(distinct person_id) INTO pregnant_mothers from obs where concept_id = 90012 and value_coded = 90003 AND voided = 0;
        SELECT COUNT(distinct o.person_id) INTO number_on_cohort FROM obs o WHERE o.voided = 0 AND o.person_id not in (select distinct person_id from obs where concept_id = 99110) AND o.obs_datetime BETWEEN MAKEDATE(start_year, 1) + INTERVAL start_quarter - 1 QUARTER - INTERVAL months_before MONTH AND MAKEDATE(start_year, 1) + INTERVAL start_quarter QUARTER - INTERVAL months_before MONTH - INTERVAL 1 DAY AND FIND_IN_SET(o.person_id, people_started) AND FIND_IN_SET(o.person_id, pregnant_mothers) ;
      END IF;


      RETURN number_on_cohort;
    END$$
  DELIMITER ;

  DELIMITER $$
  CREATE DEFINER=`root`@`localhost` FUNCTION `getCohortAllBefore4a`(start_year INTEGER, start_quarter INTEGER, months_before INTEGER,
                                                                    only_preg  TINYINT(1)) RETURNS int(11)
  BEGIN
      DECLARE number_on_cohort INT;
      DECLARE pregnant_mothers TEXT;
      DECLARE people_started TEXT;

      SELECT group_concat(distinct oi.person_id) into people_started FROM obs oi WHERE oi.voided = 0 AND oi.concept_id = 99161 and oi.value_datetime BETWEEN MAKEDATE(start_year, 1) + INTERVAL start_quarter - 1 QUARTER - INTERVAL months_before MONTH AND MAKEDATE(start_year, 1) + INTERVAL start_quarter QUARTER - INTERVAL months_before MONTH - INTERVAL 1 DAY;

      IF (only_preg = 0)
      THEN
        SELECT COUNT(distinct o.person_id) INTO number_on_cohort FROM person pp INNER JOIN obs o ON (pp.person_id = o.person_id AND TIMESTAMPDIFF(YEAR,pp.birthdate, (MAKEDATE(start_year,1) + INTERVAL start_quarter QUARTER - INTERVAL 1 DAY)) >= 5 AND o.voided = 0 AND o.concept_id = 99071 AND o.obs_datetime BETWEEN MAKEDATE(start_year, 1) + INTERVAL start_quarter - 1 QUARTER - INTERVAL months_before MONTH AND MAKEDATE(start_year, 1) + INTERVAL start_quarter QUARTER - INTERVAL months_before MONTH - INTERVAL 1 DAY AND o.value_numeric < 250 AND FIND_IN_SET(o.person_id, people_started));

      ELSEIF (only_preg = 1) THEN
        select group_concat(distinct person_id) INTO pregnant_mothers from obs where concept_id = 90012 and value_coded = 90003 AND voided = 0;
        SELECT COUNT(distinct o.person_id) INTO number_on_cohort FROM person pp INNER JOIN obs o ON (pp.person_id = o.person_id AND TIMESTAMPDIFF(YEAR,pp.birthdate, (MAKEDATE(start_year,1) + INTERVAL start_quarter QUARTER - INTERVAL 1 DAY)) >= 5 AND o.voided = 0 AND o.concept_id = 99071 AND o.obs_datetime BETWEEN MAKEDATE(start_year, 1) + INTERVAL start_quarter - 1 QUARTER - INTERVAL months_before MONTH AND MAKEDATE(start_year, 1) + INTERVAL start_quarter QUARTER - INTERVAL months_before MONTH - INTERVAL 1 DAY AND o.value_numeric < 250 AND FIND_IN_SET(o.person_id, people_started)) AND FIND_IN_SET(o.person_id, only_preg);

      END IF;

      RETURN number_on_cohort;
    END$$
  DELIMITER ;

  DELIMITER $$
  CREATE DEFINER=`root`@`localhost` FUNCTION `getCohortAllBefore4b`(start_year INTEGER, start_quarter INTEGER, months_before INTEGER, only_preg  TINYINT(1)) RETURNS int(11)
  BEGIN
      DECLARE number_on_cohort INT;
      DECLARE pregnant_mothers TEXT;
      DECLARE people_started TEXT;

      SELECT group_concat(distinct oi.person_id) into people_started FROM obs oi WHERE oi.voided = 0 AND oi.concept_id = 99161 and oi.value_datetime BETWEEN MAKEDATE(start_year, 1) + INTERVAL start_quarter - 1 QUARTER - INTERVAL months_before MONTH AND MAKEDATE(start_year, 1) + INTERVAL start_quarter QUARTER - INTERVAL months_before MONTH - INTERVAL 1 DAY;

      IF (only_preg = 0)
      THEN
        SELECT COUNT(distinct o.person_id) INTO number_on_cohort FROM person pp INNER JOIN obs o ON (pp.person_id = o.person_id AND TIMESTAMPDIFF(YEAR,pp.birthdate, (MAKEDATE(start_year,1) + INTERVAL start_quarter QUARTER - INTERVAL 1 DAY)) >= 5 AND o.voided = 0 AND o.concept_id = 99071 AND o.obs_datetime BETWEEN MAKEDATE(start_year, 1) + INTERVAL start_quarter - 1 QUARTER - INTERVAL months_before MONTH AND MAKEDATE(start_year, 1) + INTERVAL start_quarter QUARTER - INTERVAL months_before MONTH - INTERVAL 1 DAY AND FIND_IN_SET(o.person_id, people_started));

      ELSEIF (only_preg = 1) THEN
        select group_concat(distinct person_id) INTO pregnant_mothers from obs where concept_id = 90012 and value_coded = 90003 AND voided = 0;
        SELECT COUNT(distinct o.person_id) INTO number_on_cohort FROM person pp INNER JOIN obs o ON (pp.person_id = o.person_id AND TIMESTAMPDIFF(YEAR,pp.birthdate, (MAKEDATE(start_year,1) + INTERVAL start_quarter QUARTER - INTERVAL 1 DAY)) >= 5 AND o.voided = 0 AND o.concept_id = 99071 AND o.obs_datetime BETWEEN MAKEDATE(start_year, 1) + INTERVAL start_quarter - 1 QUARTER - INTERVAL months_before MONTH AND MAKEDATE(start_year, 1) + INTERVAL start_quarter QUARTER - INTERVAL months_before MONTH - INTERVAL 1 DAY AND FIND_IN_SET(o.person_id, people_started)) AND FIND_IN_SET(o.person_id, only_preg);

      END IF;

      RETURN number_on_cohort;
    END$$
  DELIMITER ;

  DELIMITER $$
  CREATE DEFINER=`root`@`localhost` FUNCTION `getCohortAllBefore5`(start_year INTEGER, start_quarter INTEGER, months_before INTEGER,
                                                                   only_preg  TINYINT(1)) RETURNS int(11)
  BEGIN
      DECLARE number_on_cohort INT;
      DECLARE pregnant_mothers TEXT;
      DECLARE people_started TEXT;

      SELECT group_concat(distinct person_id) into people_started FROM obs oi WHERE oi.voided = 0 AND oi.concept_id = 99161 and oi.value_datetime BETWEEN MAKEDATE(start_year, 1) + INTERVAL start_quarter - 1 QUARTER - INTERVAL months_before MONTH AND MAKEDATE(start_year, 1) + INTERVAL start_quarter QUARTER - INTERVAL months_before MONTH - INTERVAL 1 DAY;


      IF (only_preg = 0) THEN
        SELECT AVG(t1.value_numeric) AS median_val
        INTO number_on_cohort
        FROM
          (SELECT
             @rownum := @rownum + 1 AS `row_number`,
             o.value_numeric
           FROM
             obs o
             , (SELECT @rownum := 0) r
           WHERE
             o.value_numeric > 0
             AND o.concept_id = 99071
             AND FIND_IN_SET(o.person_id, people_started)
           ORDER BY o.value_numeric) AS t1,
          (SELECT COUNT(*) AS total_rows
           FROM
             obs o
           WHERE
             o.value_numeric > 0
             AND o.concept_id = 99071
             AND FIND_IN_SET(o.person_id, people_started)
             AND o.obs_datetime BETWEEN MAKEDATE(start_year, 1) + INTERVAL start_quarter - 1 QUARTER - INTERVAL months_before MONTH AND MAKEDATE(start_year, 1) + INTERVAL start_quarter QUARTER - INTERVAL months_before MONTH - INTERVAL 1 DAY) AS t2
        WHERE
          t1.row_number IN (FLOOR((total_rows + 1) / 2), FLOOR((total_rows + 2) / 2));
      ELSEIF (only_preg = 1) THEN
        select group_concat(distinct person_id) INTO pregnant_mothers from obs where concept_id = 90012 and value_coded = 90003 AND voided = 0;
        SELECT AVG(t1.value_numeric) AS median_val
        INTO number_on_cohort
        FROM
          (SELECT
             @rownum := @rownum + 1 AS `row_number`,
             o.value_numeric
           FROM
             obs o
             , (SELECT @rownum := 0) r
           WHERE
             o.value_numeric > 0
             AND o.concept_id = 99071
             AND FIND_IN_SET(o.person_id, people_started)
             AND FIND_IN_SET(o.person_id, only_preg)
           ORDER BY o.value_numeric) AS t1,
          (SELECT COUNT(*) AS total_rows
           FROM
             obs o
           WHERE
             o.value_numeric > 0
             AND o.concept_id = 99071
             AND o.obs_datetime BETWEEN MAKEDATE(start_year, 1) + INTERVAL start_quarter - 1 QUARTER - INTERVAL months_before MONTH AND MAKEDATE(start_year, 1) + INTERVAL start_quarter QUARTER - INTERVAL months_before MONTH - INTERVAL 1 DAY
             AND FIND_IN_SET(o.person_id, people_started
                                          AND FIND_IN_SET(o.person_id, only_preg))) AS t2
        WHERE
          t1.row_number IN (FLOOR((total_rows + 1) / 2), FLOOR((total_rows + 2) / 2));

      END IF;


      RETURN number_on_cohort;
    END$$
  DELIMITER ;

  DELIMITER $$
  CREATE DEFINER=`root`@`localhost` FUNCTION `getCohortAllBefore6`(start_year INTEGER, start_quarter INTEGER, months_before INTEGER,
                                                                   only_preg  TINYINT(1)) RETURNS int(11)
  BEGIN
      DECLARE number_on_cohort INT;
      DECLARE pregnant_mothers TEXT;
      DECLARE people_started TEXT;

      SELECT group_concat(distinct person_id) into people_started FROM obs oi WHERE oi.voided = 0 AND oi.concept_id = 99161 and oi.value_datetime BETWEEN MAKEDATE(start_year, 1) + INTERVAL start_quarter - 1 QUARTER - INTERVAL months_before MONTH AND MAKEDATE(start_year, 1) + INTERVAL start_quarter QUARTER - INTERVAL months_before MONTH - INTERVAL 1 DAY;

      IF (only_preg = 0) THEN
        SELECT COUNT(distinct o.person_id) INTO number_on_cohort FROM obs o WHERE o.voided = 0 AND o.concept_id = 99110 AND o.value_coded = 90003 AND FIND_IN_SET(o.person_id, people_started);
      ELSEIF (only_preg = 1) THEN
        select group_concat(person_id) INTO pregnant_mothers from obs where concept_id = 90012 and value_coded = 90003 AND voided = 0;
        SELECT COUNT(distinct o.person_id) INTO number_on_cohort FROM obs o WHERE o.voided = 0 AND o.concept_id = 99110 AND o.value_coded = 90003 AND FIND_IN_SET(o.person_id, people_started) AND FIND_IN_SET(o.person_id, only_preg);
      END IF;
      RETURN number_on_cohort;
    END$$
  DELIMITER ;

  DELIMITER $$
  CREATE DEFINER=`root`@`localhost` FUNCTION `getCohortAllBefore7`(start_year INT, start_quarter INTEGER, months_before INTEGER, only_preg  TINYINT(1)) RETURNS int(11)
  BEGIN
      DECLARE number_on_cohort INT;
      DECLARE pregnant_mothers TEXT;
      DECLARE people_started TEXT;

      SELECT group_concat(person_id) into people_started FROM obs oi WHERE oi.voided = 0 AND oi.concept_id = 99161 and oi.value_datetime BETWEEN MAKEDATE(start_year, 1) + INTERVAL start_quarter - 1 QUARTER - INTERVAL months_before MONTH AND MAKEDATE(start_year, 1) + INTERVAL start_quarter QUARTER - INTERVAL months_before MONTH - INTERVAL 1 DAY;

      IF (only_preg = 0) THEN

        SELECT COUNT(distinct o.person_id) INTO number_on_cohort FROM obs o WHERE o.voided = 0 AND o.concept_id = 99165 AND FIND_IN_SET(o.person_id, people_started);

      ELSEIF (only_preg = 1) THEN
        select group_concat(distinct person_id) INTO pregnant_mothers from obs where concept_id = 90012 and value_coded = 90003 AND voided = 0;

        SELECT COUNT(distinct o.person_id) INTO number_on_cohort FROM obs o WHERE  o.voided = 0 AND o.concept_id = 99165 AND FIND_IN_SET(o.person_id, people_started) AND FIND_IN_SET(o.person_id, only_preg);

      END IF;

      RETURN number_on_cohort;
    END$$
  DELIMITER ;

  DELIMITER $$
  CREATE DEFINER=`root`@`localhost` FUNCTION `getCohortAllBefore9`(start_year INTEGER, start_quarter INT, months_before INT,
                                                                   only_preg  TINYINT(1)) RETURNS int(11)
  BEGIN
      DECLARE number_on_cohort INT;
      DECLARE pregnant_mothers TEXT;
      DECLARE people_started TEXT;

      SELECT group_concat(distinct person_id) into people_started FROM obs oi WHERE oi.voided = 0 AND oi.concept_id = 99161 and oi.value_datetime BETWEEN MAKEDATE(start_year, 1) + INTERVAL start_quarter - 1 QUARTER - INTERVAL months_before MONTH AND MAKEDATE(start_year, 1) + INTERVAL start_quarter QUARTER - INTERVAL months_before MONTH - INTERVAL 1 DAY;

      IF (only_preg = 0) THEN

        SELECT COUNT(distinct o.person_id) INTO number_on_cohort FROM obs o WHERE o.voided = 0 AND o.concept_id = 99132 AND o.value_coded = 1363 AND FIND_IN_SET(o.person_id, people_started);

      ELSEIF (only_preg = 1) THEN
        select group_concat(distinct person_id) INTO pregnant_mothers from obs where concept_id = 90012 and value_coded = 90003 AND voided = 0;

        SELECT COUNT(distinct o.person_id) INTO number_on_cohort FROM obs o WHERE o.voided = 0 AND o.concept_id = 99132 AND o.value_coded = 1363 AND FIND_IN_SET(o.person_id, people_started) AND FIND_IN_SET(o.person_id, pregnant_mothers);

      END IF;

      RETURN number_on_cohort;
    END$$
  DELIMITER ;

  DELIMITER $$
  CREATE DEFINER=`openmrs`@`localhost` FUNCTION `getCohortMonth`(start_year INT, start_quarter INT, months_before INT) RETURNS char(30) CHARSET latin1
  BEGIN
      DECLARE end_date DATE DEFAULT
        MAKEDATE(start_year, 1) + INTERVAL start_quarter QUARTER - INTERVAL months_before MONTH - INTERVAL 1 DAY;
      DECLARE start_date DATE DEFAULT MAKEDATE(start_year, 1) + INTERVAL start_quarter - 1 QUARTER -
                                      INTERVAL months_before MONTH;


      RETURN CONCAT(MONTHNAME(start_date), '-', MONTHNAME(end_date), ' ', YEAR(end_date));
    END$$
  DELIMITER ;

  DELIMITER $$
  CREATE DEFINER=`root`@`localhost` FUNCTION `get_cpt_receipt_status`(StartDate  VARCHAR(12), EndDate VARCHAR(12),
                                                                      Patient_ID INT) RETURNS char(50) CHARSET latin1
      DETERMINISTIC
  RETURN
    (
      SELECT IF(NumberOfCPTDrugsRcpt < 1, 'N', 'Y') AS CPTReceiptStatus
      FROM (
             SELECT
               person_id,
               count(obs_id) NumberOfCPTDrugsRcpt
             FROM obs
             WHERE concept_id IN (99037, 99033) AND voided = 0
                   AND person_id = Patient_ID AND
                   obs_datetime BETWEEN str_to_date(StartDate, "%d/%m/%Y") AND str_to_date(EndDate, "%d/%m/%Y")
             GROUP BY person_id
           ) CPTDrugsRcptFrequency
    )$$
  DELIMITER ;

  DELIMITER $$
  CREATE DEFINER=`root`@`localhost` FUNCTION `getCptStartDate`(`personid` INTEGER) RETURNS date
      READS SQL DATA
  BEGIN


      RETURN (SELECT min(obs_datetime) cpt_start
              FROM obs
              WHERE concept_id IN (99033, 99037) AND personid = person_id AND voided = 0
              GROUP BY person_id);
    END$$
  DELIMITER ;

  DELIMITER $$
  CREATE DEFINER=`root`@`localhost` FUNCTION `getCptStatusTxt`(`encounterid` INTEGER) RETURNS char(3) CHARSET latin1
      READS SQL DATA
  BEGIN


      RETURN (SELECT if(value_coded IS NOT NULL, "N", if(value_numeric = 0, "N", if(value_numeric > 0, "Y", ""))) AS cpt
              FROM obs
              WHERE concept_id IN (90220, 99037, 99033) AND voided = 0
                    AND encounterid = encounter_id
              HAVING cpt != ""
              LIMIT 1
      );

    END$$
  DELIMITER ;

  DELIMITER $$
  CREATE DEFINER=`openmrs`@`localhost` FUNCTION `getCptStatusTxt2`(`encounterid` INT) RETURNS char(1) CHARSET utf8
  BEGIN

      RETURN (SELECT if(value_numeric > 0, "Y", "") AS cpt
              FROM obs
              WHERE concept_id IN (99037, 99604) AND voided = 0
                    AND encounter_id = encounterid
              HAVING cpt != ""
              LIMIT 1
      );

    END$$
  DELIMITER ;

  DELIMITER $$
  CREATE DEFINER=`root`@`localhost` FUNCTION `getDeathDate`(`personid` INTEGER) RETURNS date
      READS SQL DATA
  BEGIN


      RETURN (SELECT if(a.death_date IS NULL, b.value_datetime, a.death_date) AS deathDate
              FROM person a
                LEFT JOIN

                (SELECT
                   person_id,
                   value_datetime
                 FROM obs
                 WHERE concept_id = 90272 AND voided = 0) b

                  ON a.person_id = b.person_id
              WHERE a.voided = 0
                    AND a.person_id = personid
              HAVING deathDate IS NOT NULL
              LIMIT 1
      );

    END$$
  DELIMITER ;

  DELIMITER $$
  CREATE DEFINER=`root`@`localhost` FUNCTION `get_death_status`(StartDate  VARCHAR(12), EndDate VARCHAR(12),
                                                                Patient_ID INT) RETURNS char(50) CHARSET latin1
      DETERMINISTIC
  RETURN (SELECT CONCAT('DEAD: ', CAST(date_format(DeathDate, '%d/%m/%Y') AS CHAR(10))) AS DeathStatus
            FROM (
                   SELECT
                     person_Id,
                     max(obs_datetime) DeathDate
                   FROM obs
                   WHERE
                     obs_datetime BETWEEN str_to_date(StartDate, "%d/%m/%Y") AND str_to_date(EndDate, "%d/%m/%Y")
                     AND concept_id = 99112 AND value_numeric = 1 AND person_Id = Patient_ID AND voided = 0
                   GROUP BY person_Id
                 ) RecentDeath
    )$$
  DELIMITER ;

  DELIMITER $$
  CREATE DEFINER=`root`@`localhost` FUNCTION `getEddDate`(`encounterid` INTEGER) RETURNS date
      READS SQL DATA
  BEGIN


      RETURN (SELECT value_datetime
              FROM obs
              WHERE concept_id = 5596
                    AND encounterid = encounter_id
                    AND voided = 0
              LIMIT 1

      );
    END$$
  DELIMITER ;

  DELIMITER $$
  CREATE DEFINER=`root`@`localhost` FUNCTION `getEddEncounterId`(`personid` INTEGER) RETURNS int(11)
      READS SQL DATA
  BEGIN


      RETURN (
        SELECT encounter_id
        FROM obs a
        WHERE concept_id = 5596
              AND personid = person_id
              AND voided = 0
        GROUP BY person_id, concat(year(value_datetime), month(value_datetime))
        LIMIT 1

      );
    END$$
  DELIMITER ;

  DELIMITER $$
  CREATE DEFINER=`root`@`localhost` FUNCTION `getEddEncounterId2`(`personid` INTEGER) RETURNS int(11)
      READS SQL DATA
  BEGIN


      RETURN (
        SELECT encounter_id
        FROM obs a
        WHERE concept_id = 5596
              AND personid = person_id
              AND voided = 0
        GROUP BY person_id, concat(year(value_datetime), month(value_datetime))
        LIMIT 1, 1

      );
    END$$
  DELIMITER ;

  DELIMITER $$
  CREATE DEFINER=`root`@`localhost` FUNCTION `getEddEncounterId3`(`personid` INTEGER) RETURNS int(11)
      READS SQL DATA
  BEGIN


      RETURN (
        SELECT encounter_id
        FROM obs a
        WHERE concept_id = 5596
              AND personid = person_id
              AND voided = 0
        GROUP BY person_id, concat(year(value_datetime), month(value_datetime))
        LIMIT 2, 1

      );
    END$$
  DELIMITER ;

  DELIMITER $$
  CREATE DEFINER=`root`@`localhost` FUNCTION `getEddEncounterId4`(`personid` INTEGER) RETURNS int(11)
      READS SQL DATA
  BEGIN


      RETURN (
        SELECT encounter_id
        FROM obs a
        WHERE concept_id = 5596
              AND personid = person_id
              AND voided = 0
        GROUP BY person_id, concat(year(value_datetime))
        LIMIT 3, 1

      );
    END$$
  DELIMITER ;

  DELIMITER $$
  CREATE DEFINER=`root`@`localhost` FUNCTION `getEncounterId`(`patientid`       INTEGER, `encounter_year` INTEGER,
                                                              `encounter_month` INTEGER) RETURNS int(11)
  BEGIN
      RETURN (SELECT MAX(encounter_id)
              FROM encounter
              WHERE patientid = patient_id AND EXTRACT(YEAR_MONTH FROM encounter_datetime) = EXTRACT(YEAR_MONTH FROM (
                MAKEDATE(encounter_year, 1) + INTERVAL encounter_month MONTH - INTERVAL 1 DAY)) AND voided = 0
              LIMIT 1);
    END$$
  DELIMITER ;

  DELIMITER $$
  CREATE DEFINER=`root`@`localhost` FUNCTION `getEncounterId2`(`patientid`         INTEGER, `encounter_year` INTEGER,
                                                               `encounter_quarter` INTEGER) RETURNS int(11)
  BEGIN
      RETURN (SELECT MAX(encounter_id)
              FROM encounter
              WHERE patientid = patient_id AND YEAR(encounter_datetime) = encounter_year AND
                    QUARTER(encounter_datetime) = encounter_quarter AND voided = 0
              LIMIT 1);
    END$$
  DELIMITER ;

  DELIMITER $$
  CREATE DEFINER=`root`@`localhost` FUNCTION `getEnrolDate`(`personid` INT) RETURNS date
      READS SQL DATA
  BEGIN


      RETURN (
        SELECT encounter_datetime AS enroldt
        FROM encounter
        WHERE encounter_type = (select encounter_type_id from encounter_type where locate('art',name) > 0 and locate('summary',name) > 0)
              AND voided = 0
              AND personid = patient_id
        LIMIT 1
      );

    END$$
  DELIMITER ;

  DELIMITER $$
  CREATE DEFINER=`root`@`localhost` FUNCTION `getFirstArtStopDate`(`personid` INTEGER) RETURNS date
      READS SQL DATA
  BEGIN


      RETURN
      (
        SELECT value_datetime
        FROM obs
        WHERE
          concept_id = 99084 AND voided = 0
          AND personid = person_id
        LIMIT 1);


    END$$
  DELIMITER ;

  DELIMITER $$
  CREATE DEFINER=`root`@`localhost` FUNCTION `getFlucStartDate`(`personid` INTEGER) RETURNS date
      READS SQL DATA
  BEGIN


      RETURN (SELECT min(obs_datetime) fluc_start
              FROM obs
              WHERE concept_id = 1193 AND value_coded = 747
                    AND personid = person_id AND voided = 0
              GROUP BY person_id);

    END$$
  DELIMITER ;

  DELIMITER $$
  CREATE DEFINER=`root`@`localhost` FUNCTION `get_followup_status`(StartDate  VARCHAR(12), EndDate VARCHAR(12),
                                                                   Patient_ID INT) RETURNS char(50) CHARSET latin1
      DETERMINISTIC
  RETURN
    (
      SELECT IFNULL((SELECT get_death_status(StartDate, EndDate, Patient_ID)),
                    IFNULL((get_transfer_status(StartDate, EndDate, Patient_ID)),
                           IFNULL((get_lost_status(StartDate, EndDate, Patient_ID)),
                                  IFNULL((get_seen_status(StartDate, EndDate, Patient_ID)),
                                         IFNULL((get_scheduled_visits(StartDate, EndDate, Patient_ID)),
                                                NULL
                                         )
                                  )
                           )
                    )
             ) AS FollowUpStatus
    )$$
  DELIMITER ;

  DELIMITER $$
  CREATE DEFINER=`root`@`localhost` FUNCTION `get_followup_status2`(StartDate  VARCHAR(12), EndDate VARCHAR(12),
                                                                    Patient_ID INT) RETURNS char(50) CHARSET utf8
  BEGIN

      RETURN CONCAT(get_death_status(StartDate, EndDate, Patient_ID), get_transfer_status(StartDate, EndDate, Patient_ID),
                    get_lost_status(StartDate, EndDate, Patient_ID), get_seen_status(StartDate, EndDate, Patient_ID),
                    get_scheduled_visits(StartDate, EndDate, Patient_ID));
    END$$
  DELIMITER ;

  DELIMITER $$
  CREATE DEFINER=`root`@`localhost` FUNCTION `getFUARTStatus`(Patient_ID INTEGER, start_date DATE, end_date DATE) RETURNS char(1) CHARSET utf8
  BEGIN

      DECLARE times_seen_in_quarter INT DEFAULT 0;
      DECLARE number_of_visits_in_quarter INT DEFAULT 0;
      DECLARE stopped INT DEFAULT 0;
      DECLARE lost INT DEFAULT 0;
      DECLARE restart INT DEFAULT 0;
      DECLARE transfer_out_date DATE;
      DECLARE death_date DATE;

      SELECT max(obs_datetime)
      INTO death_date
      FROM obs
      WHERE obs_datetime BETWEEN start_date AND end_date
            AND concept_id = 99112 AND value_coded = 90003 AND person_Id = Patient_ID AND voided = 0
      GROUP BY person_Id;
      IF death_date IS NOT NULL
      THEN
        RETURN '1';
      ELSE
        SELECT max(obs_datetime)
        INTO transfer_out_date
        FROM obs
        WHERE obs_datetime BETWEEN start_date AND end_date
              AND concept_id = 90306 AND value_numeric = 1 AND person_Id = Patient_ID AND voided = 0;

        IF transfer_out_date IS NOT NULL
        THEN
          RETURN '5';
        ELSE
          SELECT COUNT(obs_id)
          INTO stopped
          FROM obs
          WHERE obs_datetime BETWEEN start_date AND end_date
                AND concept_id = 99132 AND value_coded = 1363 AND person_Id = Patient_ID AND voided = 0;

          IF stopped > 0
          THEN
            RETURN '2';
          ELSE
            SELECT COUNT(obs_id)
            INTO lost
            FROM obs
            WHERE obs_datetime BETWEEN start_date AND end_date
                  AND concept_id = 99132 AND value_coded = 99133 AND person_Id = Patient_ID AND voided = 0;

            IF lost > 0
            THEN
              RETURN '3';
            ELSE
              SELECT max(obs_datetime)
              INTO restart
              FROM obs
              WHERE obs_datetime BETWEEN start_date AND end_date
                    AND concept_id = 99085 AND value_datetime BETWEEN start_date AND end_date AND person_Id = Patient_ID
                    AND voided = 0;

              IF restart IS NOT NULL
              THEN
                RETURN '6';
              ELSE
                SELECT COUNT(encounter_id)
                INTO times_seen_in_quarter
                FROM encounter
                WHERE encounter_datetime BETWEEN start_date AND end_date
                      AND encounter_type IN (select encounter_type_id from encounter_type where locate('art',name) > 0)
                      AND patient_id = Patient_ID AND voided = 0;

                SELECT COUNT(obs_id)
                INTO number_of_visits_in_quarter
                FROM obs
                WHERE value_datetime BETWEEN start_date AND end_date AND
                      EXTRACT(YEAR_MONTH FROM value_datetime) < EXTRACT(YEAR_MONTH FROM end_date)
                      AND patient_id = Patient_ID AND concept_id = 5096 AND voided = 0;
                IF times_seen_in_quarter = 0 AND number_of_visits_in_quarter > 0
                THEN
                  RETURN '4';
                ELSE
                  RETURN '';
                END IF;
              END IF;
            END IF;
          END IF;
        END IF;

      END IF;
    END$$
  DELIMITER ;

  DELIMITER $$
  CREATE DEFINER=`root`@`localhost` FUNCTION `getFunctionalStatusTxt`(`personid` INTEGER, `obsdatetime` DATE) RETURNS char(5) CHARSET latin1
      READS SQL DATA
  BEGIN


      RETURN (SELECT if(value_coded = 90037, "Amb", if(value_coded = 90038, "Work", "Bed")) AS f_status
              FROM obs
              WHERE concept_id = 90235
                    AND voided = 0
                    AND personid = person_id
                    AND obsdatetime = obs_datetime
              LIMIT 1);
    END$$
  DELIMITER ;

  DELIMITER $$
  CREATE DEFINER=`root`@`localhost` FUNCTION `getFUStatus`(Patient_ID INT, start_date DATE, end_date DATE) RETURNS char(30) CHARSET utf8
  BEGIN

      DECLARE times_seen_in_quarter INT DEFAULT 0;
      DECLARE number_of_visits_in_quarter INT DEFAULT 0;
      DECLARE transfer_out_date DATE;
      DECLARE death_date DATE;
      DECLARE lost_date DATE;

      SELECT max(obs_datetime)
      INTO death_date
      FROM obs
      WHERE obs_datetime BETWEEN start_date AND end_date AND concept_id = 99112 AND value_coded = 90003 AND
            person_id = Patient_ID AND voided = 0
      GROUP BY person_Id;
      IF death_date IS NOT NULL
      THEN
        RETURN 'DEAD';
      ELSE
        SELECT max(obs_datetime)
        INTO transfer_out_date
        FROM obs
        WHERE obs_datetime BETWEEN start_date AND end_date AND concept_id = 90306 AND value_coded = 90003 AND
              person_id = Patient_ID AND voided = 0;

        IF transfer_out_date IS NOT NULL
        THEN
          RETURN 'TO';
        ELSE
          SELECT max(obs_datetime) DeathDate
          INTO lost_date
          FROM obs
          WHERE obs_datetime BETWEEN start_date AND end_date AND concept_id = 5240 AND value_coded = 90003 AND
                person_id = Patient_ID AND voided = 0;
          IF lost_date IS NOT NULL
          THEN
            RETURN 'LOST';

          ELSE

            SELECT COUNT(encounter_id)
            INTO times_seen_in_quarter
            FROM encounter
            WHERE encounter_datetime BETWEEN start_date AND end_date AND form_id = 12 AND patient_id = Patient_ID AND
                  voided = 0;
            IF times_seen_in_quarter > 0

            THEN
              RETURN '√';
            ELSE
              SELECT COUNT(obs_id)
              INTO number_of_visits_in_quarter
              FROM obs
              WHERE value_datetime BETWEEN start_date AND end_date AND QUARTER(value_datetime) <= QUARTER(end_date)
                    AND person_id = Patient_ID AND concept_id = 5096 AND voided = 0;

              IF number_of_visits_in_quarter > 0
              THEN
                RETURN '→';
              ELSE
                RETURN '';
              END IF;
            END IF;
          END IF;
        END IF;
      END IF;
    END$$
  DELIMITER ;

  DELIMITER $$
  CREATE DEFINER=`root`@`localhost` FUNCTION `getINHStartDate`(`personid` INTEGER) RETURNS date
      READS SQL DATA
  BEGIN


      RETURN (SELECT min(obs_datetime) cpt_start
              FROM obs
              WHERE concept_id IN (99604, 99605) AND personid = person_id AND voided = 0
              GROUP BY person_id);
    END$$
  DELIMITER ;

  DELIMITER $$
  CREATE DEFINER=`root`@`localhost` FUNCTION `getLastCd4SevereValue`(`personid` INTEGER, `reportdt` DATE) RETURNS int(11)
      READS SQL DATA
  BEGIN


      RETURN (SELECT if(value_coded = 99150, 1, 0) AS severe
              FROM obs
              WHERE concept_id = 99151
                    AND voided = 0
                    AND personid = person_id
                    AND obs_datetime <= reportdt
              ORDER BY person_id, obs_datetime DESC
              LIMIT 1
      );
    END$$
  DELIMITER ;

  DELIMITER $$
  CREATE DEFINER=`root`@`localhost` FUNCTION `getLastCd4Value`(`personid` INTEGER, `reportdt` DATE) RETURNS int(11)
      READS SQL DATA
  BEGIN


      RETURN (SELECT value_numeric
              FROM obs
              WHERE concept_id IN (99071, 5497)
                    AND voided = 0
                    AND personid = person_id
                    AND obs_datetime <= reportdt
              ORDER BY person_id, obs_datetime DESC
              LIMIT 1
      );
    END$$
  DELIMITER ;

  DELIMITER $$
  CREATE DEFINER=`root`@`localhost` FUNCTION `getLastEncounterDate`(`personid` INTEGER) RETURNS date
      READS SQL DATA
  BEGIN
      RETURN (SELECT encounter_datetime
              FROM encounter
              WHERE encounter_type IN (1, 2) AND patient_id = personid AND voided = 0
              ORDER BY encounter_datetime DESC
              LIMIT 1);
    END$$
  DELIMITER ;

  DELIMITER $$
  CREATE DEFINER=`root`@`localhost` FUNCTION `getLastVisitDate`(`personid` INTEGER, `reportdt` DATE) RETURNS date
      READS SQL DATA
  BEGIN


      RETURN (SELECT date(max(encounter_datetime))
              FROM encounter
              WHERE encounter_type IN (1, 2) AND voided = 0 AND personid = patient_id
                    AND if(year(encounter_datetime) < year(reportdt), 1, if(
                  (year(encounter_datetime) = year(reportdt) AND month(encounter_datetime) <= month(reportdt)), 1, 0)) = 1
              GROUP BY patient_id);


    END$$
  DELIMITER ;

  DELIMITER $$
  CREATE DEFINER=`root`@`localhost` FUNCTION `get_lost_status`(StartDate  VARCHAR(12), EndDate VARCHAR(12),
                                                               Patient_ID INT) RETURNS char(50) CHARSET latin1
      DETERMINISTIC
  RETURN
    (
      SELECT 'LOST' AS LostStatus
      FROM (
             SELECT
               person_Id,
               max(obs_datetime) DeathDate
             FROM obs
             WHERE obs_datetime BETWEEN str_to_date(StartDate, "%d/%m/%Y") AND str_to_date(EndDate, "%d/%m/%Y")
                   AND concept_id = 5240 AND value_numeric = 1 AND person_Id = Patient_ID AND voided = 0
                   AND person_id NOT IN (
               SELECT person_Id
               FROM (
                      SELECT
                        person_Id,
                        max(obs_datetime) DeathDate
                      FROM obs
                      WHERE concept_id IN (99112, 90306) AND value_numeric = 1 AND voided = 0
                      GROUP BY person_Id) AA)
             GROUP BY person_Id
           ) RecentLostStatus

    )$$
  DELIMITER ;

  DELIMITER $$
  CREATE DEFINER=`root`@`localhost` FUNCTION `getMonthCD4Value`(`personid` INTEGER, `monthyr` CHAR(6)) RETURNS int(11)
      READS SQL DATA
  BEGIN


      RETURN (SELECT value_numeric
              FROM obs
              WHERE concept_id IN
                    (99071, 5497)
                    AND voided = 0
                    AND personid = person_id
                    AND monthyr = concat(year(obs_datetime), month(obs_datetime))
              LIMIT 1

      );
    END$$
  DELIMITER ;

  DELIMITER $$
  CREATE DEFINER=`root`@`localhost` FUNCTION `getMonthsOnCurrent`(`personid` INTEGER) RETURNS int(11)
      READS SQL DATA
  BEGIN


      RETURN (
        SELECT period_diff(date_format(now(), '%Y%m'), date_format(obs_datetime, '%Y%m'))
        FROM obs
        WHERE concept_id = 1255
              AND value_coded IN (1590, 1587)
              AND voided = 0
              AND personid = person_id
        ORDER BY obs_datetime DESC
        LIMIT 1
      );
    END$$
  DELIMITER ;

  DELIMITER $$
  CREATE DEFINER=`root`@`localhost` FUNCTION `getMonthsSinceStart`(`personid` INTEGER) RETURNS int(11)
      READS SQL DATA
  BEGIN


      RETURN (
        SELECT period_diff(date_format(now(), '%Y%m'), date_format(obs_datetime, '%Y%m')) AS mnths
        FROM obs
        WHERE concept_id = 1255
              AND value_coded IN (1256, 1585)
              AND voided = 0
              AND personid = person_id
        ORDER BY obs_datetime DESC
        LIMIT 1);
    END$$
  DELIMITER ;

  DELIMITER $$
  CREATE DEFINER=`root`@`localhost` FUNCTION `getNumberDrugEncounter`(`personid` INTEGER) RETURNS int(11)
      READS SQL DATA
  BEGIN


      RETURN (

        SELECT count(DISTINCT value_coded) AS number_summary
        FROM obs a

          INNER JOIN

          (SELECT encounter_id
           FROM encounter
           WHERE encounter_type = 2
                 AND voided = 0) b
            ON a.encounter_id = b.encounter_id

        WHERE concept_id IN (90061, 99064, 90315)
              AND a.voided = 0
              AND personid = person_id
        GROUP BY person_id
        LIMIT 1
      );

    END$$
  DELIMITER ;

  DELIMITER $$
  CREATE DEFINER=`root`@`localhost` FUNCTION `getNumberDrugSummary`(`personid` INTEGER) RETURNS int(11)
      READS SQL DATA
  BEGIN


      RETURN (

        SELECT count(DISTINCT value_coded) AS number_summary
        FROM obs a

          INNER JOIN

          (SELECT encounter_id
           FROM encounter
           WHERE encounter_type = 1
                 AND voided = 0) b
            ON a.encounter_id = b.encounter_id

        WHERE concept_id IN (90061, 99064, 90315)
              AND a.voided = 0
              AND personid = person_id
        GROUP BY person_id
        LIMIT 1
      );

    END$$
  DELIMITER ;

  DELIMITER $$
  CREATE DEFINER=`openmrs`@`localhost` FUNCTION `getNutritionalStatus`(Patient_ID INT, start_date DATE, end_date DATE) RETURNS char(10) CHARSET latin1
      DETERMINISTIC
  RETURN
    (
      SELECT CASE value_coded
             WHEN 99271
               THEN 'MAM'
             WHEN 99272
               THEN 'SAM'
             WHEN 99273
               THEN 'SAMO'
             WHEN 99274
               THEN 'PWG/PA'
             ELSE NULL END AS TBStatus
      FROM (
             SELECT
               obs.person_id,
               MAX(obs_datetime) AS firstDate,
               value_coded
             FROM obs
             WHERE concept_id = 68 AND value_coded IN (99271, 99272, 99273, 99274) AND voided = 0
                   AND person_id = Patient_ID AND obs_datetime BETWEEN start_date AND end_date
             GROUP BY person_id
           ) NutritionalOptions
    )$$
  DELIMITER ;

  DELIMITER $$
  CREATE DEFINER=`root`@`localhost` FUNCTION `getPatientIdentifierTxt`(`personid` INTEGER) RETURNS char(15) CHARSET latin1
      READS SQL DATA
  BEGIN


      RETURN (SELECT identifier
              FROM patient_identifier
              WHERE voided = 0
                    AND personid = patient_id
              LIMIT 1);
    END$$
  DELIMITER ;

  DELIMITER $$
  CREATE DEFINER=`root`@`localhost` FUNCTION `getReferralText`(`personid` INTEGER) RETURNS char(30) CHARSET latin1
      READS SQL DATA
  BEGIN
      RETURN (
        SELECT if(concept_id = 99054 AND value_coded = 99053, "Therapeutic Feeding",
                  if(concept_id = 99054 AND value_coded = 99051, "Infant Feeding Counselling",
                     if(concept_id = 99054 AND value_coded = 99052, "Nutrition Counselling",
                        if(concept_id = 99054 AND value_coded = 99050, "Food Support",
                           if(concept_id = 99267 AND value_text IS NOT NULL, "Other", ""))))) refer
        FROM obs
        WHERE concept_id IN (99054, 99267)
              AND obs_datetime = getLastEncounterDate(personid)
              AND personid = person_id
              AND voided = 0);
    END$$
  DELIMITER ;

  DELIMITER $$
  CREATE DEFINER=`root`@`localhost` FUNCTION `getReturnDate`(`encounterid` INTEGER) RETURNS date
      READS SQL DATA
  BEGIN


      RETURN (SELECT value_datetime AS return_date
              FROM obs
              WHERE concept_id = 5096
                    AND voided = 0
                    AND encounterid = encounter_id
              LIMIT 1
      );

    END$$
  DELIMITER ;

  DELIMITER $$
  CREATE DEFINER=`root`@`localhost` FUNCTION `getReturnDate2`(`personid` INTEGER, `obsdatetime` DATE) RETURNS date
      READS SQL DATA
  BEGIN


      RETURN (SELECT value_datetime AS return_date
              FROM obs
              WHERE concept_id = 5096
                    AND voided = 0
                    AND personid = person_id
                    AND obsdatetime = obs_datetime
              LIMIT 1
      );

    END$$
  DELIMITER ;

  DELIMITER $$
  CREATE DEFINER=`root`@`localhost` FUNCTION `get_scheduled_visits`(StartDate  VARCHAR(12), EndDate VARCHAR(12),
                                                                    Patient_ID INT) RETURNS char(50) CHARSET latin1
      DETERMINISTIC
  RETURN
    (
      SELECT IF(NumberOfVisitsScheduledInPeriod = 0, 'NO SCHEDULED VISIT', NULL) AS Scheduled_Visits_Status
      FROM (
             SELECT COUNT(obs_id) AS NumberOfVisitsScheduledInPeriod
             FROM obs
             WHERE value_datetime BETWEEN str_to_date(StartDate, "%d/%m/%Y") AND str_to_date(EndDate, "%d/%m/%Y")
                   AND patient_id = Patient_ID AND concept_id = 5096 AND Voided = 0
           ) Visits

    )$$
  DELIMITER ;

  DELIMITER $$
  CREATE DEFINER=`root`@`localhost` FUNCTION `get_seen_status`(StartDate  VARCHAR(12), EndDate VARCHAR(12),
                                                               Patient_ID INTEGER) RETURNS char(50) CHARSET latin1
      DETERMINISTIC
  RETURN
    (
      SELECT IF(NumberOfTimesSeenInPeriod > 0, 'SEEN', NULL) AS SEENStatus
      FROM (
             SELECT COUNT(encounter_id) AS NumberOfTimesSeenInPeriod
             FROM encounter
             WHERE encounter_datetime BETWEEN str_to_date(StartDate, "%d/%m/%Y") AND str_to_date(EndDate, "%d/%m/%Y")
                   AND form_id = (select form_id from openmrs.form where locate('art',name) > 0 and locate('card',name) > 0 and locate('encounter',name) > 0)
                   AND patient_id = Patient_ID

           ) RecentSEENStatus

    )$$
  DELIMITER ;

  DELIMITER $$
  CREATE DEFINER=`root`@`localhost` FUNCTION `getStartEncounterId`(`personid` INTEGER) RETURNS int(11)
      READS SQL DATA
  BEGIN
      RETURN (SELECT encounter_id
              FROM obs
              WHERE concept_id = 1255 AND value_coded IN (1256, 1585)
                    AND person_id = personid
                    AND voided = 0
              ORDER BY obs_datetime DESC
              LIMIT 1
      );
    END$$
  DELIMITER ;

  DELIMITER $$
  CREATE DEFINER=`openmrs`@`localhost` FUNCTION `getStatusAtEnrollment`(patient INTEGER) RETURNS char(5) CHARSET utf8
  BEGIN

      DECLARE lactating INT;
      DECLARE pregnant INT;
      DECLARE eid INT;
      DECLARE tb INT;
      DECLARE ti INT;

      SELECT if(o.obs_id > 0, '1', '')
      INTO eid
      FROM obs o INNER JOIN encounter e
          ON (e.encounter_id = o.encounter_id AND e.encounter_type = (select encounter_type_id from encounter_type where locate('art',name) > 0 and locate('summary',name) > 0) AND o.concept_id = 99149 AND o.value_boolean = TRUE
              AND o.person_id = patient)
      ORDER BY e.encounter_datetime ASC
      LIMIT 1;
      SELECT if(o.obs_id > 0, '2', '')
      INTO pregnant
      FROM obs o INNER JOIN encounter e
          ON (e.encounter_id = o.encounter_id AND e.encounter_type = (select encounter_type_id from encounter_type where locate('art',name) > 0 and locate('summary',name) > 0) AND o.concept_id = 99602 AND o.value_boolean = TRUE
              AND o.person_id = patient)
      ORDER BY e.encounter_datetime ASC
      LIMIT 1;
      SELECT if(o.obs_id > 0, '3', '')
      INTO tb
      FROM obs o INNER JOIN encounter e
          ON (e.encounter_id = o.encounter_id AND e.encounter_type = (select encounter_type_id from encounter_type where locate('art',name) > 0 and locate('summary',name) > 0) AND o.concept_id = 99600 AND o.value_boolean = TRUE
              AND o.person_id = patient)
      ORDER BY e.encounter_datetime ASC
      LIMIT 1;
      SELECT if(o.obs_id > 0, '4', '')
      INTO lactating
      FROM obs o INNER JOIN encounter e
          ON (e.encounter_id = o.encounter_id AND e.encounter_type = (select encounter_type_id from encounter_type where locate('art',name) > 0 and locate('summary',name) > 0) AND o.concept_id = 99601 AND o.value_boolean = TRUE
              AND o.person_id = patient)
      ORDER BY e.encounter_datetime ASC
      LIMIT 1;
      SELECT if(o.obs_id > 0, '5', '')
      INTO ti
      FROM obs o INNER JOIN encounter e
          ON (e.encounter_id = o.encounter_id AND e.encounter_type = (select encounter_type_id from encounter_type where locate('art',name) > 0 and locate('summary',name) > 0) AND o.concept_id = 99110 AND o.value_coded = 90003
              AND o.person_id = patient)
      ORDER BY e.encounter_datetime ASC
      LIMIT 1;

      RETURN CONCAT_WS(' ', COALESCE(eid, ''), COALESCE(pregnant, ''), COALESCE(eid, ''), COALESCE(tb, ''),
                       COALESCE(ti, ''));
    END$$
  DELIMITER ;

  DELIMITER $$
  CREATE DEFINER=`root`@`localhost` FUNCTION `getSubstituteDate`(`obsgroupid` INTEGER) RETURNS date
      READS SQL DATA
  BEGIN


      RETURN (
        SELECT value_datetime
        FROM
          obs
        WHERE concept_id = 99163
              AND voided = 0
              AND obsgroupid = obs_group_id
        LIMIT 1);
    END$$
  DELIMITER ;

  DELIMITER $$
  CREATE DEFINER=`root`@`localhost` FUNCTION `getSubstituteObsGroupId`(`personid` INTEGER) RETURNS int(11)
      READS SQL DATA
  BEGIN


      RETURN (
        SELECT obs_group_id
        FROM obs
        WHERE concept_id = 99163 AND voided = 0
              AND personid = person_id
        ORDER BY value_datetime ASC
        LIMIT 0, 1
      );
    END$$
  DELIMITER ;

  DELIMITER $$
  CREATE DEFINER=`root`@`localhost` FUNCTION `getSubstituteObsGroupId2`(`personid` INTEGER) RETURNS int(11)
      READS SQL DATA
  BEGIN


      RETURN (
        SELECT obs_group_id
        FROM obs
        WHERE concept_id = 99163 AND voided = 0
              AND personid = person_id
        ORDER BY value_datetime ASC
        LIMIT 1, 1
      );
    END$$
  DELIMITER ;

  DELIMITER $$
  CREATE DEFINER=`root`@`localhost` FUNCTION `getSubstituteReasonTxt`(`obsgroupid` INTEGER) RETURNS char(15) CHARSET latin1
      READS SQL DATA
  BEGIN


      RETURN (
        SELECT if(value_coded = 90040, "Toxi",
                  if(value_coded = 90041, "Preg",
                     if(value_coded = 90042, "RiskPreg",
                        if(value_coded = 90043, "NewTb",
                           if(value_coded = 90044, "NewDrug",
                              if(value_coded = 90045, "DrugStock",
                                 if(value_coded = 90002, "Other",
                                    if(value_coded = 90046, "Clinical",
                                       if(value_coded = 90047, "Immo", ''))))))))) reason
        FROM
          obs
        WHERE concept_id = 90246
              AND voided = 0
              AND obsgroupid = obs_group_id
        LIMIT 1
      );
    END$$
  DELIMITER ;

  DELIMITER $$
  CREATE DEFINER=`root`@`localhost` FUNCTION `getSwitchDate`(`obsgroupid` INTEGER) RETURNS date
      READS SQL DATA
  BEGIN


      RETURN (
        SELECT value_datetime
        FROM
          obs
        WHERE concept_id = 99164
              AND voided = 0
              AND obsgroupid = obs_group_id
        LIMIT 1
      );
    END$$
  DELIMITER ;

  DELIMITER $$
  CREATE DEFINER=`root`@`localhost` FUNCTION `getSwitchObsGroupId`(`personid` INTEGER) RETURNS int(11)
      READS SQL DATA
  BEGIN


      RETURN (
        SELECT obs_group_id
        FROM obs
        WHERE concept_id = 99164 AND voided = 0
              AND personid = person_id
        ORDER BY value_datetime ASC
        LIMIT 0, 1
      );
    END$$
  DELIMITER ;

  DELIMITER $$
  CREATE DEFINER=`root`@`localhost` FUNCTION `getSwitchObsGroupId2`(`personid` INTEGER) RETURNS int(11)
      READS SQL DATA
  BEGIN


      RETURN (
        SELECT obs_group_id
        FROM obs
        WHERE concept_id = 99164 AND voided = 0
              AND personid = person_id
        ORDER BY value_datetime ASC
        LIMIT 1, 2
      );
    END$$
  DELIMITER ;

  DELIMITER $$
  CREATE DEFINER=`root`@`localhost` FUNCTION `getSwitchReasonTxt`(`obsgroupid` INTEGER) RETURNS int(11)
      READS SQL DATA
  BEGIN


      RETURN (
        SELECT if(value_coded = 90040, 1,
                  if(value_coded = 90041, 2,
                     if(value_coded = 90042, 3,
                        if(value_coded = 90043, 4,
                           if(value_coded = 90044, 5,
                              if(value_coded = 90045, 6,
                                 if(value_coded = 90002, 7,
                                    if(value_coded = 90046, 8,
                                       if(value_coded = 90047, 9, NULL))))))))) reason
        FROM
          obs
        WHERE concept_id = 90247
              AND voided = 0
              AND obsgroupid = obs_group_id
        LIMIT 1
      );
    END$$
  DELIMITER ;

  DELIMITER $$
  CREATE DEFINER=`root`@`localhost` FUNCTION `getTbRegNoTxt`(`personid` INTEGER) RETURNS char(15) CHARSET utf8
      READS SQL DATA
  BEGIN


      RETURN (
        SELECT min(value_text) tb_reg
        FROM obs
        WHERE concept_id = 99031 AND voided = 0
              AND personid = person_id
        LIMIT 1);

    END$$
  DELIMITER ;

  DELIMITER $$
  CREATE DEFINER=`root`@`localhost` FUNCTION `getTbStartDate`(`personid` INTEGER) RETURNS date
      READS SQL DATA
  BEGIN


      RETURN (SELECT min(value_datetime) AS start
              FROM obs
              WHERE concept_id = 90217 AND voided = 0 AND personid = person_id
              GROUP BY person_id);
    END$$
  DELIMITER ;

  DELIMITER $$
  CREATE DEFINER=`root`@`localhost` FUNCTION `get_tb_status`(StartDate VARCHAR(12), EndDate VARCHAR(12), Patient_ID INT) RETURNS char(50) CHARSET latin1
      DETERMINISTIC
  RETURN
    (
      SELECT CASE value_coded
             WHEN 90079
               THEN 1
             WHEN 90073
               THEN 2
             WHEN 90217
               THEN 3
             ELSE NULL END AS TBStatus
      FROM (
             SELECT
               obs.person_id,
               MAX(obs_datetime) AS firstDate,
               value_coded
             FROM obs
             WHERE concept_id = 90216 AND value_coded IN (90079, 90073, 90217) AND voided = 0
                   AND person_id = Patient_ID AND
                   obs_datetime BETWEEN str_to_date(StartDate, "%d/%m/%Y") AND str_to_date(EndDate, "%d/%m/%Y")
             GROUP BY person_id
           ) TBOptions
    )$$
  DELIMITER ;

  DELIMITER $$
  CREATE DEFINER=`root`@`localhost` FUNCTION `getTbStatusTxt`(`encounterid` INTEGER) RETURNS int(11)
      READS SQL DATA
  BEGIN


      RETURN (SELECT if(value_coded = 90079, 1,
                        if(value_coded = 90073, 2,
                           if(value_coded = 90071, 3, NULL))) AS tb_status
              FROM obs
              WHERE concept_id = 90216 AND voided = 0
                    AND encounterid = encounter_id
              LIMIT 1
      );

    END$$
  DELIMITER ;

  DELIMITER $$
  CREATE DEFINER=`root`@`localhost` FUNCTION `getTbStopDate`(`personid` INTEGER) RETURNS date
      READS SQL DATA
  BEGIN


      RETURN (SELECT min(value_datetime) AS stop
              FROM obs
              WHERE concept_id = 90310
                    AND voided = 0
                    AND personid = person_id
              GROUP BY person_id
              LIMIT 1);
    END$$
  DELIMITER ;

  DELIMITER $$
  CREATE DEFINER=`root`@`localhost` FUNCTION `getTransferInTxt`(`personid` INTEGER) RETURNS char(5) CHARSET latin1
      READS SQL DATA
  BEGIN


      RETURN (SELECT if(concept_id = 99055 AND value_coded = 1065, "TI",
                        if(concept_id = 99110 AND value_numeric = 1, "TI",
                           if(concept_id = 90206 AND value_text IS NOT NULL, "TI",
                              if(concept_id = 99109 AND value_text IS NOT NULL, "TI", '')))) AS transfer_in
              FROM obs
              WHERE concept_id IN (99055, 99110, 99109, 90206)
                    AND voided = 0
                    AND personid = person_id
              LIMIT 1
      );

    END$$
  DELIMITER ;

  DELIMITER $$
  CREATE DEFINER=`root`@`localhost` FUNCTION `getTransferOutDate`(`personid` INTEGER) RETURNS date
      READS SQL DATA
  BEGIN


      RETURN (SELECT value_datetime AS tout_date
              FROM obs
              WHERE concept_id = 99165 AND voided = 0
                    AND
                    personid = person_id
              ORDER BY value_datetime DESC
              LIMIT 1
      );

    END$$
  DELIMITER ;

  DELIMITER $$
  CREATE DEFINER=`root`@`localhost` FUNCTION `get_transfer_status`(StartDate  VARCHAR(12), EndDate VARCHAR(12),
                                                                   Patient_ID INT) RETURNS char(50) CHARSET latin1
      DETERMINISTIC
  RETURN
    (
      SELECT CONCAT(A.TransferStatus, ' ', B.TransferStatus) AS TransferStatus
      FROM (
             SELECT
               person_Id,
               max(obs_datetime) TransferDate,
               'TO: ' AS         TransferStatus
             FROM obs
             WHERE obs_datetime BETWEEN str_to_date(StartDate, "%d/%m/%Y") AND str_to_date(EndDate, "%d/%m/%Y")
                   AND concept_id = 90306 AND value_numeric = 1 AND person_Id = Patient_ID AND voided = 0
             GROUP BY person_Id
           ) A LEFT JOIN
        (
          SELECT
            person_Id,
            max(obs_datetime) TransferDate,
            value_text AS     TransferStatus
          FROM obs
          WHERE obs_datetime BETWEEN str_to_date(StartDate, "%d/%m/%Y") AND str_to_date(EndDate, "%d/%m/%Y")
                AND concept_id = 90211 AND person_Id = Patient_ID AND voided = 0
          GROUP BY person_Id
        ) B ON A.person_Id = B.person_Id
    )$$
  DELIMITER ;

  DELIMITER $$
  CREATE DEFINER=`root`@`localhost` FUNCTION `getWeightValue`(`personid` INTEGER, `obsdatetime` DATE) RETURNS int(11)
      READS SQL DATA
  BEGIN


      RETURN (
        SELECT value_numeric
        FROM obs
        WHERE concept_id = 90236
              AND personid = person_id
              AND obsdatetime = obs_datetime
              AND voided = 0
        LIMIT 1);
    END$$
  DELIMITER ;

  DELIMITER $$
  CREATE DEFINER=`root`@`localhost` FUNCTION `getWhoStageBaseTxt`(`personid` INTEGER, `artstartdt` DATE) RETURNS int(11)
      READS SQL DATA
  BEGIN


      RETURN (SELECT if(concept_id = 99070 AND value_coded = 1204, 1,
                        if(concept_id = 99070 AND value_coded = 1205, 2,
                           if(concept_id = 99070 AND value_coded = 1206, 3,
                              if(concept_id = 99070 AND value_coded = 1207, 4,
                                 if(concept_id = 90203 AND value_coded = 90033 AND obs_datetime = artstartdt OR
                                    concept_id = 90203 AND value_coded = 90293 AND obs_datetime = artstartdt, 1,
                                    if(concept_id = 90203 AND value_coded = 90034 AND obs_datetime = artstartdt OR
                                       concept_id = 90203 AND value_coded = 90294 AND obs_datetime = artstartdt, 2,
                                       if(concept_id = 90203 AND value_coded = 90035 AND obs_datetime = artstartdt OR
                                          concept_id = 90203 AND value_coded = 90295 AND obs_datetime = artstartdt, 3,
                                          if(concept_id = 90203 AND value_coded = 90036 AND obs_datetime = artstartdt OR
                                             concept_id = 90203 AND value_coded = 90296 AND obs_datetime = artstartdt, 4,
                                             NULL)))))))) AS stage
              FROM obs
              WHERE concept_id IN (90203, 99070)
                    AND personid = person_id
                    AND voided = 0
              HAVING stage IS NOT NULL
              LIMIT 1
      );
    END$$
  DELIMITER ;

  DELIMITER $$
  CREATE DEFINER=`root`@`localhost` FUNCTION `getWHOStageDate`(patient_id INT, stage INT) RETURNS date
  BEGIN
      RETURN (SELECT MAX(obs_datetime)
              FROM obs
              WHERE concept_id = 90203 AND
                    (obs_datetime < getArtBaseTransferDate(patient_id) OR getArtBaseTransferDate(patient_id) IS NULL) AND
                    person_id = patient_id AND value_coded = if(stage = 1, 90033, if(stage = 2, 90034,
                                                                                     if(stage = 3, 90035,
                                                                                        if(stage = 4, 90036, NULL)))) AND
                    concept_id IS NOT NULL);
    END$$
  DELIMITER ;

  DELIMITER $$
  CREATE DEFINER=`root`@`localhost` FUNCTION `getWhoStageTxt`(`personid` INTEGER, `obsdatetime` DATE) RETURNS int(11)
      READS SQL DATA
  BEGIN RETURN
    (SELECT if(concept_id = 90203
               AND value_coded = 90033
               OR concept_id = 90203
                  AND value_coded = 90293, 1, if(concept_id = 90203
                                                 AND value_coded = 90034
                                                 OR concept_id = 90203
                                                    AND value_coded = 90294, 2, if(concept_id = 90203
                                                                                   AND value_coded = 90035
                                                                                   OR concept_id = 90203
                                                                                      AND value_coded = 90295, 3, if(concept_id = 90203
                                                                                                                     AND value_coded = 90036
                                                                                                                     OR concept_id = 90203
                                                                                                                        AND value_coded = 90296, 4, NULL)))) AS stage
     FROM obs
     WHERE concept_id = 90203
           AND personid = person_id
           AND obsdatetime = obs_datetime
           AND voided = 0 HAVING stage IS NOT NULL LIMIT 1 ); END$$
  DELIMITER ;
