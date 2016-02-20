
-- ----------------------------
-- Function structure for get_adherence_Count
-- ----------------------------
DROP FUNCTION IF EXISTS `get_adherence_Count`;

DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `get_adherence_Count`(AdherenceType int, StartDate Date, EndDate Date) RETURNS int(11)
    DETERMINISTIC
begin
	declare result int DEFAULT -1;
	
-- noinspection SqlNoDataSourceInspection
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
end;;
DELIMITER ;

-- ----------------------------
-- Function structure for get_adherenceType_Count
-- ----------------------------
DROP FUNCTION IF EXISTS `get_adherenceType_Count`;
DELIMITER ;;
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
end;;
DELIMITER ;

-- ----------------------------
-- Function structure for get_CD4_count
-- ----------------------------
DROP FUNCTION IF EXISTS `get_CD4_count`;
DELIMITER ;;
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
);;
DELIMITER ;

-- ----------------------------
-- Function structure for get_cpt_receipt_status
-- ----------------------------
DROP FUNCTION IF EXISTS `get_cpt_receipt_status`;
DELIMITER ;;
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
	);;
DELIMITER ;

-- ----------------------------
-- Function structure for get_death_status
-- ----------------------------
DROP FUNCTION IF EXISTS `get_death_status`;
DELIMITER ;;
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
		);;
DELIMITER ;

-- ----------------------------
-- Function structure for get_followup_status
-- ----------------------------
DROP FUNCTION IF EXISTS `get_followup_status`;
DELIMITER ;;
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
);;
DELIMITER ;

-- ----------------------------
-- Function structure for get_lost_status
-- ----------------------------
DROP FUNCTION IF EXISTS `get_lost_status`;
DELIMITER ;;
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
		
	);;
DELIMITER ;

-- ----------------------------
-- Function structure for get_scheduled_visits
-- ----------------------------
DROP FUNCTION IF EXISTS `get_scheduled_visits`;
DELIMITER ;;
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
		
	);;
DELIMITER ;

-- ----------------------------
-- Function structure for get_seen_status
-- ----------------------------
DROP FUNCTION IF EXISTS `get_seen_status`;
DELIMITER ;;
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
		
	);;
DELIMITER ;

-- ----------------------------
-- Function structure for get_tb_status
-- ----------------------------
DROP FUNCTION IF EXISTS `get_tb_status`;
DELIMITER ;;
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
	);;
DELIMITER ;

-- ----------------------------
-- Function structure for get_transfer_status
-- ----------------------------
DROP FUNCTION IF EXISTS `get_transfer_status`;
DELIMITER ;;
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
	);;
DELIMITER ;

-- ----------------------------
-- Function structure for getAncNumberTxt
-- ----------------------------
DROP FUNCTION IF EXISTS `getAncNumberTxt`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `getAncNumberTxt`(`encounterid` integer) RETURNS char(15) CHARSET latin1
    READS SQL DATA
BEGIN
	#Routine body goes here...

	RETURN (select value_text from obs where concept_id=99026
and encounterid=encounter_id
and voided=0
limit 1

 );
END;;
DELIMITER ;

-- ----------------------------
-- Function structure for getAppKeepTxt
-- ----------------------------
DROP FUNCTION IF EXISTS `getAppKeepTxt`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `getAppKeepTxt`(`encounterid` integer) RETURNS char(3) CHARSET latin1
    READS SQL DATA
BEGIN
	#Routine body goes here...

RETURN (select  if(value_numeric=1, "Y", "N") as app_keep from obs
where concept_id=90069
and voided=0
and encounterid=encounter_id
limit 1

);

END;;
DELIMITER ;

-- ----------------------------
-- Function structure for getArtBaseTransferDate
-- ----------------------------
DROP FUNCTION IF EXISTS `getArtBaseTransferDate`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `getArtBaseTransferDate`(`personid` integer) RETURNS date
    READS SQL DATA
BEGIN
	#Routine body goes here...

RETURN 
(select value_datetime from obs 
where concept_id in(99161,99160)
and person_id=personid
and voided=0
limit 1);


END;;
DELIMITER ;

-- ----------------------------
-- Function structure for getArtEligibilityDate
-- ----------------------------
DROP FUNCTION IF EXISTS `getArtEligibilityDate`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `getArtEligibilityDate`(`personid` integer) RETURNS date
    READS SQL DATA
