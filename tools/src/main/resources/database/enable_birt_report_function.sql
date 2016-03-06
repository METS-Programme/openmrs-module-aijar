DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `GetARTData`(IN start_year INTEGER, IN start_month INT)
BEGIN
	DECLARE bDone INT;

	DECLARE patient_id INT;

    DECLARE art_start_date date;

    DECLARE unique_id_number CHAR(15);

    DECLARE ti char(2);
    DECLARE emtct char(5);

    DECLARE patient_clinic_id CHAR(12);

    DECLARE surname char(40);
    DECLARE given_name char(40);

    DECLARE sex char(1);

    DECLARE age INT;

    DECLARE district CHAR(30);
	DECLARE sub_county CHAR(30);
	DECLARE village_cell CHAR(30);

    DECLARE function_status CHAR(30);

    DECLARE weight_muac CHAR(30);

    DECLARE who_stage int;

    DECLARE cd4 int;
	DECLARE viral_load int;

    DECLARE cpt_start_date date;
    DECLARE cpt_stop_date date;

    DECLARE inh_start_date date;
    DECLARE inh_stop_date date;

    DECLARE tb_reg_no CHAR(15);
    DECLARE tb_start_date date;
    DECLARE tb_stop_date date;


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
    e.patient_id as 'patient_id',
    o.value_datetime as 'art_start_date',
    getPatientIdentifierTxt(e.patient_id) AS 'unique_id_number',
    getTransferInTxt(e.patient_id) AS 'ti',
    IF(getCareEntryTxt(e.patient_id) IN ('PMTCT' , 'eMTCT'),'eMTCT','') AS 'emtct',
    TIMESTAMPDIFF(YEAR,p.birthdate,CURDATE()) AS 'age',
    p.gender AS 'sex',
    getFunctionalStatusTxt(e.patient_id, o.value_datetime) AS 'function_status',
    getBaseWeightValue(e.patient_id, o.value_datetime) AS 'weight_muac',
    getWhoStageBaseTxt(e.patient_id, o.value_datetime) AS 'who_stage',
    getCd4BaseValue(e.patient_id,o.value_datetime) as 'cd4',
    getCptStartDate(e.patient_id) as 'cpt_start_date',
    getTbRegNoTxt(e.patient_id) as 'tb_reg_no',
    getTbStartDate(e.patient_id) as 'tb_start_date',
    getTbStopDate(e.patient_id) as 'tb_stop_date',
    getArtStartRegTxt(e.patient_id) as 'original_regimen',
    getEddDate(getEddEncounterId(e.patient_id)) as 'preg1_edd',
    getAncNumberTxt(getEddEncounterId(e.patient_id)) as 'preg1_anc',
	getEddDate(getEddEncounterId2(e.patient_id)) as 'preg2_edd',
    getAncNumberTxt(getEddEncounterId2(e.patient_id)) as 'preg2_anc',
	getEddDate(getEddEncounterId3(e.patient_id)) as 'preg3_edd',
    getAncNumberTxt(getEddEncounterId3(e.patient_id)) as 'preg3_anc',
	getEddDate(getEddEncounterId4(e.patient_id)) as 'preg4_edd',
	getAncNumberTxt(getEddEncounterId4(e.patient_id)) as 'preg4_anc',
    CONCAT(getSwitchReasonTxt(getSwitchObsGroupId(e.patient_id)),'/',date_format(getSwitchDate(getSwitchObsGroupId(e.patient_id)),'%e/%m/%y')) as 'first_line_first',
    CONCAT(getSwitchReasonTxt(getSwitchObsGroupId2(e.patient_id)),'/',date_format(getSwitchDate(getSwitchObsGroupId2(e.patient_id)),'%e/%m/%y')) as 'first_line_second',
    CONCAT(getSubstituteReasonTxt(getSubstituteObsGroupId(e.patient_id)),'/',date_format(getSubstituteDate(getSubstituteObsGroupId(e.patient_id)),'%e/%m/%y')) as 'second_line_first',
	CONCAT(getSubstituteReasonTxt(getSubstituteObsGroupId2(e.patient_id)),'/',date_format(getSubstituteDate(getSubstituteObsGroupId2(e.patient_id)),'%e/%m/%y')) as 'second_line_second'
FROM
    person p
        INNER JOIN
    encounter e ON (p.person_id = e.patient_id)
        INNER JOIN
    obs o ON (e.encounter_id = o.encounter_id
        AND o.concept_id IN (99160 , 99161)
        AND e.voided = 0
        AND o.voided = 0
        AND EXTRACT(YEAR_MONTH FROM o.value_datetime) = EXTRACT(YEAR_MONTH FROM (MAKEDATE(start_year,1) + INTERVAL start_month MONTH - INTERVAL 1 DAY)))
ORDER BY o.value_datetime ASC;

	DECLARE CONTINUE HANDLER FOR NOT FOUND SET bDone = 1;

    DROP TEMPORARY TABLE IF EXISTS artData;

  CREATE TEMPORARY TABLE IF NOT EXISTS artData
	(art_start_date date,
    unique_id_number CHAR(15),
    ti char(2),
    emtct char(5),
    patient_clinic_id CHAR(12),
    surname char(40),
    given_name char(40),
    sex char(1),
    age INT,
    district CHAR(30),
    sub_county CHAR(30),
    village_cell CHAR(30),
    function_status CHAR(30),
    weight_muac CHAR(30),
    who_stage int,
    cd4 int,
    viral_load int,
    cpt_start_date date,
    cpt_stop_date date,
    inh_start_date date,
    inh_stop_date date,
    tb_reg_no CHAR(15),
    tb_start_date date,
    tb_stop_date date,
    preg1_edd CHAR(15),
    preg1_anc CHAR(15),
    preg1_infant CHAR(15),
    preg2_edd CHAR(15),
    preg2_anc CHAR(15),
    preg2_infant CHAR(15),
    preg3_edd CHAR(15),
    preg3_anc CHAR(15),
    preg3_infant CHAR(15),
    preg4_edd CHAR(15),
    preg4_anc CHAR(15),
    preg4_infant CHAR(15),
    original_regimen CHAR(15),
	first_line_first CHAR(15),
    first_line_second CHAR(15),
    second_line_first CHAR(15),
    second_line_second CHAR(15),
    third_line_first CHAR(15),
    third_line_second CHAR(15)
    );

  OPEN curs;

  SET bDone = 0;

  REPEAT
    FETCH curs INTO
    patient_id,
    art_start_date,
    unique_id_number,
    ti,
    emtct,
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
	IF (patient_id > 0) THEN
		SELECT middle_name, family_name INTO given_name , surname FROM person_name WHERE person_id = patient_id LIMIT 1;
		SELECT county_district, state_province, city_village INTO district , sub_county , village_cell FROM person_address WHERE person_id = patient_id LIMIT 1;
		INSERT INTO artData(
		art_start_date,
		unique_id_number,
		ti,
		emtct,
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
		art_start_date,
		unique_id_number,
		ti,
		emtct,
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
		);
    END IF;
  UNTIL bDone END REPEAT;
  CLOSE curs;
SELECT
    *
FROM
    artData;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `GetARTFollowupData0_24`(IN start_year INT, IN start_month INTEGER)