BEGIN
	#Routine body goes here...

RETURN (select value_datetime as eligible_date from obs
where concept_id =90297
and voided=0 
and personid=person_id
limit 1
);

END;;
DELIMITER ;

-- ----------------------------
-- Function structure for getArtEligibilityReasonTxt
-- ----------------------------
DROP FUNCTION IF EXISTS `getArtEligibilityReasonTxt`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `getArtEligibilityReasonTxt`(`personid` integer) RETURNS char(15) CHARSET latin1
    READS SQL DATA
BEGIN
	#Routine body goes here...

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

END;;
DELIMITER ;

-- ----------------------------
-- Function structure for getArtRegCoded
-- ----------------------------
DROP FUNCTION IF EXISTS `getArtRegCoded`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `getArtRegCoded`(`encounterid` integer) RETURNS char(12) CHARSET latin1
    READS SQL DATA
BEGIN
	#Routine body goes here...

RETURN (select value_coded as freg
from obs  
where concept_id in(99061, 90315) 
and voided=0 
and encounterid=encounter_id
limit 1 );
END;;
DELIMITER ;

-- ----------------------------
-- Function structure for getArtRegCoded2
-- ----------------------------
DROP FUNCTION IF EXISTS `getArtRegCoded2`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `getArtRegCoded2`(`personid` integer, `obsdatetime` date) RETURNS int(11)
    READS SQL DATA
BEGIN
	#Routine body goes here...

RETURN (select value_coded as freg
from obs  
where concept_id in(99061, 90315) 
and voided=0 
and personid=person_id
and obsdatetime=obs_datetime
limit 1 );
END;;
DELIMITER ;

-- ----------------------------
-- Function structure for getArtRegTxt
-- ----------------------------
DROP FUNCTION IF EXISTS `getArtRegTxt`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `getArtRegTxt`(`encounterid` integer) RETURNS char(6) CHARSET latin1
    READS SQL DATA
BEGIN
	#Routine body goes here...

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
END;;
DELIMITER ;

-- ----------------------------
-- Function structure for getArtRegTxt2
-- ----------------------------
DROP FUNCTION IF EXISTS `getArtRegTxt2`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `getArtRegTxt2`(`personid` integer, `obsdatetime` date) RETURNS char(10) CHARSET latin1
    READS SQL DATA
BEGIN
	#This function takes 2 parameters the personid and obs_datetime used for situations where we need the art regimen at a particular date eg. the regimen at the start date etc

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
END;;
DELIMITER ;

-- ----------------------------
-- Function structure for getArtRestartDate
-- ----------------------------
DROP FUNCTION IF EXISTS `getArtRestartDate`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `getArtRestartDate`(`personid` integer,`encdt` char(6)) RETURNS date
    READS SQL DATA
BEGIN
	#Routine body goes here...

RETURN (/*99084 stop date*/
select value_datetime from obs 
where concept_id=99085
and voided=0
and personid=person_id
and concat(year(value_datetime),month(value_datetime))=encdt
limit 1
);

END;;
DELIMITER ;

-- ----------------------------
-- Function structure for getArtStartDate
-- ----------------------------
DROP FUNCTION IF EXISTS `getArtStartDate`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `getArtStartDate`(`personid` integer) RETURNS date
    READS SQL DATA
BEGIN
	#Routine body goes here...

RETURN 
(select value_datetime from obs 
where concept_id in(99160,99161) /*includes transfer in and those that started regimen from the facility*/
and personid=person_id
and voided=0
order by value_datetime asc
limit 1);


END;;
DELIMITER ;

-- ----------------------------
-- Function structure for getArtStartDate2
-- ----------------------------
DROP FUNCTION IF EXISTS `getArtStartDate2`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `getArtStartDate2`(`personid` integer, `reportdt` date) RETURNS date
    READS SQL DATA
BEGIN
	#Routine body goes here...

RETURN 
(select value_datetime from obs 
where concept_id in(99160,99161) /*Includes transfer ins and thost patients that started from the facility*/
and person_id=personid
and value_datetime<=reportdt
and voided=0
order by value_datetime asc
limit 1);


END;;
DELIMITER ;

-- ----------------------------
-- Function structure for getArtStartRegTxt
-- ----------------------------
DROP FUNCTION IF EXISTS `getArtStartRegTxt`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `getArtStartRegTxt`(`personid` integer) RETURNS char(10) CHARSET latin1
    READS SQL DATA
BEGIN
	#This function takes 2 parameters the personid and obs_datetime used for situations where we need the art regimen at a particular date eg. the regimen at the start date etc

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
END;;
DELIMITER ;

-- ----------------------------
-- Function structure for getArtStopDate
-- ----------------------------
DROP FUNCTION IF EXISTS `getArtStopDate`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `getArtStopDate`(`personid` integer, `obsdatetime` date) RETURNS date
    READS SQL DATA
BEGIN
	#Routine body goes here...

RETURN 
(
select value_datetime from obs where
concept_id=99084 and voided=0
and personid=person_id
and obsdatetime=value_datetime
limit 1);


END;;
DELIMITER ;

-- ----------------------------
-- Function structure for getArtStopDate1
-- ----------------------------
DROP FUNCTION IF EXISTS `getArtStopDate1`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `getArtStopDate1`(`personid` integer,`encdt` char(6)) RETURNS date
    READS SQL DATA
BEGIN
	#Routine body goes here...

RETURN (/*99084 stop date*/
select value_datetime from obs 
where concept_id=99084
and voided=0
and personid=person_id
and 
encdt=concat(year(value_datetime),month(value_datetime))
limit 1
);

END;;
DELIMITER ;

-- ----------------------------
-- Function structure for getArtStopReasonTxt
-- ----------------------------
DROP FUNCTION IF EXISTS `getArtStopReasonTxt`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `getArtStopReasonTxt`(`personid` integer, `encdt` char) RETURNS char(2) CHARSET latin1
    READS SQL DATA
BEGIN
	#Routine body goes here...

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

END;;
DELIMITER ;

-- ----------------------------
-- Function structure for getBaseWeightValue
-- ----------------------------
DROP FUNCTION IF EXISTS `getBaseWeightValue`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `getBaseWeightValue`(`personid` integer,`artstartdt` date) RETURNS int(11)
    READS SQL DATA
BEGIN
	#Routine body goes here...

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

END;;
DELIMITER ;

-- ----------------------------
-- Function structure for getCareEntryTxt
-- ----------------------------
DROP FUNCTION IF EXISTS `getCareEntryTxt`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `getCareEntryTxt`(`personid` integer) RETURNS char(15) CHARSET latin1
    READS SQL DATA
BEGIN
	#Routine body goes here...

RETURN (select if(value_coded=90012,"PMTCT",
if(value_coded=90013,"Medical",
if(value_coded=90014,"Under 5",
if(value_coded=90016,"TB",
if(value_coded=90015,"STI",
if(value_coded=90018,"Inpatient",
if(value_coded=90019,"Outreach",
if(value_coded=99087,"Exposed Infant",
if(value_coded=99002,"Other",''))))))))) as care_entry from obs
where concept_id =90200
and voided=0 
and personid=person_id
limit 1
);

END;;
DELIMITER ;

-- ----------------------------
-- Function structure for getCd4BaseValue
-- ----------------------------
DROP FUNCTION IF EXISTS `getCd4BaseValue`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `getCd4BaseValue`(`personid` integer, `artstartdt` date) RETURNS int(11)
    READS SQL DATA
BEGIN
#Routine body goes here...

RETURN (select 
if(concept_id=99071,value_numeric,
if(concept_id=5497 and datediff(artstartdt,obs_datetime) between 0 and 31, value_numeric, null )) as bcd4
from obs  
where concept_id in(99071,5497)
and voided=0
and personid=person_id
and artstartdt=artstartdt /*put getArtStartDate as the artstartdt parameter*/
having bcd4 is not null
limit 1
);
END;;
DELIMITER ;

-- ----------------------------
-- Function structure for getCd4SevereBaseValue
-- ----------------------------
DROP FUNCTION IF EXISTS `getCd4SevereBaseValue`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `getCd4SevereBaseValue`(`personid` integer, `artstartdt` date) RETURNS int(11)
    READS SQL DATA
BEGIN
#Routine body goes here...