BEGIN
	DECLARE bDone INT;

	DECLARE patient INT;
    DECLARE x INT;
    DECLARE arvs_fu_status TEXT;
    DECLARE tb_status TEXT;
    DECLARE adh TEXT;
    DECLARE cpt TEXT;
    DECLARE adh_cpt_all TEXT;
	DECLARE adh_cpt TEXT;
    DECLARE fu TEXT;
    DECLARE arvs TEXT;
    DECLARE full_top TEXT;
    DECLARE enc INT;
    DECLARE real_date INT;

    DECLARE cs_1 INT;
	DECLARE cs_2 INT;
	DECLARE cs_3 INT;

    DECLARE w_1 decimal;
	DECLARE w_2 decimal;
	DECLARE w_3 decimal;

    DECLARE cd4_1 decimal;
	DECLARE cd4_2 decimal;
	DECLARE cd4_3 decimal;

    DECLARE vl_1 decimal;
	DECLARE vl_2 decimal;
	DECLARE vl_3 decimal;

	DECLARE curs CURSOR FOR

    SELECT DISTINCT e.patient_id as 'patient_id'

	FROM
		encounter e
			INNER JOIN
		obs o ON (e.encounter_id = o.encounter_id
			AND o.concept_id IN (99160 , 99161)
			AND e.voided = 0
			AND o.voided = 0  AND EXTRACT(YEAR_MONTH FROM o.value_datetime) = EXTRACT(YEAR_MONTH FROM (MAKEDATE(start_year,1) + INTERVAL start_month MONTH - INTERVAL 1 DAY)))
	ORDER BY o.value_datetime ASC;

	DECLARE CONTINUE HANDLER FOR NOT FOUND SET bDone = 1;

	DROP TEMPORARY TABLE IF EXISTS art_followup_data_0_24;

	CREATE TEMPORARY TABLE IF NOT EXISTS art_followup_data_0_24 (
		patient_id int,
		arvs_fu_status TEXT,
		tb_status TEXT,
		adh_cpt TEXT,
		cs_1 INT,
		cs_2 INT,
		cs_3 INT,
		w_1 decimal,
		w_2 decimal,
		w_3 decimal,
		cd4_1 decimal,
		cd4_2 decimal,
		cd4_3 decimal,
		vl_1 decimal,
		vl_2 decimal,
		vl_3 decimal
	);

	OPEN curs;

	SET bDone = 0;

	REPEAT
		FETCH curs INTO patient;
			SET x = 0;
			SET arvs_fu_status = '';
			SET tb_status  = '';
			SET adh = '';
			SET cpt = '';
            SET arvs = '';
            SET adh_cpt = '';
			WHILE x  <= 12 DO
				SET real_date = (start_month + x);
				SET enc = getEncounterId(patient,start_year,real_date);
                SET fu = getFUARTStatus(patient,(MAKEDATE(start_year,1) + INTERVAL real_date - 1 MONTH),(MAKEDATE(start_year,1) + INTERVAL real_date MONTH - INTERVAL 1 DAY));
				SET arvs = getArtRegTxt(enc);
                IF(arvs <> '' AND fu <> '') THEN
					SET full_top = CONCAT(arvs, '/', fu);
				ELSEIF arvs <> '' THEN
					SET full_top = arvs;
				ELSEIF fu <> '' THEN
					SET full_top = fu;
                END IF;

                SET arvs_fu_status = CONCAT_WS(',', COALESCE(arvs_fu_status,''),COALESCE(full_top, ''));
				SET tb_status = CONCAT_WS(',', COALESCE(tb_status,''), COALESCE(getTbStatusTxt(enc), ''));
                SET adh = getADHStatusTxt(patient,(MAKEDATE(start_year,1) + INTERVAL real_date - 1 MONTH),(MAKEDATE(start_year,1) + INTERVAL real_date MONTH - INTERVAL 1 DAY));
				SET cpt = getCptStatusTxt(enc);
                IF(adh <> '' AND cpt <> '') THEN
					SET adh_cpt_all = CONCAT(adh, '|', cpt);
				ELSEIF adh <> '' THEN
					SET adh_cpt_all = adh;
				ELSEIF cpt <> '' THEN
					SET adh_cpt_all = cpt;
                END IF;
				SET adh_cpt = CONCAT_WS(',', COALESCE(adh_cpt,''),COALESCE(adh_cpt_all, ''));
				SET  x = x + 1;
			END WHILE;
            IF(patient > 0) THEN
			INSERT INTO art_followup_data_0_24(
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
            )VALUES (
            patient,
            SUBSTR(arvs_fu_status,2),
            SUBSTR(tb_status,2),
            SUBSTR(adh_cpt,2),
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
        END IF;
	UNTIL bDone END REPEAT;

    CLOSE curs;

    SELECT
		*
	FROM
		art_followup_data_0_24;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `GetARTFollowupData25_48`(IN start_year INT, IN start_month INTEGER)
BEGIN
	DECLARE bDone INT;

	DECLARE patient INT;
    DECLARE x INT;
    DECLARE arvs_fu_status TEXT;
    DECLARE tb_status TEXT;
    DECLARE adh TEXT;
    DECLARE cpt TEXT;
    DECLARE adh_cpt_all TEXT;
	DECLARE adh_cpt TEXT;
    DECLARE fu TEXT;
    DECLARE arvs TEXT;
    DECLARE full_top TEXT;
    DECLARE enc INT;
    DECLARE real_date INT;

    DECLARE cs_1 INT;
	DECLARE cs_2 INT;

    DECLARE w_1 decimal;
	DECLARE w_2 decimal;

    DECLARE cd4_1 decimal;
	DECLARE cd4_2 decimal;

    DECLARE vl_1 decimal;
	DECLARE vl_2 decimal;

	DECLARE curs CURSOR FOR
    SELECT
    e.patient_id as 'patient_id'

FROM
    encounter e
        INNER JOIN
    obs o ON (e.encounter_id = o.encounter_id
        AND o.concept_id IN (99160 , 99161)
        AND e.voided = 0
        AND o.voided = 0  AND EXTRACT(YEAR_MONTH FROM o.value_datetime) = EXTRACT(YEAR_MONTH FROM (MAKEDATE(start_year,1) + INTERVAL start_month MONTH - INTERVAL 1 DAY)))
ORDER BY o.value_datetime ASC;

	DECLARE CONTINUE HANDLER FOR NOT FOUND SET bDone = 1;

    DROP TEMPORARY TABLE IF EXISTS art_followup_data_25_48;

CREATE TEMPORARY TABLE IF NOT EXISTS art_followup_data_25_48 (

patient_id int,
		arvs_fu_status TEXT,
		tb_status TEXT,
		adh_cpt TEXT,
		cs_1 INT,
		cs_2 INT,
		w_1 decimal,
		w_2 decimal,
		cd4_1 decimal,
		cd4_2 decimal,
		vl_1 decimal,
		vl_2 decimal
);

OPEN curs;

SET bDone = 0;

REPEAT
FETCH curs INTO patient;
	SET x = 25;
    SET arvs_fu_status = '';
	SET tb_status  = '';
	SET adh = '';
	SET cpt = '';
	SET arvs = '';
	SET adh_cpt = '';
	WHILE x  <= 48 DO
		SET real_date = (start_month + x);
		SET enc = getEncounterId(patient,start_year,real_date);
		SET fu = getFUARTStatus(patient,(MAKEDATE(start_year,1) + INTERVAL real_date - 1 MONTH),(MAKEDATE(start_year,1) + INTERVAL real_date MONTH - INTERVAL 1 DAY));
		SET arvs = getArtRegTxt(enc);
		IF(arvs <> '' AND fu <> '') THEN
			SET full_top = CONCAT(arvs, '/', fu);
		ELSEIF arvs <> '' THEN
			SET full_top = arvs;
		ELSEIF fu <> '' THEN
			SET full_top = fu;
		END IF;

		SET arvs_fu_status = CONCAT_WS(',', COALESCE(arvs_fu_status,''),COALESCE(full_top, ''));
		SET tb_status = CONCAT_WS(',', COALESCE(tb_status,''), COALESCE(getTbStatusTxt(enc), ''));
		SET adh = getADHStatusTxt(patient,(MAKEDATE(start_year,1) + INTERVAL real_date - 1 MONTH),(MAKEDATE(start_year,1) + INTERVAL real_date MONTH - INTERVAL 1 DAY));
		SET cpt = getCptStatusTxt(enc);
		IF(adh <> '' AND cpt <> '') THEN
			SET adh_cpt_all = CONCAT(adh, '|', cpt);
		ELSEIF adh <> '' THEN
			SET adh_cpt_all = adh;
		ELSEIF cpt <> '' THEN
			SET adh_cpt_all = cpt;
		END IF;
		SET adh_cpt = CONCAT_WS(',', COALESCE(adh_cpt,''),COALESCE(adh_cpt_all, ''));
		SET  x = x + 1;
	END WHILE;
    IF(patient > 0) THEN
	INSERT INTO art_followup_data_25_48(
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
            SUBSTR(arvs_fu_status,2),
            SUBSTR(tb_status,2),
            SUBSTR(adh_cpt,2),
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
SELECT
    *
FROM
    art_followup_data_25_48;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `GetARTFollowupData49_72`(IN start_year INT, IN start_month INTEGER)
BEGIN
	DECLARE bDone INT;

	DECLARE patient INT;
    DECLARE x INT;
    DECLARE arvs_fu_status TEXT;
    DECLARE tb_status TEXT;
    DECLARE adh TEXT;
    DECLARE cpt TEXT;
    DECLARE adh_cpt_all TEXT;
	DECLARE adh_cpt TEXT;
    DECLARE fu TEXT;
    DECLARE arvs TEXT;
    DECLARE full_top TEXT;
    DECLARE enc INT;
    DECLARE real_date INT;

    DECLARE cs_1 INT;
	DECLARE cs_2 INT;

    DECLARE w_1 decimal;
	DECLARE w_2 decimal;

    DECLARE cd4_1 decimal;
	DECLARE cd4_2 decimal;

    DECLARE vl_1 decimal;
	DECLARE vl_2 decimal;
	DECLARE curs CURSOR FOR
    SELECT
    e.patient_id as 'patient_id'

FROM
    encounter e
        INNER JOIN
    obs o ON (e.encounter_id = o.encounter_id
        AND o.concept_id IN (99160 , 99161)
        AND e.voided = 0
        AND o.voided = 0  AND EXTRACT(YEAR_MONTH FROM o.value_datetime) = EXTRACT(YEAR_MONTH FROM (MAKEDATE(start_year,1) + INTERVAL start_month MONTH - INTERVAL 1 DAY)))
ORDER BY o.value_datetime ASC;

	DECLARE CONTINUE HANDLER FOR NOT FOUND SET bDone = 1;

    DROP TEMPORARY TABLE IF EXISTS art_followup_data_49_72;

CREATE TEMPORARY TABLE IF NOT EXISTS art_followup_data_49_72 (
		patient_id int,
		arvs_fu_status TEXT,
		tb_status TEXT,
		adh_cpt TEXT,
		cs_1 INT,
		cs_2 INT,
		w_1 decimal,
		w_2 decimal,
		cd4_1 decimal,
		cd4_2 decimal,
		vl_1 decimal,
		vl_2 decimal
);

OPEN curs;

SET bDone = 0;

REPEAT
FETCH curs INTO patient;
	SET x = 49;
    SET arvs_fu_status = '';
	SET tb_status  = '';
	SET adh = '';
	SET cpt = '';
	SET arvs = '';
	SET adh_cpt = '';
	WHILE x  <= 72 DO
		SET real_date = (start_month + x);
		SET enc = getEncounterId(patient,start_year,real_date);
		SET fu = getFUARTStatus(patient,(MAKEDATE(start_year,1) + INTERVAL real_date - 1 MONTH),(MAKEDATE(start_year,1) + INTERVAL real_date MONTH - INTERVAL 1 DAY));
		SET arvs = getArtRegTxt(enc);
		IF(arvs <> '' AND fu <> '') THEN
			SET full_top = CONCAT(arvs, '/', fu);
		ELSEIF arvs <> '' THEN
			SET full_top = arvs;
		ELSEIF fu <> '' THEN
			SET full_top = fu;
		END IF;

		SET arvs_fu_status = CONCAT_WS(',', COALESCE(arvs_fu_status,''),COALESCE(full_top, ''));
		SET tb_status = CONCAT_WS(',', COALESCE(tb_status,''), COALESCE(getTbStatusTxt(enc), ''));
		SET adh = getADHStatusTxt(patient,(MAKEDATE(start_year,1) + INTERVAL real_date - 1 MONTH),(MAKEDATE(start_year,1) + INTERVAL real_date MONTH - INTERVAL 1 DAY));
		SET cpt = getCptStatusTxt(enc);
		IF(adh <> '' AND cpt <> '') THEN
			SET adh_cpt_all = CONCAT(adh, '|', cpt);
		ELSEIF adh <> '' THEN
			SET adh_cpt_all = adh;
		ELSEIF cpt <> '' THEN
			SET adh_cpt_all = cpt;
		END IF;
		SET adh_cpt = CONCAT_WS(',', COALESCE(adh_cpt,''),COALESCE(adh_cpt_all, ''));
		SET  x = x + 1;
	END WHILE;
    IF(patient > 0) THEN
	INSERT INTO art_followup_data_49_72(
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
            SUBSTR(arvs_fu_status,2),
            SUBSTR(tb_status,2),
            SUBSTR(adh_cpt,2),
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
SELECT
    *
FROM
    art_followup_data_49_72;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getPreARTData`(IN start_year INT)
BEGIN

DECLARE bDone INT;

DECLARE date_enrolled_in_care date;

DECLARE unique_id CHAR(25);

DECLARE patient_id int;

DECLARE surname char(40);
DECLARE given_name char(40);

DECLARE sex char(40);

DECLARE age int;

DECLARE district CHAR(30);
DECLARE sub_county CHAR(30);
DECLARE village_cell CHAR(30);

DECLARE entry_point CHAR(15);

DECLARE status_at_enrollment CHAR(10);

DECLARE cpt_start_date date;
DECLARE cpt_stop_date date;

DECLARE inh_start_date date;
DECLARE inh_stop_date date;

DECLARE tb_reg_no CHAR(15);
DECLARE tb_start_date date;
DECLARE tb_stop_date date;

DECLARE who_stage_1 DATE;
DECLARE who_stage_2 DATE;
DECLARE who_stage_3 DATE;
DECLARE who_stage_4 DATE;


DECLARE date_eligible_for_art date;

DECLARE why_eligible CHAR(15);

DECLARE date_eligible_and_ready_for_art date;

DECLARE date_art_started date;


DECLARE curs CURSOR FOR SELECT DISTINCT
	getEnrolDate(e.patient_id) as 'date_enrolled_in_care',
	getPatientIdentifierTxt(e.patient_id) as 'unique_id',
	e.patient_id as 'patient_id',
	pp.gender as 'sex',
	TIMESTAMPDIFF(YEAR,pp.birthdate,CURDATE()) AS 'age',
	getCareEntryTxt(e.patient_id) as 'entry_point',
	getCptStartDate(e.patient_id) as 'cpt_start_date',
	getINHStartDate(e.patient_id) as 'inh_start_date',
	getTbRegNoTxt(e.patient_id) as 'tb_reg_no',
	getTbStartDate(e.patient_id) as 'tb_start_date',
	getTbStopDate(e.patient_id) as 'tb_stop_date',
	getWHOStageDate(e.patient_id,1) as 'who_stage_1',
	getWHOStageDate(e.patient_id,2) as 'who_stage_2',
	getWHOStageDate(e.patient_id,3) as 'who_stage_3',
	getWHOStageDate(e.patient_id,4) as 'who_stage_4',
	getArtEligibilityDate(e.patient_id) as 'date_eligible_for_art',
	getArtEligibilityReasonTxt(e.patient_id) as 'why_eligible',
    getArtEligibilityAndReadyDate(e.patient_id) as 'date_eligible_and_ready_for_art',
	getArtBaseTransferDate(e.patient_id) as 'date_art_started'
FROM
    person pp INNER JOIN patient p ON (pp.person_id = p.patient_id AND p.voided = 0)
  INNER JOIN encounter e ON (e.patient_id = p.patient_id AND e.voided = 0 AND YEAR(e.encounter_datetime) = start_year) INNER JOIN form f ON(e.form_id = f.form_id AND f.uuid = '12de5bc5-352e-4faf-9961-a2125085a75c' ) order by e.encounter_datetime;

DECLARE CONTINUE HANDLER FOR NOT FOUND SET bDone = 1;

DROP TEMPORARY TABLE IF EXISTS artPreData;

CREATE TEMPORARY TABLE IF NOT EXISTS artPreData (
date_enrolled_in_care date,
unique_id CHAR(25),
patient_id int,
surname char(40),
given_name char(40),
sex char(40),
age int,
district CHAR(30),
sub_county CHAR(30),
village_cell CHAR(30),
entry_point CHAR(15),
status_at_enrollment CHAR(10),
cpt_start_date date,
cpt_stop_date date,
inh_start_date date,
inh_stop_date date,
tb_reg_no CHAR(15),
tb_start_date date,
tb_stop_date date,
who_stage_1 DATE,
who_stage_2 DATE,
who_stage_3 DATE,
who_stage_4 DATE,
date_eligible_for_art date,
why_eligible CHAR(15),
date_eligible_and_ready_for_art date,
date_art_started date);

 OPEN curs;

  SET bDone = 0;

  REPEAT
    FETCH curs INTO date_enrolled_in_care,unique_id,patient_id,sex,age,entry_point,cpt_start_date,inh_start_date,tb_reg_no,tb_start_date,tb_stop_date,who_stage_1,who_stage_2,who_stage_3,who_stage_4,date_eligible_for_art,why_eligible,date_eligible_and_ready_for_art,date_art_started;
    SELECT CONCAT(given_name,COALESCE(middle_name,'')), family_name INTO given_name , surname FROM person_name WHERE person_id = patient_id LIMIT 1;
    SELECT county_district, state_province, city_village INTO district , sub_county , village_cell FROM person_address WHERE person_id = patient_id LIMIT 1;
    IF(patient_id > 0 AND patient_id not IN (select DISTINCT patient_id from artPreData)) THEN
        INSERT INTO artPreData(
      date_enrolled_in_care,
      unique_id,
      patient_id,
      surname ,
      given_name ,
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
            )values(
            date_enrolled_in_care,
      unique_id,
      patient_id,
      surname ,
      given_name ,
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
    );
        END IF;
    UNTIL bDone
  END REPEAT;
CLOSE curs;
SELECT * FROM artPreData;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getPreARTFollowup`(IN start_year INTEGER)
BEGIN

DECLARE bDone INT;
DECLARE patient_id INT;
DECLARE fu_status TEXT;
DECLARE fu_status_1 CHAR(20);
DECLARE fu_status_2 CHAR(20);
DECLARE fu_status_3 CHAR(20);
DECLARE fu_status_4 CHAR(20);

DECLARE nutritinal_status_1 CHAR(20);
DECLARE nutritinal_status_2 CHAR(20);
DECLARE nutritinal_status_3 CHAR(20);
DECLARE nutritinal_status_4 CHAR(20);

DECLARE tb_status TEXT;
DECLARE cpt TEXT;
DECLARE nutritinal_status TEXT;
DECLARE x INT;
DECLARE real_date INT;

DECLARE curs CURSOR FOR SELECT DISTINCT
	e.patient_id as 'patient_id'
FROM
    person pp INNER JOIN patient p ON (pp.person_id = p.patient_id AND p.voided = 0)
	INNER JOIN encounter e ON (e.patient_id = p.patient_id AND form_id = 28 AND e.voided = 0 AND YEAR(e.encounter_datetime) = start_year)INNER JOIN form f ON(e.form_id = f.form_id AND f.uuid = '12de5bc5-352e-4faf-9961-a2125085a75c' ) order by e.encounter_datetime;

DECLARE CONTINUE HANDLER FOR NOT FOUND SET bDone = 1;

DROP TEMPORARY TABLE IF EXISTS pre_art_followup_data;

CREATE TEMPORARY TABLE IF NOT EXISTS pre_art_followup_data (patient_id int,fu_status TEXT,tb_status TEXT,cpt TEXT,nutritinal_status TEXT) ENGINE=MyISAM DEFAULT CHARSET=utf8 ;

OPEN curs;

SET bDone = 0;

REPEAT
FETCH curs INTO patient_id;
	SET x = 0;
    SET fu_status = '';
    SET tb_status  = '';
    SET cpt = '';
    SET nutritinal_status = '';
	WHILE x  < 4 DO
		SET real_date = (start_year + x);
        SET tb_status = CONCAT_WS(',',COALESCE(tb_status,'-'), COALESCE(getTbStatusTxt(getEncounterId2(patient_id,real_date,1)), '-'), COALESCE(getTbStatusTxt(getEncounterId2(patient_id,real_date,2)), '-'),COALESCE(getTbStatusTxt(getEncounterId2(patient_id,real_date,3)), '-'),COALESCE(getTbStatusTxt(getEncounterId2(patient_id,real_date,4)), '-'));
		SET cpt = CONCAT_WS(',',COALESCE(cpt,'-'), COALESCE(getCptStatusTxt(getEncounterId2(patient_id,real_date,1)), '-'), COALESCE(getCptStatusTxt(getEncounterId2(patient_id,real_date,2)), '-'),COALESCE(getCptStatusTxt(getEncounterId2(patient_id,real_date,3)), '-'),COALESCE(getCptStatusTxt(getEncounterId2(patient_id,real_date,4)), '-'));

        SET fu_status_1 = getFUStatus(patient_id, (MAKEDATE(real_date,1)),(MAKEDATE(start_year,1) + INTERVAL 1 QUARTER - INTERVAL 1 DAY));
        SET fu_status_2 = getFUStatus(patient_id, (MAKEDATE(real_date,1) + INTERVAL 1 QUARTER), (MAKEDATE(real_date,1) + INTERVAL 2 QUARTER - INTERVAL 1 DAY));
        SET fu_status_3 = getFUStatus(patient_id, (MAKEDATE(real_date,1) + INTERVAL 2 QUARTER), (MAKEDATE(real_date,1) + INTERVAL 3 QUARTER - INTERVAL 1 DAY));
        SET fu_status_4 = getFUStatus(patient_id, (MAKEDATE(real_date,1) + INTERVAL 3 QUARTER), (MAKEDATE(real_date,1) + INTERVAL 4 QUARTER - INTERVAL 1 DAY));

        SET nutritinal_status_1 = getNutritionalStatus(patient_id, (MAKEDATE(real_date,1)),(MAKEDATE(start_year,1) + INTERVAL 1 QUARTER - INTERVAL 1 DAY));
        SET nutritinal_status_2 = getNutritionalStatus(patient_id, (MAKEDATE(real_date,1) + INTERVAL 1 QUARTER), (MAKEDATE(real_date,1) + INTERVAL 2 QUARTER - INTERVAL 1 DAY));
        SET nutritinal_status_3 = getNutritionalStatus(patient_id, (MAKEDATE(real_date,1) + INTERVAL 2 QUARTER), (MAKEDATE(real_date,1) + INTERVAL 3 QUARTER - INTERVAL 1 DAY));
        SET nutritinal_status_4 = getNutritionalStatus(patient_id, (MAKEDATE(real_date,1) + INTERVAL 3 QUARTER), (MAKEDATE(real_date,1) + INTERVAL 4 QUARTER - INTERVAL 1 DAY));

        SET fu_status = CONCAT_WS(',',COALESCE(fu_status,'-'),COALESCE(fu_status_1,'-'),COALESCE(fu_status_2,'-'),COALESCE(fu_status_3,'-'),COALESCE(fu_status_4,'-'));
		SET nutritinal_status = CONCAT_WS(',',COALESCE(nutritinal_status,'-'),COALESCE(nutritinal_status_1,'-'),COALESCE(nutritinal_status_2,'-'),COALESCE(nutritinal_status_3,'-'),COALESCE(nutritinal_status_4,'-'));
        SET  x = x + 1;
	END WHILE;
    IF(patient_id > 0) THEN
		INSERT INTO pre_art_followup_data(patient_id,fu_status,tb_status,cpt,nutritinal_status) VALUES (patient_id,SUBSTR(fu_status,2),SUBSTR(tb_status,2),SUBSTR(cpt,2),SUBSTR(nutritinal_status,2));
	END IF;
UNTIL bDone END REPEAT;
CLOSE curs;
SELECT
    *
FROM
    pre_art_followup_data;

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `hmis106a1b`(IN start_year INTEGER, IN start_quarter INT)
BEGIN
	DECLARE h11a CHAR(255) DEFAULT 'All patients 6 months';
	DECLARE h12a CHAR(100) DEFAULT getCohortMonth(start_year,start_quarter,6);
	DECLARE h13a INT DEFAULT getCohortAllBefore3(start_year,start_quarter,6,null);
	DECLARE h14a CHAR(20) DEFAULT CONCAT(getCohortAllBefore4a(start_year,start_quarter,6,null),'/',getCohortAllBefore4b(start_year,start_quarter,6,null));
	DECLARE h15a INT DEFAULT getCohortAllBefore5(start_year,start_quarter,6,null);
	DECLARE h16a INT DEFAULT getCohortAllBefore6(start_year,start_quarter,6,null);
	DECLARE h17a INT DEFAULT getCohortAllBefore7(start_year,start_quarter,6,null);
	DECLARE h18a INT DEFAULT h13a + h16a - h17a;
	DECLARE h19a INT DEFAULT getCohortAllBefore9(start_year,start_quarter,6,null);
	DECLARE h110a INT DEFAULT getCohortAllBefore10(start_year,start_quarter,6,null);
	DECLARE h111a INT DEFAULT getCohortAllBefore11(start_year,start_quarter,6,null);
	DECLARE h112a INT DEFAULT getCohortAllBefore12(start_year,start_quarter,6,null);
	DECLARE h113a INT DEFAULT h18a-h19a-h110a-h111a-h112a;
	DECLARE h114a DECIMAL DEFAULT (h113a/h18a)*100;
	DECLARE h115a CHAR(20) DEFAULT CONCAT(getCohortAllBefore15a(start_year,start_quarter,6,null),'/',getCohortAllBefore15b(start_year,start_quarter,6,null));
	DECLARE h116a INT DEFAULT getCohortAllBefore16(start_year,start_quarter,6,null);

	DECLARE h21a CHAR(255) DEFAULT 'All patients 12 months';
	DECLARE h22a CHAR(100) DEFAULT getCohortMonth(start_year,start_quarter,12);
	DECLARE h23a INT DEFAULT getCohortAllBefore3(start_year,start_quarter,12,null);
	DECLARE h24a CHAR(20) DEFAULT CONCAT(getCohortAllBefore4a(start_year,start_quarter,12,null),'/',getCohortAllBefore4b(start_year,start_quarter,12,null));
	DECLARE h25a INT DEFAULT getCohortAllBefore5(start_year,start_quarter,12,null);
	DECLARE h26a INT DEFAULT getCohortAllBefore6(start_year,start_quarter,12,null);
	DECLARE h27a INT DEFAULT getCohortAllBefore7(start_year,start_quarter,12,null);
	DECLARE h28a INT DEFAULT h23a + h26a - h27a;
	DECLARE h29a INT DEFAULT getCohortAllBefore9(start_year,start_quarter,12,null);
	DECLARE h210a INT DEFAULT getCohortAllBefore10(start_year,start_quarter,12,null);
	DECLARE h211a INT DEFAULT getCohortAllBefore11(start_year,start_quarter,12,null);
	DECLARE h212a INT DEFAULT getCohortAllBefore12(start_year,start_quarter,12,null);
	DECLARE h213a INT DEFAULT h28a-h29a-h210a-h211a-h212a;
	DECLARE h214a DECIMAL DEFAULT (h213a/h28a)*100;
	DECLARE h215a CHAR(20) DEFAULT CONCAT(getCohortAllBefore15a(start_year,start_quarter,12,null),'/',getCohortAllBefore15b(start_year,start_quarter,12,null));
	DECLARE h216a INT DEFAULT getCohortAllBefore16(start_year,start_quarter,12,null);

	DECLARE h31a CHAR(255) DEFAULT 'All patients 24 months';
	DECLARE h32a CHAR(100) DEFAULT getCohortMonth(start_year,start_quarter,24);
	DECLARE h33a INT DEFAULT getCohortAllBefore3(start_year,start_quarter,24,null);
	DECLARE h34a CHAR(20) DEFAULT CONCAT(getCohortAllBefore4a(start_year,start_quarter,24,null),'/',getCohortAllBefore4b(start_year,start_quarter,24,null));
	DECLARE h35a INT DEFAULT getCohortAllBefore5(start_year,start_quarter,24,null);
	DECLARE h36a INT DEFAULT getCohortAllBefore6(start_year,start_quarter,24,null);
	DECLARE h37a INT DEFAULT getCohortAllBefore7(start_year,start_quarter,24,null);
	DECLARE h38a INT DEFAULT h33a + h36a - h37a;
	DECLARE h39a INT DEFAULT getCohortAllBefore9(start_year,start_quarter,24,null);
	DECLARE h310a INT DEFAULT getCohortAllBefore10(start_year,start_quarter,24,null);
	DECLARE h311a INT DEFAULT getCohortAllBefore11(start_year,start_quarter,24,null);
	DECLARE h312a INT DEFAULT getCohortAllBefore12(start_year,start_quarter,24,null);
	DECLARE h313a INT DEFAULT h38a-h39a-h310a-h311a-h312a;
	DECLARE h314a DECIMAL DEFAULT (h313a/h38a)*100;
	DECLARE h315a CHAR(20) DEFAULT CONCAT(getCohortAllBefore15a(start_year,start_quarter,24,null),'/',getCohortAllBefore15b(start_year,start_quarter,24,null));
	DECLARE h316a INT DEFAULT getCohortAllBefore16(start_year,start_quarter,24,null);

	DECLARE h41a CHAR(255) DEFAULT 'All patients 36 months';
	DECLARE h42a CHAR(100) DEFAULT getCohortMonth(start_year,start_quarter,36);
	DECLARE h43a INT DEFAULT getCohortAllBefore3(start_year,start_quarter,36,null);
	DECLARE h44a CHAR(20) DEFAULT CONCAT(getCohortAllBefore4a(start_year,start_quarter,36,null),'/',getCohortAllBefore4b(start_year,start_quarter,36,null));
	DECLARE h45a INT DEFAULT getCohortAllBefore5(start_year,start_quarter,36,null);
	DECLARE h46a INT DEFAULT getCohortAllBefore6(start_year,start_quarter,36,null);
	DECLARE h47a INT DEFAULT getCohortAllBefore7(start_year,start_quarter,36,null);
	DECLARE h48a INT DEFAULT h43a + h46a - h47a;
	DECLARE h49a INT DEFAULT getCohortAllBefore9(start_year,start_quarter,36,null);
	DECLARE h410a INT DEFAULT getCohortAllBefore10(start_year,start_quarter,36,null);
	DECLARE h411a INT DEFAULT getCohortAllBefore11(start_year,start_quarter,36,null);
	DECLARE h412a INT DEFAULT getCohortAllBefore12(start_year,start_quarter,36,null);
	DECLARE h413a INT DEFAULT h48a-h49a-h410a-h411a-h412a;
	DECLARE h414a DECIMAL DEFAULT (h413a/h48a)*100;
	DECLARE h415a CHAR(20) DEFAULT CONCAT(getCohortAllBefore15a(start_year,start_quarter,36,null),'/',getCohortAllBefore15b(start_year,start_quarter,36,null));
	DECLARE h416a INT DEFAULT getCohortAllBefore16(start_year,start_quarter,36,null);

	DECLARE h51a CHAR(255) DEFAULT 'All patients 48 months';
	DECLARE h52a CHAR(100) DEFAULT getCohortMonth(start_year,start_quarter,48);
	DECLARE h53a INT DEFAULT getCohortAllBefore3(start_year,start_quarter,48,null);
	DECLARE h54a CHAR(20) DEFAULT CONCAT(getCohortAllBefore4a(start_year,start_quarter,48,null),'/',getCohortAllBefore4b(start_year,start_quarter,48,null));
	DECLARE h55a INT DEFAULT getCohortAllBefore5(start_year,start_quarter,48,null);
	DECLARE h56a INT DEFAULT getCohortAllBefore6(start_year,start_quarter,48,null);
	DECLARE h57a INT DEFAULT getCohortAllBefore7(start_year,start_quarter,48,null);
	DECLARE h58a INT DEFAULT h53a + h56a - h57a;
	DECLARE h59a INT DEFAULT getCohortAllBefore9(start_year,start_quarter,48,null);
	DECLARE h510a INT DEFAULT getCohortAllBefore10(start_year,start_quarter,48,null);
	DECLARE h511a INT DEFAULT getCohortAllBefore11(start_year,start_quarter,48,null);
	DECLARE h512a INT DEFAULT getCohortAllBefore12(start_year,start_quarter,48,null);
	DECLARE h513a INT DEFAULT h58a-h59a-h510a-h511a-h512a;
	DECLARE h514a DECIMAL DEFAULT (h513a/h58a)*100;
	DECLARE h515a CHAR(20) DEFAULT CONCAT(getCohortAllBefore15a(start_year,start_quarter,48,null),'/',getCohortAllBefore15b(start_year,start_quarter,48,null));
	DECLARE h516a INT DEFAULT getCohortAllBefore16(start_year,start_quarter,48,null);

	DECLARE h61a CHAR(255) DEFAULT 'All patients 60 months';
	DECLARE h62a CHAR(100) DEFAULT getCohortMonth(start_year,start_quarter,60);
	DECLARE h63a INT DEFAULT getCohortAllBefore3(start_year,start_quarter,60,null);
	DECLARE h64a CHAR(20) DEFAULT CONCAT(getCohortAllBefore4a(start_year,start_quarter,60,null),'/',getCohortAllBefore4b(start_year,start_quarter,60,null));
	DECLARE h65a INT DEFAULT getCohortAllBefore5(start_year,start_quarter,60,null);
	DECLARE h66a INT DEFAULT getCohortAllBefore6(start_year,start_quarter,60,null);
	DECLARE h67a INT DEFAULT getCohortAllBefore7(start_year,start_quarter,60,null);
	DECLARE h68a INT DEFAULT h63a + h66a - h67a;
	DECLARE h69a INT DEFAULT getCohortAllBefore9(start_year,start_quarter,60,null);
	DECLARE h610a INT DEFAULT getCohortAllBefore10(start_year,start_quarter,60,null);
	DECLARE h611a INT DEFAULT getCohortAllBefore11(start_year,start_quarter,60,null);
	DECLARE h612a INT DEFAULT getCohortAllBefore12(start_year,start_quarter,60,null);
	DECLARE h613a INT DEFAULT h68a-h69a-h610a-h611a-h612a;
	DECLARE h614a DECIMAL DEFAULT (h613a/h68a)*100;
	DECLARE h615a CHAR(20) DEFAULT CONCAT(getCohortAllBefore15a(start_year,start_quarter,60,null),'/',getCohortAllBefore15b(start_year,start_quarter,60,null));
	DECLARE h616a INT DEFAULT getCohortAllBefore16(start_year,start_quarter,60,null);

	DECLARE h71a CHAR(255) DEFAULT 'All patients 72 months';
	DECLARE h72a CHAR(100) DEFAULT getCohortMonth(start_year,start_quarter,72);
	DECLARE h73a INT DEFAULT getCohortAllBefore3(start_year,start_quarter,72,null);
	DECLARE h74a CHAR(20) DEFAULT CONCAT(getCohortAllBefore4a(start_year,start_quarter,72,null),'/',getCohortAllBefore4b(start_year,start_quarter,72,null));
	DECLARE h75a INT DEFAULT getCohortAllBefore5(start_year,start_quarter,72,null);
	DECLARE h76a INT DEFAULT getCohortAllBefore6(start_year,start_quarter,72,null);
	DECLARE h77a INT DEFAULT getCohortAllBefore7(start_year,start_quarter,72,null);
	DECLARE h78a INT DEFAULT h73a + h76a - h77a;
	DECLARE h79a INT DEFAULT getCohortAllBefore9(start_year,start_quarter,72,null);
	DECLARE h710a INT DEFAULT getCohortAllBefore10(start_year,start_quarter,72,null);
	DECLARE h711a INT DEFAULT getCohortAllBefore11(start_year,start_quarter,72,null);
	DECLARE h712a INT DEFAULT getCohortAllBefore12(start_year,start_quarter,72,null);
	DECLARE h713a INT DEFAULT h18a-h79a-h710a-h171a-h712a;
	DECLARE h714a DECIMAL DEFAULT (h713a/h78a)*100;
	DECLARE h715a CHAR(20) DEFAULT CONCAT(getCohortAllBefore15a(start_year,start_quarter,72,null),'/',getCohortAllBefore15b(start_year,start_quarter,72,null));
	DECLARE h716a INT DEFAULT getCohortAllBefore16(start_year,start_quarter,72,null);

	DECLARE h11b CHAR(255) DEFAULT 'eMTCT Mothers 6 months';
	DECLARE h12b CHAR(100) DEFAULT getCohortMonth(start_year,start_quarter,6);
	DECLARE h13b INT DEFAULT getCohortAllBefore3(start_year,start_quarter,6,true);
	DECLARE h14b CHAR(20) DEFAULT CONCAT(getCohortAllBefore4b(start_year,start_quarter,6,true),'/',getCohortAllBefore4b(start_year,start_quarter,6,true));
	DECLARE h15b INT DEFAULT getCohortAllBefore5(start_year,start_quarter,6,true);
	DECLARE h16b INT DEFAULT getCohortAllBefore6(start_year,start_quarter,6,true);
	DECLARE h17b INT DEFAULT getCohortAllBefore7(start_year,start_quarter,6,true);
	DECLARE h18b INT DEFAULT h13b + h16b - h17b;
	DECLARE h19b INT DEFAULT getCohortAllBefore9(start_year,start_quarter,6,true);
	DECLARE h110b INT DEFAULT getCohortAllBefore10(start_year,start_quarter,6,true);
	DECLARE h111b INT DEFAULT getCohortAllBefore11(start_year,start_quarter,6,true);
	DECLARE h112b INT DEFAULT getCohortAllBefore12(start_year,start_quarter,6,true);
	DECLARE h113b INT DEFAULT h18b-h19b-h110b-h111b-h112b;
	DECLARE h114b DECIMAL DEFAULT (h113b/h18b)*100;
	DECLARE h115b CHAR(20) DEFAULT CONCAT(getCohortAllBefore15b(start_year,start_quarter,6,true),'/',getCohortAllBefore15b(start_year,start_quarter,6,true));
	DECLARE h116b INT DEFAULT getCohortAllBefore16(start_year,start_quarter,6,true);

	DECLARE h21b CHAR(255) DEFAULT 'eMTCT Mothers 12 months';
	DECLARE h22b CHAR(100) DEFAULT getCohortMonth(start_year,start_quarter,12);
	DECLARE h23b INT DEFAULT getCohortAllBefore3(start_year,start_quarter,12,true);
	DECLARE h24b CHAR(20) DEFAULT CONCAT(getCohortAllBefore4b(start_year,start_quarter,12,true),'/',getCohortAllBefore4b(start_year,start_quarter,12,true));
	DECLARE h25b INT DEFAULT getCohortAllBefore5(start_year,start_quarter,12,true);
	DECLARE h26b INT DEFAULT getCohortAllBefore6(start_year,start_quarter,12,true);
	DECLARE h27b INT DEFAULT getCohortAllBefore7(start_year,start_quarter,12,true);
	DECLARE h28b INT DEFAULT h23b + h26b - h27b;
	DECLARE h29b INT DEFAULT getCohortAllBefore9(start_year,start_quarter,12,true);
	DECLARE h210b INT DEFAULT getCohortAllBefore10(start_year,start_quarter,12,true);
	DECLARE h211b INT DEFAULT getCohortAllBefore11(start_year,start_quarter,12,true);
	DECLARE h212b INT DEFAULT getCohortAllBefore12(start_year,start_quarter,12,true);
	DECLARE h213b INT DEFAULT h28b-h29b-h210b-h211b-h212b;
	DECLARE h214b DECIMAL DEFAULT (h213b/h28b)*100;
	DECLARE h215b CHAR(20) DEFAULT CONCAT(getCohortAllBefore15b(start_year,start_quarter,12,true),'/',getCohortAllBefore15b(start_year,start_quarter,12,true));
	DECLARE h216b INT DEFAULT getCohortAllBefore16(start_year,start_quarter,12,true);

	DECLARE h31b CHAR(255) DEFAULT 'eMTCT Mothers 24 months';
	DECLARE h32b CHAR(100) DEFAULT getCohortMonth(start_year,start_quarter,24);
	DECLARE h33b INT DEFAULT getCohortAllBefore3(start_year,start_quarter,24,true);
	DECLARE h34b CHAR(20) DEFAULT CONCAT(getCohortAllBefore4b(start_year,start_quarter,24,true),'/',getCohortAllBefore4b(start_year,start_quarter,24,true));
	DECLARE h35b INT DEFAULT getCohortAllBefore5(start_year,start_quarter,24,true);
	DECLARE h36b INT DEFAULT getCohortAllBefore6(start_year,start_quarter,24,true);
	DECLARE h37b INT DEFAULT getCohortAllBefore7(start_year,start_quarter,24,true);
	DECLARE h38b INT DEFAULT h33b + h36b - h37b;
	DECLARE h39b INT DEFAULT getCohortAllBefore9(start_year,start_quarter,24,true);
	DECLARE h310b INT DEFAULT getCohortAllBefore10(start_year,start_quarter,24,true);
	DECLARE h311b INT DEFAULT getCohortAllBefore11(start_year,start_quarter,24,true);
	DECLARE h312b INT DEFAULT getCohortAllBefore12(start_year,start_quarter,24,true);
	DECLARE h313b INT DEFAULT h38b-h39b-h310b-h311b-h312b;
	DECLARE h314b DECIMAL DEFAULT (h313b/h38b)*100;
	DECLARE h315b CHAR(20) DEFAULT CONCAT(getCohortAllBefore15b(start_year,start_quarter,24,true),'/',getCohortAllBefore15b(start_year,start_quarter,24,true));
	DECLARE h316b INT DEFAULT getCohortAllBefore16(start_year,start_quarter,24,true);

	DECLARE h41b CHAR(255) DEFAULT 'eMTCT Mothers 36 months';
	DECLARE h42b CHAR(100) DEFAULT getCohortMonth(start_year,start_quarter,36);
	DECLARE h43b INT DEFAULT getCohortAllBefore3(start_year,start_quarter,36,true);
	DECLARE h44b CHAR(20) DEFAULT CONCAT(getCohortAllBefore4b(start_year,start_quarter,36,true),'/',getCohortAllBefore4b(start_year,start_quarter,36,true));
	DECLARE h45b INT DEFAULT getCohortAllBefore5(start_year,start_quarter,36,true);
	DECLARE h46b INT DEFAULT getCohortAllBefore6(start_year,start_quarter,36,true);
	DECLARE h47b INT DEFAULT getCohortAllBefore7(start_year,start_quarter,36,true);
	DECLARE h48b INT DEFAULT h43b + h46b - h47b;
	DECLARE h49b INT DEFAULT getCohortAllBefore9(start_year,start_quarter,36,true);
	DECLARE h410b INT DEFAULT getCohortAllBefore10(start_year,start_quarter,36,true);
	DECLARE h411b INT DEFAULT getCohortAllBefore11(start_year,start_quarter,36,true);
	DECLARE h412b INT DEFAULT getCohortAllBefore12(start_year,start_quarter,36,true);
	DECLARE h413b INT DEFAULT h48b-h49b-h410b-h411b-h412b;
	DECLARE h414b DECIMAL DEFAULT (h413b/h48b)*100;
	DECLARE h415b CHAR(20) DEFAULT CONCAT(getCohortAllBefore15b(start_year,start_quarter,36,true),'/',getCohortAllBefore15b(start_year,start_quarter,36,true));
	DECLARE h416b INT DEFAULT getCohortAllBefore16(start_year,start_quarter,36,true);

	DECLARE h51b CHAR(255) DEFAULT 'eMTCT Mothers 48 months';
	DECLARE h52b CHAR(100) DEFAULT getCohortMonth(start_year,start_quarter,48);
	DECLARE h53b INT DEFAULT getCohortAllBefore3(start_year,start_quarter,48,true);
	DECLARE h54b CHAR(20) DEFAULT CONCAT(getCohortAllBefore4b(start_year,start_quarter,48,true),'/',getCohortAllBefore4b(start_year,start_quarter,48,true));
	DECLARE h55b INT DEFAULT getCohortAllBefore5(start_year,start_quarter,48,true);
	DECLARE h56b INT DEFAULT getCohortAllBefore6(start_year,start_quarter,48,true);
	DECLARE h57b INT DEFAULT getCohortAllBefore7(start_year,start_quarter,48,true);
	DECLARE h58b INT DEFAULT h53b + h56b - h57b;
	DECLARE h59b INT DEFAULT getCohortAllBefore9(start_year,start_quarter,48,true);
	DECLARE h510b INT DEFAULT getCohortAllBefore10(start_year,start_quarter,48,true);
	DECLARE h511b INT DEFAULT getCohortAllBefore11(start_year,start_quarter,48,true);
	DECLARE h512b INT DEFAULT getCohortAllBefore12(start_year,start_quarter,48,true);
	DECLARE h513b INT DEFAULT h58b-h59b-h510b-h511b-h512b;
	DECLARE h514b DECIMAL DEFAULT (h513b/h58b)*100;
	DECLARE h515b CHAR(20) DEFAULT CONCAT(getCohortAllBefore15b(start_year,start_quarter,48,true),'/',getCohortAllBefore15b(start_year,start_quarter,48,true));
	DECLARE h516b INT DEFAULT getCohortAllBefore16(start_year,start_quarter,48,true);

	DECLARE h61b CHAR(255) DEFAULT 'eMTCT Mothers 60 months';
	DECLARE h62b CHAR(100) DEFAULT getCohortMonth(start_year,start_quarter,60);
	DECLARE h63b INT DEFAULT getCohortAllBefore3(start_year,start_quarter,60,true);
	DECLARE h64b CHAR(20) DEFAULT CONCAT(getCohortAllBefore4b(start_year,start_quarter,60,true),'/',getCohortAllBefore4b(start_year,start_quarter,60,true));
	DECLARE h65b INT DEFAULT getCohortAllBefore5(start_year,start_quarter,60,true);
	DECLARE h66b INT DEFAULT getCohortAllBefore6(start_year,start_quarter,60,true);
	DECLARE h67b INT DEFAULT getCohortAllBefore7(start_year,start_quarter,60,true);
	DECLARE h68b INT DEFAULT h63b + h66b - h67b;
	DECLARE h69b INT DEFAULT getCohortAllBefore9(start_year,start_quarter,60,true);
	DECLARE h610b INT DEFAULT getCohortAllBefore10(start_year,start_quarter,60,true);
	DECLARE h611b INT DEFAULT getCohortAllBefore11(start_year,start_quarter,60,true);
	DECLARE h612b INT DEFAULT getCohortAllBefore12(start_year,start_quarter,60,true);
	DECLARE h613b INT DEFAULT h68b-h69b-h610b-h611b-h612b;
	DECLARE h614b DECIMAL DEFAULT (h613b/h68b)*100;
	DECLARE h615b CHAR(20) DEFAULT CONCAT(getCohortAllBefore15b(start_year,start_quarter,60,true),'/',getCohortAllBefore15b(start_year,start_quarter,60,true));
	DECLARE h616b INT DEFAULT getCohortAllBefore16(start_year,start_quarter,60,true);

	DECLARE h71b CHAR(255) DEFAULT 'eMTCT Mothers 72 months';
	DECLARE h72b CHAR(100) DEFAULT getCohortMonth(start_year,start_quarter,72);
	DECLARE h73b INT DEFAULT getCohortAllBefore3(start_year,start_quarter,72,true);
	DECLARE h74b CHAR(20) DEFAULT CONCAT(getCohortAllBefore4b(start_year,start_quarter,72,true),'/',getCohortAllBefore4b(start_year,start_quarter,72,true));
	DECLARE h75b INT DEFAULT getCohortAllBefore5(start_year,start_quarter,72,true);
	DECLARE h76b INT DEFAULT getCohortAllBefore6(start_year,start_quarter,72,true);
	DECLARE h77b INT DEFAULT getCohortAllBefore7(start_year,start_quarter,72,true);
	DECLARE h78b INT DEFAULT h73b + h76b - h77b;
	DECLARE h79b INT DEFAULT getCohortAllBefore9(start_year,start_quarter,72,true);
	DECLARE h710b INT DEFAULT getCohortAllBefore10(start_year,start_quarter,72,true);
	DECLARE h711b INT DEFAULT getCohortAllBefore11(start_year,start_quarter,72,true);
	DECLARE h712b INT DEFAULT getCohortAllBefore12(start_year,start_quarter,72,true);
	DECLARE h713b INT DEFAULT h78b-h79b-h110b-h711b-h712b;
	DECLARE h714b DECIMAL DEFAULT (h713b/h78b)*100;
	DECLARE h715b CHAR(20) DEFAULT CONCAT(getCohortAllBefore15b(start_year,start_quarter,72,true),'/',getCohortAllBefore15b(start_year,start_quarter,72,true));
	DECLARE h716b INT DEFAULT getCohortAllBefore16(start_year,start_quarter,72,true);

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
CREATE DEFINER=`root`@`localhost` FUNCTION `get_adherence_Count`(AdherenceType int, StartDate Date, EndDate Date) RETURNS int(11)
    DETERMINISTIC
begin
	declare result int DEFAULT -1;

SELECT Adherence INTO result
FROM(
	SELECT count(A.person_id) AS Adherence
	FROM(
		SELECT person_id, obs_id, max(obs_datetime)
		FROM obs
		WHERE concept_id = 90221  and voided = 0
		AND obs_datetime BETWEEN StartDate AND EndDate
		GROUP BY person_id
		) A
)AA;
	RETURN result;
end$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` FUNCTION `get_adherenceType_Count`(AdherenceType int, StartDate Date, EndDate Date) RETURNS int(11)
    DETERMINISTIC
begin
	declare result int DEFAULT -1;

SELECT Adherence INTO result
FROM(
	SELECT count(A.person_id) AS Adherence
	FROM(
		SELECT person_id, obs_id, max(obs_datetime)
		FROM obs
		WHERE concept_id = 90221  and voided = 0
		AND obs_datetime BETWEEN StartDate AND EndDate
		GROUP BY person_id
		) A
	INNER JOIN obs B ON A.obs_id = B.obs_id
	WHERE b.value_coded =  AdherenceType
)AA;
	RETURN result;
end$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`openmrs`@`localhost` FUNCTION `getADHStatusTxt`(patient_id INT,start_date Date,end_date date) RETURNS char(1) CHARSET latin1
BEGIN

RETURN (select if(value_coded=90156,'G',
if(value_coded=90157,'F',
if(value_coded=90158,'P',null))) as adh_status
from obs
where concept_id =90221 and person_id = patient_id and obs_datetime BETWEEN start_date and end_date and voided=0
limit 1
);
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` FUNCTION `getAncNumberTxt`(`encounterid` integer) RETURNS char(15) CHARSET latin1
    READS SQL DATA
BEGIN


	RETURN (select value_text from obs where concept_id=99026
and encounterid=encounter_id
and voided=0
limit 1

 );
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` FUNCTION `getAppKeepTxt`(`encounterid` integer) RETURNS char(3) CHARSET latin1
    READS SQL DATA
BEGIN


RETURN (select  if(value_numeric=1, "Y", "N") as app_keep from obs
where concept_id=90069
and voided=0
and encounterid=encounter_id
limit 1

);

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` FUNCTION `getArtBaseTransferDate`(`personid` integer) RETURNS date
    READS SQL DATA
BEGIN


RETURN
(select value_datetime from obs
where concept_id in(99161,99160)
and person_id=personid
and voided=0
limit 1);


END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` FUNCTION `getArtEligibilityAndReadyDate`(`personid` integer) RETURNS date
    READS SQL DATA
BEGIN


RETURN (select value_datetime as eligible_and_ready_date from obs
where concept_id =90299
and voided=0
and personid=person_id
limit 1
);

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` FUNCTION `getArtEligibilityDate`(`personid` integer) RETURNS date
    READS SQL DATA
BEGIN


RETURN (select value_datetime as eligible_date from obs
where concept_id =90297
and voided=0
and personid=person_id
limit 1
);

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` FUNCTION `getArtEligibilityReasonTxt`(`personid` integer) RETURNS char(15) CHARSET latin1
    READS SQL DATA
BEGIN


RETURN (select
if(concept_id=99083 , "Clinical",
if(concept_id=99082 and value_numeric>=0, concat("CD4: ",value_numeric),
if(concept_id=99123,"Presumptive",
if(concept_id=99149,"PCR-Infant",''
)))) as e_reason
from obs
where concept_id in(99123,99149,99083,99082)
and voided=0
and personid=person_id
limit 1
);

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` FUNCTION `getArtRegCoded`(`encounterid` integer) RETURNS char(12) CHARSET latin1
    READS SQL DATA
BEGIN


RETURN (select value_coded as freg
from obs
where concept_id in(99061, 90315)
and voided=0
and encounterid=encounter_id
limit 1 );
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` FUNCTION `getArtRegCoded2`(`personid` integer, `obsdatetime` date) RETURNS int(11)
    READS SQL DATA
BEGIN


RETURN (select value_coded as freg
from obs
where concept_id in(99061, 90315)
and voided=0
and personid=person_id
and obsdatetime=obs_datetime
limit 1 );
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` FUNCTION `getArtRegTxt`(`encounterid` integer) RETURNS char(6) CHARSET latin1
    READS SQL DATA
BEGIN


	RETURN (select
min(if(value_coded=99015, '1a',
if(value_coded=99016, '1b',
if(value_coded=99005, '1c',
if(value_coded=99006, '1d',
if(value_coded=99039, '1e',
if(value_coded=99040, '1f',
if(value_coded=99041, '1g',
if(value_coded=99042, '1h',
if(value_coded=99007, '2a2',
if(value_coded=99008, '2a4',
if(value_coded=99044, '2b',
if(value_coded=99043, '2c',
if(value_coded=99282, '2d2',
if(value_coded=99283, '2d4',
if(value_coded=99046, '2e',
if(value_coded=99017, '5a',
if(value_coded=99018, '5b',
if(value_coded=99045,'5f',
if(value_coded=99284,'5g',
if(value_coded=99285,'5h',
if(value_coded=99286,'5j',
if(value_coded=90002,'othr',''
)))))))))))))))))))))))as freg from obs
where concept_id in(99061, 90315) and voided=0
and encounterid=encounter_id
limit 1 );
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` FUNCTION `getArtRegTxt2`(`personid` integer, `obsdatetime` date) RETURNS char(10) CHARSET latin1
    READS SQL DATA
BEGIN


	RETURN (select
min(if(value_coded=99015, '1a',
if(value_coded=99016, '1b',
if(value_coded=99005, '1c',
if(value_coded=99006, '1d',
if(value_coded=99039, '1e',
if(value_coded=99040, '1f',
if(value_coded=99041, '1g',
if(value_coded=99042, '1h',
if(value_coded=99007, '2a2',
if(value_coded=99008, '2a4',
if(value_coded=99044, '2b',
if(value_coded=99043, '2c',
if(value_coded=99282, '2d2',
if(value_coded=99283, '2d4',
if(value_coded=99046, '2e',
if(value_coded=99017, '5a',
if(value_coded=99018, '5b',
if(value_coded=99045,'5f',
if(value_coded=99284,'5g',
if(value_coded=99285,'5h',
if(value_coded=99286,'5j',
if(value_coded=90002,'othr',''
)))))))))))))))))))))))as freg
from obs
where concept_id in(99061, 90315) and voided=0
and personid=person_id
and obsdatetime=obs_datetime
limit 1 );
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` FUNCTION `getArtRestartDate`(`personid` integer,`encdt` char(6)) RETURNS date
    READS SQL DATA
BEGIN


RETURN (
select value_datetime from obs
where concept_id=99085
and voided=0
and personid=person_id
and concat(year(value_datetime),month(value_datetime))=encdt
limit 1
);

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` FUNCTION `getArtStartDate`(`personid` integer) RETURNS date
    READS SQL DATA
BEGIN


RETURN
(select value_datetime from obs
where concept_id in(99160,99161)
and personid=person_id
and voided=0
order by value_datetime asc
limit 1);


END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` FUNCTION `getArtStartDate2`(`personid` integer, `reportdt` date) RETURNS date
    READS SQL DATA
BEGIN


RETURN
(select value_datetime from obs
where concept_id in(99160,99161)
and person_id=personid
and value_datetime<=reportdt
and voided=0
order by value_datetime asc
limit 1);


END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` FUNCTION `getArtStartRegTxt`(`personid` integer) RETURNS char(10) CHARSET latin1
    READS SQL DATA
BEGIN


	RETURN (select
min(if(value_coded=99015, '1a',
if(value_coded=99016, '1b',
if(value_coded=99005, '1c',
if(value_coded=99006, '1d',
if(value_coded=99039, '1e',
if(value_coded=99040, '1f',
if(value_coded=99041, '1g',
if(value_coded=99042, '1h',
if(value_coded=99007, '2a2',
if(value_coded=99008, '2a4',
if(value_coded=99044, '2b',
if(value_coded=99043, '2c',
if(value_coded=99282, '2d2',
if(value_coded=99283, '2d4',
if(value_coded=99046, '2e',
if(value_coded=99017, '5a',
if(value_coded=99018, '5b',
if(value_coded=99045,'5f',
if(value_coded=99284,'5g',
if(value_coded=99285,'5h',
if(value_coded=99286,'5j',
if(value_coded=90002,'othr',''
)))))))))))))))))))))))as freg
from obs
where concept_id in(99061, 99064) and voided=0
and personid=person_id
limit 1 );
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` FUNCTION `getArtStopDate`(`personid` integer, `obsdatetime` date) RETURNS date
    READS SQL DATA
BEGIN


RETURN
(
select value_datetime from obs where
concept_id=99084 and voided=0
and personid=person_id
and obsdatetime=value_datetime
limit 1);


END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` FUNCTION `getArtStopDate1`(`personid` integer,`encdt` char(6)) RETURNS date
    READS SQL DATA
BEGIN


RETURN (
select value_datetime from obs
where concept_id=99084
and voided=0
and personid=person_id
and
encdt=concat(year(value_datetime),month(value_datetime))
limit 1
);

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` FUNCTION `getArtStopReasonTxt`(`personid` integer, `encdt` char) RETURNS char(2) CHARSET latin1
    READS SQL DATA
BEGIN


RETURN (
select
if(a.value_coded=90040,"1",
if(a.value_coded=90041,"2",
if(a.value_coded=90046,"3",
if(a.value_coded=90049,"4",
if(a.value_coded=90050,"5",
if(a.value_coded=90045,"6",
if(a.value_coded=90051,"7",
if(a.value_coded=90052,"8",
if(a.value_coded=90066,"9",
if(a.value_coded=90002,"10",
if(a.value_coded=99289,"11",''))))))))))) stop_r


from obs  a, obs b
where b.concept_id=99084
and a.voided=0
and b.voided=0
and a.concept_id=1252
and a.obs_group_id=b.obs_group_id
and personid=b.person_id
and encdt=concat(year(b.value_datetime),month(b.value_datetime))
limit 1

);

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` FUNCTION `getBaseWeightValue`(`personid` integer,`artstartdt` date) RETURNS int(11)
    READS SQL DATA
BEGIN


RETURN (select
if(concept_id=99069,value_numeric,
if(concept_id=90236 and  obs_datetime=artstartdt ,value_numeric,null)) wt
from obs
where concept_id in(99069,90236)
and personid=person_id
and voided=0
having wt is not null
limit 1
);

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` FUNCTION `getCareEntryTxt`(`personid` INT) RETURNS char(15) CHARSET latin1
    READS SQL DATA
BEGIN


RETURN (select if(value_coded=90012,"eMTCT",
if(value_coded=90013,"Outpatient",
if(value_coded=99593,"YCC",
if(value_coded=90016,"TB",
if(value_coded=90015,"STI",
if(value_coded=90018,"Inpatient",
if(value_coded=90019,"Outreach",
if(value_coded=99087,"Exposed Infant",
if(value_coded=99002,"Other",if(value_coded=99610,"SMC",'')))))))))) as care_entry from obs
where concept_id =90200
and voided=0
and personid=person_id
limit 1
);

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` FUNCTION `getCd4BaseValue`(`personid` integer, `artstartdt` date) RETURNS int(11)
    READS SQL DATA
BEGIN


RETURN (select
if(concept_id=99071,value_numeric,
if(concept_id=5497 and datediff(artstartdt,obs_datetime) between 0 and 31, value_numeric, null )) as bcd4
from obs
where concept_id in(99071,5497)
and voided=0
and personid=person_id
and artstartdt=artstartdt
having bcd4 is not null
limit 1
);
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` FUNCTION `get_CD4_count`(StartDate varchar(12), EndDate varchar(12), Patient_ID int) RETURNS varchar(10) CHARSET latin1
    DETERMINISTIC
RETURN
(
	SELECT IFNULL(CD4Count, CD4Percentage) AS CD4_Count
	FROM(
		SELECT
			(SELECT value_numeric FROM obs  WHERE concept_id = 5497 AND person_id = LatestEncounter.patient_id	AND encounter_id = LatestEncounter.encounter_id) AS CD4Count
			,(SELECT value_numeric FROM obs  WHERE concept_id = 730 AND person_id = LatestEncounter.patient_id	AND encounter_id = LatestEncounter.encounter_id) AS CD4Percentage
		FROM(
			SELECT patient_id, max(encounter_datetime), encounter_id
			FROM encounter
			WHERE encounter_datetime BETWEEN str_to_date(StartDate,"%d/%m/%Y")  AND str_to_date(EndDate,"%d/%m/%Y")
			AND patient_id = Patient_ID AND form_id = 31
			GROUP BY patient_id
		)LatestEncounter
	)CD4
)$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` FUNCTION `getCd4SevereBaseValue`(`personid` integer, `artstartdt` date) RETURNS int(11)
    READS SQL DATA
BEGIN


RETURN (select
if(value_coded=99150 and datediff(artstartdt,obs_datetime) between 0 and 31, 0, null ) as bsevere
from obs
where concept_id =99151
and voided=0
and personid=person_id
and artstartdt=artstartdt
limit 1
);
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` FUNCTION `getCD4Value`(`personid` integer, `obsdatetime` date) RETURNS int(11)
    READS SQL DATA
BEGIN


RETURN (select value_numeric from obs
where concept_id in
(99071, 5497)
and voided=0
and obsdatetime=obs_datetime
and personid=person_id
limit 1
);
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` FUNCTION `getCodedDeathDate`(`personid` integer) RETURNS date
    READS SQL DATA
BEGIN


RETURN (select value_datetime
from obs
where concept_id=90272  and voided=0
and personid=person_id
limit 1
);

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` FUNCTION `getCohortAllBefore10`(start_year int, start_quarter int, months_before int,only_preg TEXT) RETURNS int(11)
BEGIN
DECLARE number_on_cohort int;

IF NULLIF(only_preg, '') IS NULL THEN
	SELECT
            COUNT(*)
            INTO number_on_cohort
        FROM
            encounter e
                INNER JOIN
            obs o ON (e.encounter_id = o.encounter_id
                AND o.voided = 0
                AND o.concept_id = 99112
                AND o.value_coded = 90003
                AND e.patient_id IN (SELECT
                    patient_id
                FROM
                    encounter ei
                        INNER JOIN
                    obs oi ON (ei.encounter_id = oi.encounter_id
                        AND oi.voided = 0
                        AND oi.concept_id = 99161))
                AND e.encounter_datetime BETWEEN MAKEDATE(start_year, 1) + INTERVAL start_quarter - 1 QUARTER - INTERVAL months_before MONTH AND MAKEDATE(start_year, 1) + INTERVAL start_quarter QUARTER - INTERVAL 1 DAY);
ELSE
SELECT
            COUNT(*)
            INTO number_on_cohort
        FROM
            encounter e
                INNER JOIN
            obs o ON (e.encounter_id = o.encounter_id
                AND o.voided = 0
                AND o.concept_id = 99112
                AND o.value_coded = 90003
                AND FIND_IN_SET (e.patient_id, only_preg)
                AND e.patient_id IN (SELECT
                    patient_id
                FROM
                    encounter ei
                        INNER JOIN
                    obs oi ON (ei.encounter_id = oi.encounter_id
                        AND oi.voided = 0
                        AND oi.concept_id = 99161))
                AND e.encounter_datetime BETWEEN MAKEDATE(start_year, 1) + INTERVAL start_quarter - 1 QUARTER - INTERVAL months_before MONTH AND MAKEDATE(start_year, 1) + INTERVAL start_quarter QUARTER - INTERVAL 1 DAY);
END IF;
RETURN number_on_cohort;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` FUNCTION `getCohortAllBefore11`(start_year int, start_quarter int, months_before int,only_preg TEXT) RETURNS int(11)
BEGIN
DECLARE number_on_cohort int;


IF NULLIF(only_preg, '') IS NULL THEN
	SELECT
            COUNT(*)
            INTO number_on_cohort
        FROM
            (SELECT
                patient_id, MAX(value_datetime) value_datetime
            FROM
                encounter
            JOIN obs USING (encounter_id)
            WHERE
                encounter.voided = 0 AND form_id = 27
                    AND encounter.voided = 0
                    AND obs.concept_id = 5096
                    AND obs.voided = 0
                    AND encounter.patient_id IN (SELECT
                        patient_id
                    FROM
                        encounter ei
                    INNER JOIN obs oi ON (ei.encounter_id = oi.encounter_id
                        AND oi.voided = 0
                        AND oi.concept_id = 99161))
                    AND encounter_datetime BETWEEN MAKEDATE(start_year - 1, 1) + INTERVAL start_quarter - 1 QUARTER - INTERVAL months_before MONTH AND MAKEDATE(start_year, 1) + INTERVAL start_quarter QUARTER - INTERVAL 1 DAY
            GROUP BY patient_id) MaxReturnDate
        WHERE
            value_datetime <= MAKEDATE(start_year, 1) + INTERVAL 2 - 3 QUARTER - INTERVAL 1 DAY
                AND patient_id NOT IN (SELECT
                    patient_id
                FROM
                    encounter
                        JOIN
                    obs USING (encounter_id)
                WHERE
                    obs.concept_id = 90306
                        AND obs.value_coded = 90003
                        AND obs.voided = 0)
                AND patient_id NOT IN (SELECT
                    patient_id
                FROM
                    encounter
                        JOIN
                    obs USING (encounter_id)
                WHERE
                    obs.concept_id = 99112
                        AND obs.value_coded = 90003
                        AND obs.voided = 0)
                AND patient_id IN (SELECT
                    patient_id
                FROM
                    encounter
                        JOIN
                    obs USING (encounter_id)
                WHERE
                    form_id = 28 AND obs.concept_id = 99161
                        AND obs.voided = 0);
ELSE
	SELECT
            COUNT(*)
            INTO number_on_cohort
        FROM
            (SELECT
                patient_id, MAX(value_datetime) value_datetime
            FROM
                encounter
            JOIN obs USING (encounter_id)
            WHERE
                encounter.voided = 0 AND form_id = 27
                    AND encounter.voided = 0
                    AND obs.concept_id = 5096
                    AND obs.voided = 0
                    AND FIND_IN_SET (encounter.patient_id, only_preg)
                    AND encounter.patient_id IN (SELECT
                        patient_id
                    FROM
                        encounter ei
                    INNER JOIN obs oi ON (ei.encounter_id = oi.encounter_id
                        AND oi.voided = 0
                        AND oi.concept_id = 99161))
                    AND encounter_datetime BETWEEN MAKEDATE(start_year - 1, 1) + INTERVAL start_quarter - 1 QUARTER - INTERVAL months_before MONTH AND MAKEDATE(start_year, 1) + INTERVAL start_quarter QUARTER - INTERVAL 1 DAY
            GROUP BY patient_id) MaxReturnDate
        WHERE
            value_datetime <= MAKEDATE(start_year, 1) + INTERVAL 2 - 3 QUARTER - INTERVAL 1 DAY
                AND patient_id NOT IN (SELECT
                    patient_id
                FROM
                    encounter
                        JOIN
                    obs USING (encounter_id)
                WHERE
                    obs.concept_id = 90306
                        AND obs.value_coded = 90003
                        AND obs.voided = 0)
                AND patient_id NOT IN (SELECT
                    patient_id
                FROM
                    encounter
                        JOIN
                    obs USING (encounter_id)
                WHERE
                    obs.concept_id = 99112
                        AND obs.value_coded = 90003
                        AND obs.voided = 0)
                AND patient_id IN (SELECT
                    patient_id
                FROM
                    encounter
                        JOIN
                    obs USING (encounter_id)
                WHERE
                    form_id = 28 AND obs.concept_id = 99161
                        AND obs.voided = 0);
END IF;

RETURN number_on_cohort;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` FUNCTION `getCohortAllBefore12`(start_year int, start_quarter int, months_before int,only_preg TEXT) RETURNS int(11)
BEGIN
DECLARE number_on_cohort int;


IF NULLIF(only_preg, '') IS NULL THEN
	SELECT
            COUNT(*)
            INTO number_on_cohort
        FROM
            encounter e
                INNER JOIN
            obs o ON (e.encounter_id = o.encounter_id
                AND o.voided = 0
                AND o.concept_id = 99132
                AND o.value_coded = 99133
                AND e.patient_id IN (SELECT
                    patient_id
                FROM
                    encounter ei
                        INNER JOIN
                    obs oi ON (ei.encounter_id = oi.encounter_id
                        AND oi.voided = 0
                        AND oi.concept_id = 99161))
                AND e.encounter_datetime BETWEEN MAKEDATE(start_year, 1) + INTERVAL start_quarter - 1 QUARTER - INTERVAL months_before MONTH AND MAKEDATE(start_year, 1) + INTERVAL start_quarter QUARTER - INTERVAL 1 DAY);

ELSE
	SELECT
            COUNT(*)
            INTO number_on_cohort
        FROM
            encounter e
                INNER JOIN
            obs o ON (e.encounter_id = o.encounter_id
                AND o.voided = 0
                AND o.concept_id = 99132
                AND o.value_coded = 99133
                AND FIND_IN_SET (e.patient_id, only_preg)
                AND e.patient_id IN (SELECT
                    patient_id
                FROM
                    encounter ei
                        INNER JOIN
                    obs oi ON (ei.encounter_id = oi.encounter_id
                        AND oi.voided = 0
                        AND oi.concept_id = 99161))
                AND e.encounter_datetime BETWEEN MAKEDATE(start_year, 1) + INTERVAL start_quarter - 1 QUARTER - INTERVAL months_before MONTH AND MAKEDATE(start_year, 1) + INTERVAL start_quarter QUARTER - INTERVAL 1 DAY);


END IF;


RETURN number_on_cohort;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` FUNCTION `getCohortAllBefore15a`(start_year int, start_quarter int, months_before int,only_preg TEXT) RETURNS int(11)
BEGIN
DECLARE number_on_cohort int;



IF NULLIF(only_preg, '') IS NULL THEN
	SELECT
            COUNT(*)
            INTO number_on_cohort
        FROM
            person pp
                INNER JOIN
            patient p ON (pp.person_id = p.patient_id
                AND p.voided = 0
                AND TIMESTAMPDIFF(YEAR,
                pp.birthdate,
                CURDATE()) >= 5)
                INNER JOIN
            encounter e ON (e.patient_id = p.patient_id
                AND e.voided = 0)
                INNER JOIN
            obs o ON (e.encounter_id = o.encounter_id
                AND o.voided = 0
                AND o.concept_id = 5497
                AND o.value_numeric < 500
                AND e.patient_id IN (SELECT
                    patient_id
                FROM
                    encounter ei
                        INNER JOIN
                    obs oi ON (ei.encounter_id = oi.encounter_id
                        AND oi.voided = 0
                        AND oi.concept_id = 99161))
                AND e.encounter_datetime BETWEEN MAKEDATE(start_year, 1) + INTERVAL start_quarter - 1 QUARTER - INTERVAL months_before MONTH AND MAKEDATE(start_year, 1) + INTERVAL start_quarter QUARTER - INTERVAL 1 DAY);

ELSE
	SELECT
            COUNT(*)
            INTO number_on_cohort
        FROM
            person pp
                INNER JOIN
            patient p ON (pp.person_id = p.patient_id
                AND p.voided = 0
                AND TIMESTAMPDIFF(YEAR,
                pp.birthdate,
                CURDATE()) >= 5)
                INNER JOIN
            encounter e ON (e.patient_id = p.patient_id
                AND e.voided = 0
                AND FIND_IN_SET (e.patient_id, only_preg))
                INNER JOIN
            obs o ON (e.encounter_id = o.encounter_id
                AND o.voided = 0
                AND o.concept_id = 5497
                AND o.value_numeric < 500
                AND e.patient_id IN (SELECT
                    patient_id
                FROM
                    encounter ei
                        INNER JOIN
                    obs oi ON (ei.encounter_id = oi.encounter_id
                        AND oi.voided = 0
                        AND oi.concept_id = 99161))
                AND e.encounter_datetime BETWEEN MAKEDATE(start_year, 1) + INTERVAL start_quarter - 1 QUARTER - INTERVAL months_before MONTH AND MAKEDATE(start_year, 1) + INTERVAL start_quarter QUARTER - INTERVAL 1 DAY);


END IF;

RETURN number_on_cohort;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` FUNCTION `getCohortAllBefore15b`(start_year int, start_quarter int, months_before int,only_preg TEXT) RETURNS int(11)
BEGIN
DECLARE number_on_cohort int;



IF NULLIF(only_preg, '') IS NULL THEN
	SELECT
            COUNT(*)
            INTO number_on_cohort
        FROM
            person pp
                INNER JOIN
            patient p ON (pp.person_id = p.patient_id
                AND p.voided = 0
                AND TIMESTAMPDIFF(YEAR,
                pp.birthdate,
                CURDATE()) >= 5)
                INNER JOIN
            encounter e ON (e.patient_id = p.patient_id
                AND e.voided = 0)
                INNER JOIN
            obs o ON (e.encounter_id = o.encounter_id
                AND o.voided = 0
                AND o.concept_id = 5497
                AND e.patient_id IN (SELECT
                    patient_id
                FROM
                    encounter ei
                        INNER JOIN
                    obs oi ON (ei.encounter_id = oi.encounter_id
                        AND oi.voided = 0
                        AND oi.concept_id = 99161))
                AND e.encounter_datetime BETWEEN MAKEDATE(start_year, 1) + INTERVAL start_quarter - 1 QUARTER - INTERVAL months_before MONTH AND MAKEDATE(start_year, 1) + INTERVAL start_quarter QUARTER - INTERVAL 1 DAY);

ELSE
	SELECT
            COUNT(*)
            INTO number_on_cohort
        FROM
            person pp
                INNER JOIN
            patient p ON (pp.person_id = p.patient_id
                AND p.voided = 0
                AND TIMESTAMPDIFF(YEAR,
                pp.birthdate,
                CURDATE()) >= 5)
                INNER JOIN
            encounter e ON (e.patient_id = p.patient_id
                AND e.voided = 0
                AND FIND_IN_SET (e.patient_id, only_preg))
                INNER JOIN
            obs o ON (e.encounter_id = o.encounter_id
                AND o.voided = 0
                AND o.concept_id = 5497
                AND e.patient_id IN (SELECT
                    patient_id
                FROM
                    encounter ei
                        INNER JOIN
                    obs oi ON (ei.encounter_id = oi.encounter_id
                        AND oi.voided = 0
                        AND oi.concept_id = 99161))
                AND e.encounter_datetime BETWEEN MAKEDATE(start_year, 1) + INTERVAL start_quarter - 1 QUARTER - INTERVAL months_before MONTH AND MAKEDATE(start_year, 1) + INTERVAL start_quarter QUARTER - INTERVAL 1 DAY);


END IF;

RETURN number_on_cohort;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` FUNCTION `getCohortAllBefore16`(start_year int, start_quarter int, months_before int,only_preg TEXT) RETURNS int(11)
BEGIN
DECLARE number_on_cohort int;



IF NULLIF(only_preg, '') IS NULL THEN
	SELECT
            AVG(t1.value_numeric) AS median_val
            INTO number_on_cohort
        FROM
            (SELECT
                @rownum:=@rownum + 1 AS `row_number`, d.value_numeric
            FROM
                obs d
            INNER JOIN encounter e ON (e.encounter_id = d.encounter_id), (SELECT @rownum:=0) r
            WHERE
                d.value_numeric > 0
                    AND d.concept_id = 5497
                    AND e.patient_id IN (SELECT
                        patient_id
                    FROM
                        encounter ei
                    INNER JOIN obs oi ON (ei.encounter_id = oi.encounter_id
                        AND oi.voided = 0
                        AND oi.concept_id = 99161))
                    AND e.encounter_datetime BETWEEN MAKEDATE(start_year, 1) + INTERVAL start_quarter - 1 QUARTER - INTERVAL months_before MONTH AND MAKEDATE(start_year, 1) + INTERVAL start_quarter QUARTER - INTERVAL 1 DAY
            ORDER BY d.value_numeric) AS t1,
            (SELECT
                COUNT(*) AS total_rows
            FROM
                obs d
            INNER JOIN encounter e ON (e.encounter_id = d.encounter_id)
            WHERE
                d.value_numeric > 0
                    AND d.concept_id = 5497
                    AND e.patient_id IN (SELECT
                        patient_id
                    FROM
                        encounter ei
                    INNER JOIN obs oi ON (ei.encounter_id = oi.encounter_id
                        AND oi.voided = 0
                        AND oi.concept_id = 99161))
                    AND e.encounter_datetime BETWEEN MAKEDATE(start_year, 1) + INTERVAL start_quarter - 1 QUARTER - INTERVAL months_before MONTH AND MAKEDATE(start_year, 1) + INTERVAL start_quarter QUARTER - INTERVAL 1 DAY) AS t2
        WHERE
            t1.row_number IN (FLOOR((total_rows + 1) / 2) , FLOOR((total_rows + 2) / 2));
ELSE
	SELECT
            AVG(t1.value_numeric) AS median_val
            INTO number_on_cohort
        FROM
            (SELECT
                @rownum:=@rownum + 1 AS `row_number`, d.value_numeric
            FROM
                obs d
            INNER JOIN encounter e ON (e.encounter_id = d.encounter_id), (SELECT @rownum:=0) r
            WHERE
                d.value_numeric > 0
                    AND d.concept_id = 5497
                    AND e.patient_id IN (SELECT
                        patient_id
                    FROM
                        encounter ei
                    INNER JOIN obs oi ON (ei.encounter_id = oi.encounter_id
                        AND oi.voided = 0
                        AND oi.concept_id = 99161))
					AND FIND_IN_SET (e.patient_id, only_preg)
                    AND e.encounter_datetime BETWEEN MAKEDATE(start_year, 1) + INTERVAL start_quarter - 1 QUARTER - INTERVAL months_before MONTH AND MAKEDATE(start_year, 1) + INTERVAL start_quarter QUARTER - INTERVAL 1 DAY
            ORDER BY d.value_numeric) AS t1,
            (SELECT
                COUNT(*) AS total_rows
            FROM
                obs d
            INNER JOIN encounter e ON (e.encounter_id = d.encounter_id)
            WHERE
                d.value_numeric > 0
                    AND d.concept_id = 5497
                    AND e.patient_id IN (SELECT
                        patient_id
                    FROM
                        encounter ei
                    INNER JOIN obs oi ON (ei.encounter_id = oi.encounter_id
                        AND oi.voided = 0
                        AND oi.concept_id = 99161)
                        AND FIND_IN_SET (ei.patient_id, only_preg))
                    AND e.encounter_datetime BETWEEN MAKEDATE(start_year, 1) + INTERVAL start_quarter - 1 QUARTER - INTERVAL months_before MONTH AND MAKEDATE(start_year, 1) + INTERVAL start_quarter QUARTER - INTERVAL 1 DAY) AS t2
        WHERE
            t1.row_number IN (FLOOR((total_rows + 1) / 2) , FLOOR((total_rows + 2) / 2));
END IF;


RETURN number_on_cohort;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` FUNCTION `getCohortAllBefore3`(start_year int, start_quarter int, month_before int,only_preg TEXT) RETURNS int(11)
BEGIN

 DECLARE income_level int;
	IF NULLIF(only_preg, '') IS NULL THEN

     SELECT
			COUNT(o.concept_id)
            INTO income_level
			FROM
			encounter e INNER JOIN obs o ON(
            e.encounter_id = o.encounter_id AND
			concept_id = 99161
				AND o.value_datetime BETWEEN MAKEDATE(start_year, 1) + INTERVAL start_quarter - 1 QUARTER - INTERVAL month_before MONTH AND MAKEDATE(start_year, 1) + INTERVAL start_quarter QUARTER - INTERVAL month_before MONTH - INTERVAL 1 DAY
				AND o.voided = 0);
   ELSE

SELECT
			COUNT(o.concept_id)
            INTO income_level
			FROM
			encounter e INNER JOIN obs o ON(
			e.encounter_id = o.encounter_id
            AND o.concept_id = 99161
            AND FIND_IN_SET (e.patient_id, only_preg)
				AND o.value_datetime BETWEEN MAKEDATE(start_year, 1) + INTERVAL start_quarter - 1 QUARTER - INTERVAL month_before MONTH AND MAKEDATE(start_year, 1) + INTERVAL start_quarter QUARTER - INTERVAL month_before MONTH - INTERVAL 1 DAY
				AND o.voided = 0);
   END IF;

   RETURN income_level;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` FUNCTION `getCohortAllBefore4a`(start_year int, start_quarter int, months_before int,only_preg TEXT) RETURNS int(11)
BEGIN
DECLARE number_on_cohort int;

IF NULLIF(only_preg, '') IS NULL THEN
	SELECT
            COUNT(*)
            INTO number_on_cohort
        FROM
            person pp
                INNER JOIN
            patient p ON (pp.person_id = p.patient_id
                AND p.voided = 0
                AND TIMESTAMPDIFF(YEAR,
                pp.birthdate,
                CURDATE()) >= 5)
                INNER JOIN
            encounter e ON (e.patient_id = p.patient_id AND e.voided = 0)
                INNER JOIN
            obs o ON (e.encounter_id = o.encounter_id
                AND o.voided = 0
                AND o.concept_id = 99071
                AND o.value_numeric < 500
                AND e.encounter_datetime BETWEEN MAKEDATE(start_year, 1) + INTERVAL start_quarter - 1 QUARTER - INTERVAL months_before MONTH AND MAKEDATE(start_year, 1) + INTERVAL start_quarter QUARTER - INTERVAL months_before MONTH - INTERVAL 1 DAY);

ELSE
	SELECT
            COUNT(*)
            INTO number_on_cohort
        FROM
            person pp
                INNER JOIN
            patient p ON (pp.person_id = p.patient_id
                AND p.voided = 0
                AND TIMESTAMPDIFF(YEAR,
                pp.birthdate,
                CURDATE()) >= 5)
                INNER JOIN
            encounter e ON (e.patient_id = p.patient_id AND e.voided = 0)
                INNER JOIN
            obs o ON (e.encounter_id = o.encounter_id
                AND o.voided = 0
                AND o.concept_id = 99071
                AND o.value_numeric < 500
                AND FIND_IN_SET (e.patient_id, only_preg)
                AND e.encounter_datetime BETWEEN MAKEDATE(start_year, 1) + INTERVAL start_quarter - 1 QUARTER - INTERVAL months_before MONTH AND MAKEDATE(start_year, 1) + INTERVAL start_quarter QUARTER - INTERVAL months_before MONTH - INTERVAL 1 DAY);


END IF;


RETURN number_on_cohort;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` FUNCTION `getCohortAllBefore4b`(start_year int, start_quarter int, months_before int,only_preg TEXT) RETURNS int(11)
BEGIN
DECLARE number_on_cohort int;

IF NULLIF(only_preg, '') IS NULL THEN
	SELECT
            COUNT(*)
            INTO number_on_cohort
        FROM
            person pp
                INNER JOIN
            patient p ON (pp.person_id = p.patient_id
                AND p.voided = 0
                AND TIMESTAMPDIFF(YEAR,
                pp.birthdate,
                CURDATE()) >= 5)
                INNER JOIN
            encounter e ON (e.patient_id = p.patient_id AND e.voided = 0)
                INNER JOIN
            obs o ON (e.encounter_id = o.encounter_id
                AND o.voided = 0
                AND o.concept_id = 99071
                AND e.encounter_datetime BETWEEN MAKEDATE(start_year, 1) + INTERVAL start_quarter - 1 QUARTER - INTERVAL months_before MONTH AND MAKEDATE(start_year, 1) + INTERVAL start_quarter QUARTER - INTERVAL months_before MONTH - INTERVAL 1 DAY);

ELSE
	SELECT
            COUNT(*)
            INTO number_on_cohort
        FROM
            person pp
                INNER JOIN
            patient p ON (pp.person_id = p.patient_id
                AND p.voided = 0
                AND TIMESTAMPDIFF(YEAR,
                pp.birthdate,
                CURDATE()) >= 5)
                INNER JOIN
            encounter e ON (e.patient_id = p.patient_id AND e.voided = 0)
                INNER JOIN
            obs o ON (e.encounter_id = o.encounter_id
                AND o.voided = 0
                AND o.concept_id = 99071
                AND FIND_IN_SET (e.patient_id, only_preg)
                AND e.encounter_datetime BETWEEN MAKEDATE(start_year, 1) + INTERVAL start_quarter - 1 QUARTER - INTERVAL months_before MONTH AND MAKEDATE(start_year, 1) + INTERVAL start_quarter QUARTER - INTERVAL months_before MONTH - INTERVAL 1 DAY);


END IF;


RETURN number_on_cohort;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` FUNCTION `getCohortAllBefore5`(start_year int, start_quarter int, months_before int,only_preg TEXT) RETURNS int(11)
BEGIN
DECLARE number_on_cohort int;


IF NULLIF(only_preg, '') IS NULL THEN
	SELECT
            AVG(t1.value_numeric) AS median_val
            INTO number_on_cohort
        FROM
            (SELECT
                @rownum:=@rownum + 1 AS `row_number`, d.value_numeric
            FROM
                obs d
            INNER JOIN encounter e ON (e.encounter_id = d.encounter_id), (SELECT @rownum:=0) r
            WHERE
                d.value_numeric > 0
                    AND d.concept_id = 99071
                    AND e.encounter_datetime BETWEEN MAKEDATE(start_year, 1) + INTERVAL start_quarter - 1 QUARTER - INTERVAL months_before MONTH AND MAKEDATE(start_year, 1) + INTERVAL start_quarter QUARTER - INTERVAL months_before MONTH - INTERVAL 1 DAY
            ORDER BY d.value_numeric) AS t1,
            (SELECT
                COUNT(*) AS total_rows
            FROM
                obs d
            INNER JOIN encounter e ON (e.encounter_id = d.encounter_id)
            WHERE
                d.value_numeric > 0
                    AND d.concept_id = 99071
                    AND e.encounter_datetime BETWEEN MAKEDATE(start_year, 1) + INTERVAL start_quarter - 1 QUARTER - INTERVAL months_before MONTH AND MAKEDATE(start_year, 1) + INTERVAL start_quarter QUARTER - INTERVAL months_before MONTH - INTERVAL 1 DAY) AS t2
        WHERE
            t1.row_number IN (FLOOR((total_rows + 1) / 2) , FLOOR((total_rows + 2) / 2));
ELSE
	SELECT
            AVG(t1.value_numeric) AS median_val
            INTO number_on_cohort
        FROM
            (SELECT
                @rownum:=@rownum + 1 AS `row_number`, d.value_numeric
            FROM
                obs d
            INNER JOIN encounter e ON (e.encounter_id = d.encounter_id), (SELECT @rownum:=0) r
            WHERE
                d.value_numeric > 0
                    AND d.concept_id = 99071
                    AND FIND_IN_SET (e.patient_id, only_preg)
                    AND e.encounter_datetime BETWEEN MAKEDATE(start_year, 1) + INTERVAL start_quarter - 1 QUARTER - INTERVAL months_before MONTH AND MAKEDATE(start_year, 1) + INTERVAL start_quarter QUARTER - INTERVAL months_before MONTH - INTERVAL 1 DAY
            ORDER BY d.value_numeric) AS t1,
            (SELECT
                COUNT(*) AS total_rows
            FROM
                obs d
            INNER JOIN encounter e ON (e.encounter_id = d.encounter_id)
            WHERE
                d.value_numeric > 0
                    AND d.concept_id = 99071
                    AND FIND_IN_SET (e.patient_id, only_preg)
                    AND e.encounter_datetime BETWEEN MAKEDATE(start_year, 1) + INTERVAL start_quarter - 1 QUARTER - INTERVAL months_before MONTH AND MAKEDATE(start_year, 1) + INTERVAL start_quarter QUARTER - INTERVAL months_before MONTH - INTERVAL 1 DAY) AS t2
        WHERE
            t1.row_number IN (FLOOR((total_rows + 1) / 2) , FLOOR((total_rows + 2) / 2));

END IF;


RETURN number_on_cohort;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` FUNCTION `getCohortAllBefore6`(start_year int, start_quarter int, months_before int,only_preg TEXT) RETURNS int(11)
BEGIN
DECLARE number_on_cohort int;

IF NULLIF(only_preg, '') IS NULL THEN
	SELECT
            COUNT(*)
            INTO number_on_cohort
        FROM
            encounter e
                INNER JOIN
            obs o ON (e.encounter_id = o.encounter_id
                AND o.voided = 0
                AND o.concept_id = 99110
                AND o.value_coded = 90003
                AND e.encounter_datetime BETWEEN MAKEDATE(start_year, 1) + INTERVAL start_quarter - 1 QUARTER - INTERVAL months_before MONTH AND MAKEDATE(start_year, 1) + INTERVAL start_quarter QUARTER - INTERVAL 1 DAY);

ELSE
	SELECT
            COUNT(*)
            INTO number_on_cohort
        FROM
            encounter e
                INNER JOIN
            obs o ON (e.encounter_id = o.encounter_id
                AND o.voided = 0
                AND o.concept_id = 99110
                AND o.value_coded = 90003
                AND FIND_IN_SET (e.patient_id, only_preg)
                AND e.encounter_datetime BETWEEN MAKEDATE(start_year, 1) + INTERVAL start_quarter - 1 QUARTER - INTERVAL months_before MONTH AND MAKEDATE(start_year, 1) + INTERVAL start_quarter QUARTER - INTERVAL 1 DAY);


END IF;


RETURN number_on_cohort;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` FUNCTION `getCohortAllBefore7`(start_year int, start_quarter int, months_before int,only_preg TEXT) RETURNS int(11)
BEGIN
DECLARE number_on_cohort int;


IF NULLIF(only_preg, '') IS NULL THEN

	SELECT
            COUNT(*)
            INTO number_on_cohort
        FROM
            encounter e
                INNER JOIN
            obs o ON (e.encounter_id = o.encounter_id
                AND o.voided = 0
                AND o.concept_id = 99165
                AND e.patient_id IN (SELECT
                    patient_id
                FROM
                    encounter ei
                        INNER JOIN
                    obs oi ON (ei.encounter_id = oi.encounter_id
                        AND oi.voided = 0
                        AND oi.concept_id = 99161))
                AND e.encounter_datetime BETWEEN MAKEDATE(start_year, 1) + INTERVAL start_quarter - 1 QUARTER - INTERVAL months_before MONTH AND MAKEDATE(start_year, 1) + INTERVAL start_quarter QUARTER - INTERVAL 1 DAY);


ELSE
	SELECT
            COUNT(*)
            INTO number_on_cohort
        FROM
            encounter e
                INNER JOIN
            obs o ON (e.encounter_id = o.encounter_id
                AND o.voided = 0
                AND o.concept_id = 99165
                AND e.patient_id IN (SELECT
                    patient_id
                FROM
                    encounter ei
                        INNER JOIN
                    obs oi ON (ei.encounter_id = oi.encounter_id
                        AND oi.voided = 0
                        AND oi.concept_id = 99161))
				AND FIND_IN_SET (e.patient_id, only_preg)
                AND e.encounter_datetime BETWEEN MAKEDATE(start_year, 1) + INTERVAL start_quarter - 1 QUARTER - INTERVAL months_before MONTH AND MAKEDATE(start_year, 1) + INTERVAL start_quarter QUARTER - INTERVAL 1 DAY);


END IF;


RETURN number_on_cohort;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` FUNCTION `getCohortAllBefore9`(start_year int, start_quarter int, months_before int,only_preg TEXT) RETURNS int(11)
BEGIN
DECLARE number_on_cohort int;

IF NULLIF(only_preg, '') IS NULL THEN
	SELECT
            COUNT(*)
            INTO number_on_cohort
        FROM
            encounter e
                INNER JOIN
            obs o ON (e.encounter_id = o.encounter_id
                AND o.voided = 0
                AND o.concept_id = 99132
                AND o.value_coded = 1363
                AND e.patient_id IN (SELECT
                    patient_id
                FROM
                    encounter ei
                        INNER JOIN
                    obs oi ON (ei.encounter_id = oi.encounter_id
                        AND oi.voided = 0
                        AND oi.concept_id = 99161))
                AND e.encounter_datetime BETWEEN MAKEDATE(start_year, 1) + INTERVAL start_quarter - 1 QUARTER - INTERVAL months_before MONTH AND MAKEDATE(start_year, 1) + INTERVAL start_quarter QUARTER - INTERVAL 1 DAY);

ELSE
	SELECT
            COUNT(*)
            INTO number_on_cohort
        FROM
            encounter e
                INNER JOIN
            obs o ON (e.encounter_id = o.encounter_id
                AND o.voided = 0
                AND o.concept_id = 99132
                AND o.value_coded = 1363
                AND e.patient_id IN (SELECT
                    patient_id
                FROM
                    encounter ei
                        INNER JOIN
                    obs oi ON (ei.encounter_id = oi.encounter_id
                        AND oi.voided = 0
                        AND oi.concept_id = 99161))
				AND FIND_IN_SET (e.patient_id, only_preg)
                AND e.encounter_datetime BETWEEN MAKEDATE(start_year, 1) + INTERVAL start_quarter - 1 QUARTER - INTERVAL months_before MONTH AND MAKEDATE(start_year, 1) + INTERVAL start_quarter QUARTER - INTERVAL 1 DAY);

END IF;


RETURN number_on_cohort;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`openmrs`@`localhost` FUNCTION `getCohortMonth`(start_year INT,start_quarter INT,months_before INT) RETURNS char(30) CHARSET latin1
BEGIN
	DECLARE end_date DATE DEFAULT MAKEDATE(start_year,1) + INTERVAL start_quarter QUARTER - INTERVAL months_before MONTH - INTERVAL 1 DAY;
	DECLARE start_date DATE DEFAULT MAKEDATE(start_year,1) + INTERVAL start_quarter - 1 QUARTER - INTERVAL months_before MONTH;


RETURN CONCAT(MONTHNAME(start_date),'-',MONTHNAME(end_date),' ',YEAR(end_date));
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` FUNCTION `get_cpt_receipt_status`(StartDate varchar(12), EndDate varchar(12), Patient_ID int) RETURNS char(50) CHARSET latin1
    DETERMINISTIC
RETURN
 	(
		SELECT IF (NumberOfCPTDrugsRcpt < 1, 'N', 'Y') AS CPTReceiptStatus
			FROM (
			SELECT person_id, count(obs_id) NumberOfCPTDrugsRcpt
			FROM obs
			WHERE concept_id IN (99037, 99033 ) and voided = 0
			AND person_id = Patient_ID AND obs_datetime BETWEEN str_to_date(StartDate,"%d/%m/%Y")  AND str_to_date(EndDate,"%d/%m/%Y")
			GROUP BY person_id
			)CPTDrugsRcptFrequency
	)$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` FUNCTION `getCptStartDate`(`personid` integer) RETURNS date
    READS SQL DATA
BEGIN


	RETURN (select min(obs_datetime) cpt_start from obs where concept_id in(99033,99037) and personid=person_id and voided=0 group by person_id );
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` FUNCTION `getCptStatusTxt`(`encounterid` integer) RETURNS char(3) CHARSET latin1
    READS SQL DATA
BEGIN


RETURN (select if(value_coded is not null, "N", if(value_numeric=0, "N",if(value_numeric >0, "Y",""))) as cpt
from obs
where concept_id in(90220,99037,99033) and voided=0
and encounterid=encounter_id
having cpt!=""
limit 1
);

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` FUNCTION `getDeathDate`(`personid` integer) RETURNS date
    READS SQL DATA
BEGIN


RETURN (select if( a.death_date is null, b.value_datetime, a.death_date) as deathDate from person a
left join

(select person_id,value_datetime
from obs
where concept_id=90272  and voided=0)b

on a.person_id=b.person_id
where a.voided=0
and a.person_id=personid
having deathDate is not null
limit 1
);

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` FUNCTION `get_death_status`(StartDate varchar(12), EndDate varchar(12), Patient_ID int) RETURNS char(50) CHARSET latin1
    DETERMINISTIC
RETURN ( SELECT CONCAT('DEAD: ', CAST(date_format(DeathDate, '%d/%m/%Y') AS CHAR(10))) As DeathStatus
			FROM(
				SELECT person_Id, max(obs_datetime) DeathDate
				FROM obs
				WHERE
	 			obs_datetime BETWEEN str_to_date(StartDate,"%d/%m/%Y")  AND str_to_date(EndDate,"%d/%m/%Y")
				AND concept_id =99112 AND value_numeric = 1  AND person_Id = Patient_ID AND voided = 0
				GROUP BY person_Id
			)  RecentDeath
		)$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` FUNCTION `getEddDate`(`encounterid` integer) RETURNS date
    READS SQL DATA
BEGIN


	RETURN (select value_datetime from obs where concept_id=5596
and encounterid=encounter_id
and voided=0
limit 1

 );
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` FUNCTION `getEddEncounterId`(`personid` integer) RETURNS int(11)
    READS SQL DATA
BEGIN


	RETURN (
select encounter_id from obs  a
where concept_id =5596
and personid=person_id
and voided=0
group by person_id, concat(year(value_datetime), month(value_datetime))
limit 1

 );
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` FUNCTION `getEddEncounterId2`(`personid` integer) RETURNS int(11)
    READS SQL DATA
BEGIN


	RETURN (
select encounter_id from obs  a
where concept_id =5596
and personid=person_id
and voided=0
group by person_id, concat(year(value_datetime), month(value_datetime))
limit 1,1

 );
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` FUNCTION `getEddEncounterId3`(`personid` integer) RETURNS int(11)
    READS SQL DATA
BEGIN


	RETURN (
select encounter_id from obs  a
where concept_id =5596
and personid=person_id
and voided=0
group by person_id, concat(year(value_datetime), month(value_datetime))
limit 2,1

 );
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` FUNCTION `getEddEncounterId4`(`personid` integer) RETURNS int(11)
    READS SQL DATA
BEGIN


	RETURN (
select encounter_id from obs  a
where concept_id =5596
and personid=person_id
and voided=0
group by person_id, concat(year(value_datetime))
limit 3,1

 );
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` FUNCTION `getEncounterId`(`patientid` integer,`encounter_year` integer,`encounter_month` integer) RETURNS int(11)
BEGIN
RETURN (select MAX(encounter_id) from encounter where patientid=patient_id and EXTRACT(YEAR_MONTH FROM encounter_datetime) = EXTRACT(YEAR_MONTH FROM (MAKEDATE(encounter_year,1) + INTERVAL encounter_month MONTH - INTERVAL 1 DAY)) and voided=0 limit 1);
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` FUNCTION `getEncounterId2`(`patientid` integer,`encounter_year` integer,`encounter_quarter` integer) RETURNS int(11)
BEGIN
RETURN (select MAX(encounter_id) from encounter where patientid=patient_id and YEAR(encounter_datetime) = encounter_year AND QUARTER(encounter_datetime) = encounter_quarter and voided=0 limit 1);
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` FUNCTION `getEnrolDate`(`personid` INT) RETURNS date
    READS SQL DATA
BEGIN


RETURN (select encounter_datetime as enroldt
from encounter
where uuid = '8d5b27bc-c2cc-11de-8d13-0010c6dffd0f'
and voided=0
and personid=patient_id
limit 1
);

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` FUNCTION `getFirstArtStopDate`(`personid` integer) RETURNS date
    READS SQL DATA
BEGIN


RETURN
(
select value_datetime from obs where
concept_id=99084 and voided=0
and personid=person_id
limit 1);


END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` FUNCTION `getFlucStartDate`(`personid` integer) RETURNS date
    READS SQL DATA
BEGIN


RETURN (select min(obs_datetime) fluc_start from obs where concept_id=1193 and value_coded=747
and personid=person_id and voided=0 group by person_id );

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` FUNCTION `get_followup_status`(StartDate varchar(12), EndDate varchar(12), Patient_ID int) RETURNS char(50) CHARSET latin1
    DETERMINISTIC
RETURN
(
SELECT
	IFNULL((SELECT get_death_status(StartDate, EndDate , Patient_ID)) ,
		IFNULL((get_transfer_status(StartDate, EndDate , Patient_ID )),
			IFNULL((get_lost_status(StartDate, EndDate , Patient_ID )),
				IFNULL((get_seen_status(StartDate, EndDate , Patient_ID )),
					IFNULL((get_scheduled_visits(StartDate, EndDate , Patient_ID )) ,
						NULL
					)
				)
			)
		)
	) AS FollowUpStatus
)$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` FUNCTION `get_followup_status2`(StartDate varchar(12), EndDate varchar(12), Patient_ID int) RETURNS char(50) CHARSET utf8
BEGIN

RETURN CONCAT(get_death_status(StartDate, EndDate , Patient_ID),get_transfer_status(StartDate, EndDate , Patient_ID),get_lost_status(StartDate, EndDate , Patient_ID),get_seen_status(StartDate, EndDate , Patient_ID),get_scheduled_visits(StartDate, EndDate , Patient_ID));
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` FUNCTION `getFUARTStatus`(Patient_ID INTEGER, start_date DATE,end_date DATE) RETURNS char(1) CHARSET utf8
BEGIN

	DECLARE times_seen_in_quarter INT DEFAULT 0;
    DECLARE number_of_visits_in_quarter INT DEFAULT 0;
    DECLARE stopped INT DEFAULT 0;
    DECLARE lost INT DEFAULT 0;
    DECLARE restart INT DEFAULT 0;
    DECLARE transfer_out_date DATE;
    DECLARE death_date DATE;

	SELECT max(obs_datetime) INTO death_date
		FROM obs
		WHERE obs_datetime BETWEEN start_date AND end_date
		AND concept_id =99112 AND value_numeric = 1  AND person_Id = Patient_ID AND voided = 0
		GROUP BY person_Id;
	IF death_date is not null THEN
		return '1';
	ELSE
		SELECT max(obs_datetime) INTO transfer_out_date
		FROM obs
		WHERE obs_datetime BETWEEN start_date AND end_date
		AND concept_id =  90306 AND value_numeric = 1 AND person_Id = Patient_ID AND voided = 0;

        IF transfer_out_date is not null THEN
			return '5';
        ELSE
			SELECT COUNT(obs_id) INTO stopped
				FROM obs
				WHERE obs_datetime BETWEEN start_date AND end_date
				AND concept_id =  99132 AND value_coded = 1363 AND person_Id = Patient_ID AND voided = 0;

            IF stopped > 0 THEN
				return '2';
			ELSE
				SELECT COUNT(obs_id) INTO lost
					FROM obs
					WHERE obs_datetime BETWEEN start_date AND end_date
					AND concept_id =  99132 AND value_coded = 99133 AND person_Id = Patient_ID AND voided = 0;

                IF lost > 0  THEN
					return '3';
				ELSE
					SELECT max(obs_datetime) INTO restart
						FROM obs
						WHERE obs_datetime BETWEEN start_date AND end_date
						AND concept_id =  99085 AND value_datetime BETWEEN  start_date AND end_date AND person_Id = Patient_ID AND voided = 0;

                        IF restart is not null THEN
							return '6';
						ELSE
							SELECT COUNT(encounter_id) INTO times_seen_in_quarter
								FROM encounter
								WHERE encounter_datetime BETWEEN start_date AND end_date
                                AND encounter_type in(1,2)
								AND patient_id = Patient_ID AND voided = 0;

                            SELECT COUNT(obs_id ) INTO number_of_visits_in_quarter
								FROM obs
								WHERE value_datetime BETWEEN start_date AND end_date
								AND patient_id = Patient_ID AND concept_id = 5096 AND Voided = 0;
                            IF times_seen_in_quarter = 0 AND number_of_visits_in_quarter > 0 THEN
								return '4';
							ELSE
								return '';
							END IF;
						END IF;
				END IF;
            END IF;
		END IF;

	END IF;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` FUNCTION `getFunctionalStatusTxt`(`personid` integer, `obsdatetime` date) RETURNS char(5) CHARSET latin1
    READS SQL DATA
BEGIN


RETURN (select if(value_coded=90037, "Amb", if(value_coded=90038, "Work","Bed")) as f_status from obs
where concept_id=90235
and voided=0
and personid=person_id
and obsdatetime=obs_datetime
limit 1);
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` FUNCTION `getFUStatus`(Patient_ID INTEGER, start_date DATE,end_date DATE) RETURNS char(30) CHARSET utf8
BEGIN

	DECLARE times_seen_in_quarter INT DEFAULT 0;
    DECLARE number_of_visits_in_quarter INT DEFAULT 0;
    DECLARE transfer_out_date DATE;
    DECLARE death_date DATE;

	SELECT max(obs_datetime) INTO death_date
		FROM obs
		WHERE obs_datetime BETWEEN start_date AND end_date
		AND concept_id =99112 AND value_numeric = 1  AND person_Id = Patient_ID AND voided = 0
		GROUP BY person_Id;
	IF death_date is not null THEN
		return 'DEAD';
	ELSE
		SELECT max(obs_datetime) INTO transfer_out_date
		FROM obs
		WHERE obs_datetime BETWEEN start_date AND end_date
		AND concept_id =  90306 AND value_numeric = 1 AND person_Id = Patient_ID AND voided = 0;

        IF transfer_out_date is not null THEN
			return 'TO';
        ELSE
			SELECT COUNT(encounter_id) INTO times_seen_in_quarter
				FROM encounter
				WHERE encounter_datetime BETWEEN start_date AND end_date
				AND form_id = 27
				AND patient_id = Patient_ID AND voided = 0;
			IF times_seen_in_quarter > 0 THEN
				return '10003';
			ELSE
				SELECT COUNT(obs_id ) INTO number_of_visits_in_quarter
					FROM obs
					WHERE value_datetime BETWEEN start_date AND end_date
					AND patient_id = Patient_ID AND concept_id = 5096 AND Voided = 0;

                IF number_of_visits_in_quarter = 0 THEN
					return '8594';
				ELSEIF times_seen_in_quarter = 0 AND number_of_visits_in_quarter > 0 THEN
					return 'LOST';
				ELSE
					return '';
				END IF;
            END IF;
		END IF;

	END IF;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` FUNCTION `getINHStartDate`(`personid` integer) RETURNS date
    READS SQL DATA
BEGIN


	RETURN (select min(obs_datetime) cpt_start from obs where concept_id in(99604,99605) and personid=person_id and voided=0 group by person_id );
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` FUNCTION `getLastCd4SevereValue`(`personid` integer, `reportdt` date) RETURNS int(11)
    READS SQL DATA
BEGIN


RETURN(select
if(value_coded=99150,1,0) as severe
from obs
where concept_id =99151
and voided=0
and personid=person_id
and obs_datetime<=reportdt
order by person_id , obs_datetime desc
limit 1
);
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` FUNCTION `getLastCd4Value`(`personid` integer, `reportdt` date) RETURNS int(11)
    READS SQL DATA
BEGIN


RETURN (select value_numeric
from obs
where concept_id in(99071,5497)
and voided=0
and personid=person_id
and obs_datetime<=reportdt
order by person_id , obs_datetime desc
limit 1
);
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` FUNCTION `getLastEncounterDate`(`personid` integer) RETURNS date
    READS SQL DATA
BEGIN
	RETURN (select encounter_datetime from encounter where encounter_type in (1,2) and patient_id=personid and voided=0 order by encounter_datetime desc limit 1);
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` FUNCTION `getLastVisitDate`(`personid` integer,`reportdt` date) RETURNS date
    READS SQL DATA
BEGIN


RETURN (select date(max(encounter_datetime))
from encounter
where encounter_type in(1,2) and voided=0 and personid=patient_id
and  if(year(encounter_datetime) <year(reportdt),1, if((year(encounter_datetime)=year(reportdt) and month(encounter_datetime) <=month(reportdt) ),1,0 )) =1
group by patient_id);


END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` FUNCTION `get_lost_status`(StartDate varchar(12), EndDate varchar(12), Patient_ID int) RETURNS char(50) CHARSET latin1
    DETERMINISTIC
RETURN
	(
		SELECT  'LOST' As LostStatus
		FROM(
			SELECT person_Id, max(obs_datetime) DeathDate
			FROM obs
			WHERE obs_datetime BETWEEN str_to_date(StartDate,"%d/%m/%Y")  AND str_to_date(EndDate,"%d/%m/%Y")
			AND concept_id =	5240 AND value_numeric = 1  AND person_Id = Patient_ID AND voided = 0
			AND person_id NOT IN (
								SELECT person_Id
								FROM (
									SELECT person_Id, max(obs_datetime) DeathDate
									FROM obs
									WHERE concept_id IN( 99112, 90306) AND value_numeric = 1  and voided = 0
									GROUP BY person_Id)AA)
			GROUP BY person_Id
		)RecentLostStatus

	)$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` FUNCTION `getMonthCD4Value`(`personid` integer, `monthyr` char(6)) RETURNS int(11)
    READS SQL DATA
BEGIN


RETURN (select  value_numeric from obs where concept_id in
(99071, 5497)
and voided=0
and personid=person_id
and monthyr=concat(year(obs_datetime), month(obs_datetime))
limit 1

);
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` FUNCTION `getMonthsOnCurrent`(`personid`integer) RETURNS int(11)
    READS SQL DATA
BEGIN


	RETURN(
select period_diff(date_format(now(), '%Y%m'),date_format(obs_datetime, '%Y%m')) from obs
where concept_id=1255
and value_coded in(1590,1587)
and voided=0
and personid=person_id
order by obs_datetime desc
limit 1
)
;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` FUNCTION `getMonthsSinceStart`(`personid`integer) RETURNS int(11)
    READS SQL DATA
BEGIN


	RETURN(
select period_diff(date_format(now(), '%Y%m'),date_format(obs_datetime, '%Y%m')) as mnths from obs
where concept_id=1255
and value_coded in(1256,1585)
and voided=0
and personid=person_id
order by obs_datetime desc
limit 1)
;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` FUNCTION `getNumberDrugEncounter`(`personid` integer) RETURNS int(11)
    READS SQL DATA
BEGIN


RETURN (

select count(distinct value_coded)as number_summary from obs a

inner join

(select encounter_id from encounter
where encounter_type=2
and voided=0) b
on a.encounter_id=b.encounter_id

where concept_id in(90061,99064,90315)
and a.voided=0
and personid=person_id
group by person_id
limit 1
);

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` FUNCTION `getNumberDrugSummary`(`personid` integer) RETURNS int(11)
    READS SQL DATA
BEGIN


RETURN (

select count(distinct value_coded)as number_summary from obs a

inner join

(select encounter_id from encounter
where encounter_type=1
and voided=0) b
on a.encounter_id=b.encounter_id

where concept_id in(90061,99064,90315)
and a.voided=0
and personid=person_id
group by person_id
limit 1
);

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`openmrs`@`localhost` FUNCTION `getNutritionalStatus`(Patient_ID int,start_date DATE, end_date DATE) RETURNS char(10) CHARSET latin1
    DETERMINISTIC
RETURN
 	(
		SELECT CASE value_coded WHEN  99271 THEN 'MAM' WHEN  99272 THEN 'SAM' WHEN  99273 THEN 'SAMO' WHEN  99274 THEN 'PWG/PA' ELSE NULL END AS TBStatus
			FROM (
			SELECT obs.person_id, MAX(obs_datetime) AS firstDate, value_coded
			FROM obs
			WHERE concept_id =68 AND value_coded IN (99271, 99272, 99273,99274 ) and voided = 0
			AND person_id = Patient_ID AND obs_datetime BETWEEN start_date AND end_date
			GROUP BY person_id
		)NutritionalOptions
	)$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` FUNCTION `getPatientIdentifierTxt`(`personid` integer) RETURNS char(15) CHARSET latin1
    READS SQL DATA
BEGIN


RETURN (select identifier from patient_identifier
where voided=0
and personid=patient_id
limit 1);
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` FUNCTION `getReferralText`(`personid` integer) RETURNS char(30) CHARSET latin1
    READS SQL DATA
BEGIN
	RETURN (
select
if(concept_id=99054 and value_coded=99053,"Therapeutic Feeding",
if(concept_id=99054 and value_coded=99051,"Infant Feeding Counselling",
if(concept_id=99054 and value_coded=99052,"Nutrition Counselling",
if(concept_id=99054 and value_coded=99050,"Food Support",
if(concept_id=99267 and value_text is not null,"Other", ""))))) refer from obs
where concept_id in(99054, 99267)
and obs_datetime=getLastEncounterDate(personid)
and personid=person_id
and voided=0);
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` FUNCTION `getReturnDate`(`encounterid` integer) RETURNS date
    READS SQL DATA
BEGIN


RETURN (select value_datetime as return_date
from obs
where concept_id=5096
and voided=0
and encounterid=encounter_id
limit 1
);

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` FUNCTION `getReturnDate2`(`personid` integer,`obsdatetime` date) RETURNS date
    READS SQL DATA
BEGIN


RETURN (select value_datetime as return_date
from obs
where concept_id=5096
and voided=0
and personid=person_id
and obsdatetime=obs_datetime
limit 1
);

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` FUNCTION `get_scheduled_visits`(StartDate varchar(12), EndDate varchar(12), Patient_ID int) RETURNS char(50) CHARSET latin1
    DETERMINISTIC
RETURN
	(
		SELECT IF(NumberOfVisitsScheduledInPeriod = 0, 'NO SCHEDULED VISIT', NULL) AS Scheduled_Visits_Status
		FROM(
			SELECT COUNT(obs_id ) AS NumberOfVisitsScheduledInPeriod
			FROM obs
			WHERE value_datetime BETWEEN str_to_date(StartDate,"%d/%m/%Y")  AND str_to_date(EndDate,"%d/%m/%Y")
			AND patient_id = Patient_ID AND concept_id = 5096 AND Voided = 0
			) Visits

	)$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` FUNCTION `get_seen_status`(StartDate varchar(12), EndDate varchar(12), Patient_ID int) RETURNS char(50) CHARSET latin1
    DETERMINISTIC
RETURN
	(
		SELECT IF (NumberOfTimesSeenInPeriod>0, 'SEEN', NULL) As SEENStatus
		FROM(
			SELECT COUNT(encounter_id ) AS NumberOfTimesSeenInPeriod
			FROM encounter
			WHERE encounter_datetime BETWEEN str_to_date(StartDate,"%d/%m/%Y")  AND str_to_date(EndDate,"%d/%m/%Y")
			AND form_id = 31
			AND patient_id = Patient_ID

		)RecentSEENStatus

	)$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` FUNCTION `getStartEncounterId`(`personid` integer) RETURNS int(11)
    READS SQL DATA
BEGIN
	RETURN (select encounter_id from obs
where concept_id=1255 and value_coded in (1256,1585)
and person_id=personid
and voided=0
order by obs_datetime desc
limit 1
);
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` FUNCTION `getSubstituteDate`(`obsgroupid`integer) RETURNS date
    READS SQL DATA
BEGIN


	RETURN(
select value_datetime from
obs where concept_id=99163
and voided=0
and obsgroupid=obs_group_id
limit 1)
;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` FUNCTION `getSubstituteObsGroupId`(`personid` integer) RETURNS int(11)
    READS SQL DATA
BEGIN


	RETURN(
select obs_group_id
from obs where concept_id=99163 and voided=0
and personid=person_id
order by value_datetime asc
limit 0,1
)
;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` FUNCTION `getSubstituteObsGroupId2`(`personid` integer) RETURNS int(11)
    READS SQL DATA
BEGIN


	RETURN(
select obs_group_id
from obs where concept_id=99163 and voided=0
and personid=person_id order by value_datetime asc
limit 1,1
)
;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` FUNCTION `getSubstituteReasonTxt`(`obsgroupid`integer) RETURNS char(15) CHARSET latin1
    READS SQL DATA
BEGIN


	RETURN(
select
if(value_coded=90040, "Toxi",
if(value_coded=90041, "Preg",
if(value_coded=90042, "RiskPreg",
if(value_coded=90043, "NewTb",
if(value_coded=90044, "NewDrug",
if(value_coded=90045, "DrugStock",
if(value_coded=90002, "Other",
if(value_coded=90046, "Clinical",
if(value_coded=90047, "Immo",''))))))))) reason from
obs where concept_id=90246
and voided=0
and obsgroupid=obs_group_id
limit 1
)
;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` FUNCTION `getSwitchDate`(`obsgroupid`integer) RETURNS date
    READS SQL DATA
BEGIN


	RETURN(
select value_datetime from
obs where concept_id=99164
and voided=0
and obsgroupid=obs_group_id
limit 1
)
;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` FUNCTION `getSwitchObsGroupId`(`personid` integer) RETURNS int(11)
    READS SQL DATA
BEGIN


	RETURN(
select obs_group_id
from obs where concept_id=99164 and voided=0
and personid=person_id order by value_datetime asc
limit 0,1
)
;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` FUNCTION `getSwitchObsGroupId2`(`personid` integer) RETURNS int(11)
    READS SQL DATA
BEGIN


	RETURN(
select obs_group_id
from obs where concept_id=99164 and voided=0
and personid=person_id order by value_datetime asc
limit 1,2
)
;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` FUNCTION `getSwitchReasonTxt`(`obsgroupid`integer) RETURNS int(11)
    READS SQL DATA
BEGIN


	RETURN(
select
if(value_coded=90040, 1,
if(value_coded=90041, 2,
if(value_coded=90042, 3,
if(value_coded=90043, 4,
if(value_coded=90044, 5,
if(value_coded=90045, 6,
if(value_coded=90002, 7,
if(value_coded=90046, 8,
if(value_coded=90047, 9,null))))))))) reason from
obs where concept_id=90247
and voided=0
and obsgroupid=obs_group_id
limit 1
)
;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` FUNCTION `getTbRegNoTxt`(`personid` integer) RETURNS char(15) CHARSET utf8
    READS SQL DATA
BEGIN


RETURN (
select min(value_text) tb_reg
from obs
where concept_id=99031 and voided=0
and personid=person_id
limit 1 );

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` FUNCTION `getTbStartDate`(`personid` integer) RETURNS date
    READS SQL DATA
BEGIN


	RETURN (select min(value_datetime) as start from obs where concept_id=90217 and  voided=0  and personid=person_id group by person_id );
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` FUNCTION `get_tb_status`(StartDate varchar(12), EndDate varchar(12), Patient_ID int) RETURNS char(50) CHARSET latin1
    DETERMINISTIC
RETURN
 	(
		SELECT CASE value_coded WHEN  90079 THEN 1 WHEN  90073 THEN 2 WHEN  90217 THEN 3 ELSE NULL END AS TBStatus
			FROM (
			SELECT obs.person_id, MAX(obs_datetime) AS firstDate, value_coded
			FROM obs
			WHERE concept_id =90216 AND value_coded IN (90079, 90073, 90217 ) and voided = 0
			AND person_id = Patient_ID AND obs_datetime BETWEEN str_to_date(StartDate,"%d/%m/%Y")  AND str_to_date(EndDate,"%d/%m/%Y")
			GROUP BY person_id
			)TBOptions
	)$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` FUNCTION `getTbStatusTxt`(`encounterid` integer) RETURNS int(11)
    READS SQL DATA
BEGIN


RETURN (select if(value_coded=90079,1,
if(value_coded=90073,2,
if(value_coded=90071,3,null))) as tb_status
from obs
where concept_id =90216 and voided=0
and encounterid=encounter_id
limit 1
);

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` FUNCTION `getTbStopDate`(`personid` integer) RETURNS date
    READS SQL DATA
BEGIN


	RETURN (select
min(value_datetime) as stop
from obs where concept_id=90310
and  voided=0
and personid=person_id
group by person_id
limit 1 );
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` FUNCTION `getTransferInTxt`(`personid` integer) RETURNS char(5) CHARSET latin1
    READS SQL DATA
BEGIN


RETURN (select
if(concept_id=99055 and value_coded=1065, "TI",
if(concept_id=99110 and value_numeric=1,"TI",
if(concept_id=90206 and value_text is not null,"TI",
if(concept_id=99109 and value_text is not null,"TI",''))))as transfer_in from obs
where concept_id in(99055,99110,99109,90206)
and voided=0
and personid=person_id
limit 1
);

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` FUNCTION `getTransferOutDate`(`personid` integer) RETURNS date
    READS SQL DATA
BEGIN


RETURN (select value_datetime as tout_date
from obs
where concept_id=99165 and voided=0
and
personid=person_id
order by value_datetime desc
limit 1
);

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` FUNCTION `get_transfer_status`(StartDate varchar(12), EndDate varchar(12), Patient_ID int) RETURNS char(50) CHARSET latin1
    DETERMINISTIC
RETURN
	(
		SELECT  CONCAT(A.TransferStatus, ' ', B.TransferStatus) AS TransferStatus
		FROM(
			SELECT person_Id, max(obs_datetime) TransferDate, 'TO: ' AS TransferStatus
			FROM obs
			WHERE obs_datetime BETWEEN str_to_date(StartDate,"%d/%m/%Y")  AND str_to_date(EndDate,"%d/%m/%Y")
			AND concept_id =  90306 AND value_numeric = 1 AND person_Id = Patient_ID AND voided = 0
			GROUP BY person_Id
		) A LEFT JOIN
		(
			SELECT person_Id, max(obs_datetime) TransferDate, value_text   AS TransferStatus
			FROM obs
			WHERE obs_datetime BETWEEN str_to_date(StartDate,"%d/%m/%Y")  AND str_to_date(EndDate,"%d/%m/%Y")
			AND concept_id =  90211 AND person_Id = Patient_ID AND voided = 0
			GROUP BY person_Id
		) B ON A.person_Id = B.person_Id
	)$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` FUNCTION `getWeightValue`(`personid` integer, `obsdatetime` date) RETURNS int(11)
    READS SQL DATA
BEGIN


RETURN(
select value_numeric from obs
where concept_id=90236
and personid=person_id
and obsdatetime=obs_datetime
and voided=0
limit 1);
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` FUNCTION `getWhoStageBaseTxt`(`personid` integer, `artstartdt` date) RETURNS int(11)
    READS SQL DATA
BEGIN


RETURN (select
if(concept_id=99070 and value_coded=1204, 1,
if(concept_id=99070 and value_coded=1205, 2,
if(concept_id=99070 and value_coded=1206, 3,
if(concept_id=99070 and value_coded=1207, 4,
if(concept_id=90203 and value_coded=90033  and  obs_datetime=artstartdt or concept_id=90203 and value_coded=90293 and  obs_datetime=artstartdt,1,
if(concept_id=90203 and value_coded=90034  and  obs_datetime=artstartdt or concept_id=90203 and value_coded=90294 and  obs_datetime=artstartdt, 2,
if(concept_id=90203 and value_coded=90035  and  obs_datetime=artstartdt or concept_id=90203 and value_coded=90295 and  obs_datetime=artstartdt, 3,
if(concept_id=90203 and value_coded=90036  and  obs_datetime=artstartdt or concept_id=90203 and value_coded=90296 and  obs_datetime=artstartdt, 4, null)))))))) as stage
from obs
where concept_id in(90203,99070)
and personid=person_id
and voided=0
having stage is not null
limit 1
);
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` FUNCTION `getWHOStageDate`(patient_id INT,stage INT) RETURNS date
BEGIN
RETURN (SELECT MAX(obs_datetime) FROM obs where concept_id = 90203 AND (obs_datetime < getArtBaseTransferDate(patient_id) OR getArtBaseTransferDate(patient_id) is null) AND person_id = patient_id AND value_coded = if(stage =1,90033,if(stage = 2,90034,if(stage=3,90035,if(stage=4,90036,null)))) AND concept_id is not null);
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` FUNCTION `getWhoStageTxt`(`personid` integer, `obsdatetime` date) RETURNS int(11)
    READS SQL DATA
BEGIN


RETURN (select
if(concept_id=90203 and value_coded=90033  or concept_id=90203 and value_coded=90293,1,
if(concept_id=90203 and value_coded=90034  or concept_id=90203 and value_coded=90294, 2,
if(concept_id=90203 and value_coded=90035  or concept_id=90203 and value_coded=90295, 3,
if(concept_id=90203 and value_coded=90036  or concept_id=90203 and value_coded=90296, 4, null)))) as stage
from obs
where concept_id =90203
and personid=person_id
and obsdatetime=obs_datetime
and voided=0
having stage is not null
limit 1
);
END$$
DELIMITER ;