RETURN (select 
if(value_coded=99150 and datediff(artstartdt,obs_datetime) between 0 and 31, 0, null ) as bsevere
from obs  
where concept_id =99151
and voided=0
and personid=person_id
and artstartdt=artstartdt /*put getArtStartDate as the artstartdt parameter*/
limit 1
);
END;;
DELIMITER ;

-- ----------------------------
-- Function structure for getCD4Value
-- ----------------------------
DROP FUNCTION IF EXISTS `getCD4Value`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `getCD4Value`(`personid` integer, `obsdatetime` date) RETURNS int(11)
    READS SQL DATA
BEGIN
#Routine body goes here...

RETURN (select value_numeric from obs 
where concept_id in
(99071, 5497) 
and voided=0
and obsdatetime=obs_datetime
and personid=person_id
limit 1
);
END;;
DELIMITER ;

-- ----------------------------
-- Function structure for getCodedDeathDate
-- ----------------------------
DROP FUNCTION IF EXISTS `getCodedDeathDate`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `getCodedDeathDate`(`personid` integer) RETURNS date
    READS SQL DATA
BEGIN
	#Routine body goes here...

RETURN (select value_datetime
from obs 
where concept_id=90272  and voided=0
and personid=person_id
limit 1
);

END;;
DELIMITER ;

-- ----------------------------
-- Function structure for getCptStartDate
-- ----------------------------
DROP FUNCTION IF EXISTS `getCptStartDate`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `getCptStartDate`(`personid` integer) RETURNS date
    READS SQL DATA
BEGIN
	#Routine body goes here...

	RETURN (select min(obs_datetime) cpt_start from obs where concept_id in(99033,99037) and personid=person_id and voided=0 group by person_id );
END;;
DELIMITER ;

-- ----------------------------
-- Function structure for getCptStatusTxt
-- ----------------------------
DROP FUNCTION IF EXISTS `getCptStatusTxt`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `getCptStatusTxt`(`encounterid` integer) RETURNS char(3) CHARSET latin1
    READS SQL DATA
BEGIN
	#Routine body goes here...

RETURN (select if(value_coded is not null, "N", if(value_numeric=0, "N",if(value_numeric >0, "Y",""))) as cpt
from obs
where concept_id in(90220,99037,99033) and voided=0
and encounterid=encounter_id
having cpt!=""
limit 1
);

END;;
DELIMITER ;

-- ----------------------------
-- Function structure for getDeathDate
-- ----------------------------
DROP FUNCTION IF EXISTS `getDeathDate`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `getDeathDate`(`personid` integer) RETURNS date
    READS SQL DATA
BEGIN
	#Routine body goes here...

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

END;;
DELIMITER ;

-- ----------------------------
-- Function structure for getEddDate
-- ----------------------------
DROP FUNCTION IF EXISTS `getEddDate`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `getEddDate`(`encounterid` integer) RETURNS date
    READS SQL DATA
BEGIN
	#Routine body goes here...

	RETURN (select value_datetime from obs where concept_id=5596
and encounterid=encounter_id
and voided=0
limit 1

 );
END;;
DELIMITER ;

-- ----------------------------
-- Function structure for getEddEncounterId
-- ----------------------------
DROP FUNCTION IF EXISTS `getEddEncounterId`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `getEddEncounterId`(`personid` integer) RETURNS int(11)
    READS SQL DATA
BEGIN
	#Routine body goes here...

	RETURN (
select encounter_id from obs  a
where concept_id =5596
and personid=person_id
and voided=0
group by person_id, concat(year(value_datetime), month(value_datetime)) 
limit 1

 );
END;;
DELIMITER ;

-- ----------------------------
-- Function structure for getEddEncounterId2
-- ----------------------------
DROP FUNCTION IF EXISTS `getEddEncounterId2`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `getEddEncounterId2`(`personid` integer) RETURNS int(11)
    READS SQL DATA
BEGIN
	#Routine body goes here...

	RETURN (
select encounter_id from obs  a
where concept_id =5596
and personid=person_id
and voided=0
group by person_id, concat(year(value_datetime), month(value_datetime)) 
limit 1,1

 );
END;;
DELIMITER ;

-- ----------------------------
-- Function structure for getEddEncounterId3
-- ----------------------------
DROP FUNCTION IF EXISTS `getEddEncounterId3`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `getEddEncounterId3`(`personid` integer) RETURNS int(11)
    READS SQL DATA
BEGIN
	#Routine body goes here...

	RETURN (
select encounter_id from obs  a
where concept_id =5596
and personid=person_id
and voided=0
group by person_id, concat(year(value_datetime), month(value_datetime))
limit 2,1

 );
END;;
DELIMITER ;

-- ----------------------------
-- Function structure for getEddEncounterId4
-- ----------------------------
DROP FUNCTION IF EXISTS `getEddEncounterId4`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `getEddEncounterId4`(`personid` integer) RETURNS int(11)
    READS SQL DATA
BEGIN
	#Routine body goes here...

	RETURN (
select encounter_id from obs  a
where concept_id =5596
and personid=person_id
and voided=0
group by person_id, concat(year(value_datetime)) 
limit 3,1

 );
END;;
DELIMITER ;

-- ----------------------------
-- Function structure for getEnrolDate
-- ----------------------------
DROP FUNCTION IF EXISTS `getEnrolDate`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `getEnrolDate`(`personid` integer) RETURNS date
    READS SQL DATA
BEGIN
	#Routine body goes here...

RETURN (select encounter_datetime as enroldt 
from encounter 
where encounter_type=1 
and voided=0
and personid=patient_id
limit 1
);

END;;
DELIMITER ;

-- ----------------------------
-- Function structure for getFirstArtStopDate
-- ----------------------------
DROP FUNCTION IF EXISTS `getFirstArtStopDate`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `getFirstArtStopDate`(`personid` integer) RETURNS date
    READS SQL DATA
BEGIN
	#Routine body goes here...

RETURN 
(
select value_datetime from obs where
concept_id=99084 and voided=0
and personid=person_id
limit 1);


END;;
DELIMITER ;

-- ----------------------------
-- Function structure for getFlucStartDate
-- ----------------------------
DROP FUNCTION IF EXISTS `getFlucStartDate`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `getFlucStartDate`(`personid` integer) RETURNS date
    READS SQL DATA
BEGIN
	#Routine body goes here...

RETURN (select min(obs_datetime) fluc_start from obs where concept_id=1193 and value_coded=747 
and personid=person_id and voided=0 group by person_id );

END;;
DELIMITER ;

-- ----------------------------
-- Function structure for getFunctionalStatusTxt
-- ----------------------------
DROP FUNCTION IF EXISTS `getFunctionalStatusTxt`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `getFunctionalStatusTxt`(`personid` integer, `obsdatetime` date) RETURNS char(5) CHARSET latin1
    READS SQL DATA
BEGIN
#Routine body goes here...

RETURN (select if(value_coded=90037, "Amb", if(value_coded=90038, "Work","Bed")) as f_status from obs 
where concept_id=90235
and voided=0
and personid=person_id
and obsdatetime=obs_datetime
limit 1);
END;;
DELIMITER ;

-- ----------------------------
-- Function structure for getLastCd4SevereValue
-- ----------------------------
DROP FUNCTION IF EXISTS `getLastCd4SevereValue`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `getLastCd4SevereValue`(`personid` integer, `reportdt` date) RETURNS int(11)
    READS SQL DATA
BEGIN
#Routine body goes here...

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
END;;
DELIMITER ;

-- ----------------------------
-- Function structure for getLastCd4Value
-- ----------------------------
DROP FUNCTION IF EXISTS `getLastCd4Value`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `getLastCd4Value`(`personid` integer, `reportdt` date) RETURNS int(11)
    READS SQL DATA
BEGIN
#Routine body goes here...

RETURN (select value_numeric
from obs  
where concept_id in(99071,5497)
and voided=0
and personid=person_id
and obs_datetime<=reportdt
order by person_id , obs_datetime desc
limit 1 
);
END;;
DELIMITER ;

-- ----------------------------
-- Function structure for getLastEncounterDate
-- ----------------------------
DROP FUNCTION IF EXISTS `getLastEncounterDate`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `getLastEncounterDate`(`personid` integer) RETURNS date
    READS SQL DATA
BEGIN
	RETURN (select encounter_datetime from encounter where encounter_type in (1,2) and patient_id=personid and voided=0 order by encounter_datetime desc limit 1);
END;;
DELIMITER ;

-- ----------------------------
-- Function structure for getLastVisitDate
-- ----------------------------
DROP FUNCTION IF EXISTS `getLastVisitDate`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `getLastVisitDate`(`personid` integer,`reportdt` date) RETURNS date
    READS SQL DATA
BEGIN
	#Routine body goes here...

RETURN (select date(max(encounter_datetime)) 
from encounter 
where encounter_type in(1,2) and voided=0 and personid=patient_id
and  if(year(encounter_datetime) <year(reportdt),1, if((year(encounter_datetime)=year(reportdt) and month(encounter_datetime) <=month(reportdt) ),1,0 )) =1
group by patient_id);


END;;
DELIMITER ;

-- ----------------------------
-- Function structure for getMonthCD4Value
-- ----------------------------
DROP FUNCTION IF EXISTS `getMonthCD4Value`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `getMonthCD4Value`(`personid` integer, `monthyr` char(6)) RETURNS int(11)
    READS SQL DATA
BEGIN
#Routine body goes here...

RETURN (select  value_numeric from obs where concept_id in
(99071, 5497) 
and voided=0
and personid=person_id
and monthyr=concat(year(obs_datetime), month(obs_datetime))
limit 1

);
END;;
DELIMITER ;

-- ----------------------------
-- Function structure for getMonthsOnCurrent
-- ----------------------------
DROP FUNCTION IF EXISTS `getMonthsOnCurrent`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `getMonthsOnCurrent`(`personid`integer) RETURNS int(11)
    READS SQL DATA
BEGIN
	#Routine body goes here...

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
END;;
DELIMITER ;

-- ----------------------------
-- Function structure for getMonthsSinceStart
-- ----------------------------
DROP FUNCTION IF EXISTS `getMonthsSinceStart`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `getMonthsSinceStart`(`personid`integer) RETURNS int(11)
    READS SQL DATA
BEGIN
	#Routine body goes here...

	RETURN(
select period_diff(date_format(now(), '%Y%m'),date_format(obs_datetime, '%Y%m')) as mnths from obs
where concept_id=1255 
and value_coded in(1256,1585) 
and voided=0 
and personid=person_id
order by obs_datetime desc
limit 1)
;
END;;
DELIMITER ;

-- ----------------------------
-- Function structure for getNumberDrugEncounter
-- ----------------------------
DROP FUNCTION IF EXISTS `getNumberDrugEncounter`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `getNumberDrugEncounter`(`personid` integer) RETURNS int(11)
    READS SQL DATA
BEGIN
	#Routine body goes here...

RETURN (/*
99061 base regimen
99064 transfer in regimen
90315 substitute/switch regimen
*/

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

END;;
DELIMITER ;

-- ----------------------------
-- Function structure for getNumberDrugSummary
-- ----------------------------
DROP FUNCTION IF EXISTS `getNumberDrugSummary`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `getNumberDrugSummary`(`personid` integer) RETURNS int(11)
    READS SQL DATA
BEGIN
	#Routine body goes here...

RETURN (/*
99061 base regimen
99064 transfer in regimen
90315 substitute/switch regimen
*/

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

END;;
DELIMITER ;

-- ----------------------------
-- Function structure for getPatientIdentifierTxt
-- ----------------------------
DROP FUNCTION IF EXISTS `getPatientIdentifierTxt`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `getPatientIdentifierTxt`(`personid` integer) RETURNS char(15) CHARSET latin1
    READS SQL DATA
BEGIN
#Routine body goes here...

RETURN (select identifier from patient_identifier 
where voided=0 
and personid=patient_id
limit 1);
END;;
DELIMITER ;

-- ----------------------------
-- Function structure for getReferralText
-- ----------------------------
DROP FUNCTION IF EXISTS `getReferralText`;
DELIMITER ;;
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
END;;
DELIMITER ;

-- ----------------------------
-- Function structure for getReturnDate
-- ----------------------------
DROP FUNCTION IF EXISTS `getReturnDate`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `getReturnDate`(`encounterid` integer) RETURNS date
    READS SQL DATA
BEGIN
	#Routine body goes here...

RETURN (select value_datetime as return_date
from obs 
where concept_id=5096 
and voided=0
and encounterid=encounter_id
limit 1
);

END;;
DELIMITER ;

-- ----------------------------
-- Function structure for getReturnDate2
-- ----------------------------
DROP FUNCTION IF EXISTS `getReturnDate2`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `getReturnDate2`(`personid` integer,`obsdatetime` date) RETURNS date
    READS SQL DATA
BEGIN
	#Routine body goes here...

RETURN (select value_datetime as return_date
from obs 
where concept_id=5096 
and voided=0
and personid=person_id
and obsdatetime=obs_datetime
limit 1
);

END;;
DELIMITER ;

-- ----------------------------
-- Function structure for getStartEncounterId
-- ----------------------------
DROP FUNCTION IF EXISTS `getStartEncounterId`;
DELIMITER ;;
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
END;;
DELIMITER ;

-- ----------------------------
-- Function structure for getSubstituteDate
-- ----------------------------
DROP FUNCTION IF EXISTS `getSubstituteDate`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `getSubstituteDate`(`obsgroupid`integer) RETURNS date
    READS SQL DATA
BEGIN
	#Routine body goes here...

	RETURN(
select value_datetime from
obs where concept_id=99163
and voided=0
and obsgroupid=obs_group_id
limit 1)
;
END;;
DELIMITER ;

-- ----------------------------
-- Function structure for getSubstituteObsGroupId
-- ----------------------------
DROP FUNCTION IF EXISTS `getSubstituteObsGroupId`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `getSubstituteObsGroupId`(`personid` integer) RETURNS int(11)
    READS SQL DATA
BEGIN
	#Routine body goes here...

	RETURN(
select obs_group_id
from obs where concept_id=99163 and voided=0
and personid=person_id
order by value_datetime asc
limit 0,1
)
;
END;;
DELIMITER ;

-- ----------------------------
-- Function structure for getSubstituteObsGroupId2
-- ----------------------------
DROP FUNCTION IF EXISTS `getSubstituteObsGroupId2`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `getSubstituteObsGroupId2`(`personid` integer) RETURNS int(11)
    READS SQL DATA
BEGIN
	#Routine body goes here...

	RETURN(
select obs_group_id
from obs where concept_id=99163 and voided=0
and personid=person_id order by value_datetime asc
limit 1,1
)
;
END;;
DELIMITER ;

-- ----------------------------
-- Function structure for getSubstituteReasonTxt
-- ----------------------------
DROP FUNCTION IF EXISTS `getSubstituteReasonTxt`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `getSubstituteReasonTxt`(`obsgroupid`integer) RETURNS char(15) CHARSET latin1
    READS SQL DATA
BEGIN
	#Routine body goes here...

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
END;;
DELIMITER ;

-- ----------------------------
-- Function structure for getSwitchDate
-- ----------------------------
DROP FUNCTION IF EXISTS `getSwitchDate`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `getSwitchDate`(`obsgroupid`integer) RETURNS date
    READS SQL DATA
BEGIN
	#Routine body goes here...

	RETURN(
select value_datetime from
obs where concept_id=99164
and voided=0
and obsgroupid=obs_group_id
limit 1
)
;
END;;
DELIMITER ;

-- ----------------------------
-- Function structure for getSwitchObsGroupId
-- ----------------------------
DROP FUNCTION IF EXISTS `getSwitchObsGroupId`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `getSwitchObsGroupId`(`personid` integer) RETURNS int(11)
    READS SQL DATA
BEGIN
	#Routine body goes here...

	RETURN(
select obs_group_id
from obs where concept_id=99164 and voided=0
and personid=person_id order by value_datetime asc
limit 0,1
)
;
END;;
DELIMITER ;

-- ----------------------------
-- Function structure for getSwitchObsGroupId2
-- ----------------------------
DROP FUNCTION IF EXISTS `getSwitchObsGroupId2`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `getSwitchObsGroupId2`(`personid` integer) RETURNS int(11)
    READS SQL DATA
BEGIN
	#Routine body goes here...

	RETURN(
select obs_group_id
from obs where concept_id=99164 and voided=0
and personid=person_id order by value_datetime asc
limit 1,2
)
;
END;;
DELIMITER ;

-- ----------------------------
-- Function structure for getSwitchReasonTxt
-- ----------------------------
DROP FUNCTION IF EXISTS `getSwitchReasonTxt`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `getSwitchReasonTxt`(`obsgroupid`integer) RETURNS int(11)
    READS SQL DATA
BEGIN
	#Routine body goes here...

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
END;;
DELIMITER ;

-- ----------------------------
-- Function structure for getTbRegNoTxt
-- ----------------------------
DROP FUNCTION IF EXISTS `getTbRegNoTxt`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `getTbRegNoTxt`(`personid` integer) RETURNS char(15) CHARSET utf8
    READS SQL DATA
BEGIN
	#Routine body goes here...

RETURN (
select min(value_text) tb_reg 
from obs 
where concept_id=99031 and voided=0 
and personid=person_id
limit 1 );

END;;
DELIMITER ;

-- ----------------------------
-- Function structure for getTbStartDate
-- ----------------------------
DROP FUNCTION IF EXISTS `getTbStartDate`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `getTbStartDate`(`personid` integer) RETURNS date
    READS SQL DATA
BEGIN
	#Routine body goes here...

	RETURN (select min(value_datetime) as start from obs where concept_id=90217 and  voided=0  and personid=person_id group by person_id );
END;;
DELIMITER ;

-- ----------------------------
-- Function structure for getTbStatusTxt
-- ----------------------------
DROP FUNCTION IF EXISTS `getTbStatusTxt`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `getTbStatusTxt`(`encounterid` integer) RETURNS int(11)
    READS SQL DATA
BEGIN
	#Routine body goes here...

RETURN (select if(value_coded=90079,1,
if(value_coded=90073,2,
if(value_coded=90071,3,null))) as tb_status
from obs
where concept_id =90216 and voided=0
and encounterid=encounter_id
limit 1
);

END;;
DELIMITER ;

-- ----------------------------
-- Function structure for getTbStopDate
-- ----------------------------
DROP FUNCTION IF EXISTS `getTbStopDate`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `getTbStopDate`(`personid` integer) RETURNS date
    READS SQL DATA
BEGIN
	#Routine body goes here...

	RETURN (select 
min(value_datetime) as stop 
from obs where concept_id=90310 
and  voided=0  
and personid=person_id 
group by person_id
limit 1 );
END;;
DELIMITER ;

-- ----------------------------
-- Function structure for getTransferInTxt
-- ----------------------------
DROP FUNCTION IF EXISTS `getTransferInTxt`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `getTransferInTxt`(`personid` integer) RETURNS char(5) CHARSET latin1
    READS SQL DATA
BEGIN
	#Routine body goes here...

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

END;;
DELIMITER ;

-- ----------------------------
-- Function structure for getTransferOutDate
-- ----------------------------
DROP FUNCTION IF EXISTS `getTransferOutDate`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `getTransferOutDate`(`personid` integer) RETURNS date
    READS SQL DATA
BEGIN
	#Routine body goes here...

RETURN (select value_datetime as tout_date
from obs  
where concept_id=99165 and voided=0 
and
personid=person_id
order by value_datetime desc
limit 1
);

END;;
DELIMITER ;

-- ----------------------------
-- Function structure for getWeightValue
-- ----------------------------
DROP FUNCTION IF EXISTS `getWeightValue`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `getWeightValue`(`personid` integer, `obsdatetime` date) RETURNS int(11)
    READS SQL DATA
BEGIN
#Routine body goes here...

RETURN(
select value_numeric from obs 
where concept_id=90236
and personid=person_id
and obsdatetime=obs_datetime
and voided=0
limit 1);
END;;
DELIMITER ;

-- ----------------------------
-- Function structure for getWhoStageBaseTxt
-- ----------------------------
DROP FUNCTION IF EXISTS `getWhoStageBaseTxt`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `getWhoStageBaseTxt`(`personid` integer, `artstartdt` date) RETURNS int(11)
    READS SQL DATA
BEGIN
#Routine body goes here...

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
END;;
DELIMITER ;

-- ----------------------------
-- Function structure for getWhoStageTxt
-- ----------------------------
DROP FUNCTION IF EXISTS `getWhoStageTxt`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `getWhoStageTxt`(`personid` integer, `obsdatetime` date) RETURNS int(11)
    READS SQL DATA
BEGIN
#Routine body goes here...

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
END;;
DELIMITER ;
