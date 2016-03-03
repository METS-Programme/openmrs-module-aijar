/*!40101 SET @OLD_CHARACTER_SET_CLIENT = @@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS = @@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION = @@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE = @@TIME_ZONE */;
/*!40103 SET TIME_ZONE = '+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS = @@UNIQUE_CHECKS, UNIQUE_CHECKS = 0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS = @@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS = 0 */;
/*!40101 SET @OLD_SQL_MODE = @@SQL_MODE, SQL_MODE = 'NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES = @@SQL_NOTES, SQL_NOTES = 0 */;


/* For concept names with a voided_by = 1, set the voided value to 0. This is majority of the cleanup in the concept
dictionary
 */
UPDATE concept_name
SET voided = 1
WHERE voided_by IS NOT NULL;

/* Cleanup of duplicated concepts that may have existing data - this script should be run before the migration begins */
UPDATE obs
SET value_coded = 121629
WHERE value_coded = 3; # ANEMIA
UPDATE obs
SET value_coded = 121375
WHERE value_coded = 5; # Asthma
UPDATE obs
SET value_coded = 142412
WHERE value_coded = 16; # Diarrhea
UPDATE obs
SET value_coded = 114100
WHERE value_coded = 43; # Pneumonia
UPDATE obs
SET value_coded = 114100
WHERE value_coded = 90127; # Pneumonia
UPDATE concept_answer
SET answer_concept = 114100
WHERE answer_concept = 90127;
UPDATE obs
SET value_coded = 230
WHERE value_coded = 49; # Post partum Hemmorage
UPDATE obs
SET value_coded = 55
WHERE value_coded = 111633; # Urinary Tract Infection
UPDATE obs
SET value_coded = 134561
WHERE value_coded = 63; # Measles
UPDATE obs
SET value_coded = 924
WHERE value_coded = 87; # SULFADOXINE AND PYRIMETHAMINE
UPDATE obs
SET value_coded = 71617
WHERE value_coded = 88; #   Asprin
UPDATE obs
SET value_coded = 90170
WHERE value_coded = 91; # TRIMETHOPRIM
UPDATE concept_set
SET concept_id = 90170
WHERE concept_id = 91;
UPDATE obs
SET value_coded = 90170
WHERE value_coded = 92; # Dapsone
UPDATE concept_answer
SET answer_concept = 90170
WHERE answer_concept = 92;
UPDATE concept_set
SET concept_id = 90170
WHERE concept_id = 92;
UPDATE obs
SET value_coded = 143264
WHERE value_coded = 107; # cough
UPDATE concept_answer
SET answer_concept = 143264
WHERE answer_concept = 107;
UPDATE obs
SET value_coded = 143264
WHERE value_coded = 90132; # cough
UPDATE concept_answer
SET answer_concept = 143264
WHERE answer_concept = 90132;
UPDATE obs
SET value_coded = 131113
WHERE value_coded = 114; # Otitis Media
UPDATE concept_answer
SET answer_concept = 131113
WHERE answer_concept = 114;
UPDATE concept_set
SET concept_id = 131113
WHERE concept_id = 114;
UPDATE obs
SET value_coded = 119558
WHERE value_coded = 131; # Dental Caries
UPDATE concept_answer
SET answer_concept = 119558
WHERE answer_concept = 131;
UPDATE concept_set
SET concept_id = 119558
WHERE concept_id = 131;
UPDATE obs
SET value_coded = 116543
WHERE value_coded = 135; # Burns
UPDATE concept_set
SET concept_id = 116543
WHERE concept_id = 135;
UPDATE obs
SET value_coded = 90100
WHERE value_coded = 151; # Abdominal Pain
UPDATE concept_answer
SET answer_concept = 90100
WHERE answer_concept = 151;
UPDATE obs
SET value_coded = 135488
WHERE value_coded = 161; # LYMPHADENOPATHY
UPDATE concept_answer
SET answer_concept = 135488
WHERE answer_concept = 161;
UPDATE concept_set
SET concept_id = 135488
WHERE concept_id = 161;
UPDATE obs
SET value_coded = 110834
WHERE value_coded = 172; # Gastritis
UPDATE obs
SET value_coded = 112992
WHERE value_coded = 174; # No name
UPDATE obs
SET value_coded = 119481
WHERE value_coded = 175; # no name
UPDATE obs
SET value_coded = 90083
WHERE value_coded = 190; # condoms
UPDATE concept_answer
SET answer_concept = 90083
WHERE answer_concept = 190;
UPDATE obs
SET value_coded = 120939
WHERE value_coded = 204; # CANDIDIASIS
UPDATE concept_answer
SET answer_concept = 120939
WHERE answer_concept = 204;
UPDATE obs
SET value_coded = 119537
WHERE value_coded = 207; # Depression
UPDATE concept_answer
SET answer_concept = 119537
WHERE answer_concept = 207;
UPDATE concept_set
SET concept_id = 119537
WHERE concept_id = 207;
UPDATE obs
SET value_coded = 114262
WHERE value_coded = 210; # Peptic Ulcer
UPDATE obs
SET value_coded = 90115
WHERE value_coded = 215; # Jaundice
UPDATE concept_answer
SET answer_concept = 90115
WHERE answer_concept = 215;
UPDATE obs
SET value_coded = 114431
WHERE value_coded = 218; # Otititis Externa
UPDATE concept_set
SET concept_id = 114431
WHERE concept_id = 218;
UPDATE obs
SET value_coded = 90101
WHERE value_coded = 219; # Psychosis
UPDATE concept_set
SET concept_id = 90101
WHERE concept_id = 219;
UPDATE obs
SET value_coded = 117889
WHERE value_coded = 197; #  GASTROENTERITIS
UPDATE obs
SET value_coded = 117152
WHERE value_coded = 363; # SCHISTOSOMIASIS
UPDATE obs
SET value_coded = 438
WHERE value_coded = 90188; #  STREPTOMYCIN
UPDATE concept_answer
SET answer_concept = 438
WHERE answer_concept = 90188;
UPDATE obs
SET value_coded = 5135
WHERE value_coded = 497; # DECREASED SENSATION
UPDATE obs
SET value_coded = 113155
WHERE value_coded = 467; # SCHIZOPHRENIA
UPDATE obs
SET value_coded = 625
WHERE value_coded = 90174; # STAVUDINE
UPDATE concept_answer
SET answer_concept = 625
WHERE answer_concept = 90174;
UPDATE concept_set
SET concept_id = 625
WHERE concept_id = 90174;
UPDATE obs
SET value_coded = 628
WHERE value_coded = 90173; # LAMIVUDINE
UPDATE concept_answer
SET answer_concept = 628
WHERE answer_concept = 90173;
UPDATE concept_set
SET concept_id = 628
WHERE concept_id = 90173;
UPDATE obs
SET value_coded = 631
WHERE value_coded = 90177; # NEVIRAPINE
UPDATE concept_answer
SET answer_concept = 631
WHERE answer_concept = 90177;
UPDATE concept_set
SET concept_id = 631
WHERE concept_id = 90177;
UPDATE obs
SET value_coded = 633
WHERE value_coded = 90178; # EFAVIRENZ
UPDATE concept_answer
SET answer_concept = 633
WHERE answer_concept = 90178;
UPDATE concept_set
SET concept_id = 633
WHERE concept_id = 90178;
UPDATE obs
SET value_coded = 635
WHERE value_coded = 90179; # NELFINAVIR
UPDATE concept_answer
SET answer_concept = 635
WHERE answer_concept = 90179;
UPDATE concept_set
SET concept_id = 635
WHERE concept_id = 90179;
UPDATE obs
SET value_coded = 656
WHERE value_coded = 90184; # ISONIAZID
UPDATE concept_answer
SET answer_concept = 656
WHERE answer_concept = 90184;
UPDATE obs
SET value_coded = 745
WHERE value_coded = 90186; # ETHAMBUTOL
UPDATE concept_answer
SET answer_concept = 745
WHERE answer_concept = 90186;
UPDATE obs
SET value_coded = 90181
WHERE value_coded = 795; # RITONAVIR
UPDATE obs
SET value_coded = 796
WHERE value_coded = 90175; # DIDANOSINE
UPDATE concept_answer
SET answer_concept = 796
WHERE answer_concept = 90175;
UPDATE concept_set
SET concept_id = 796
WHERE concept_id = 90175;
UPDATE obs
SET value_coded = 797
WHERE value_coded = 90172; # ZIDOVUDINE
UPDATE concept_answer
SET answer_concept = 797
WHERE answer_concept = 90172;
UPDATE concept_set
SET concept_id = 797
WHERE concept_id = 90172;
UPDATE obs
SET value_coded = 802
WHERE value_coded = 90183; #  TENOFOVIR
UPDATE concept_answer
SET answer_concept = 802
WHERE answer_concept = 90183;
UPDATE concept_set
SET concept_id = 802
WHERE concept_id = 90183;
UPDATE obs
SET value_coded = 814
WHERE value_coded = 90176; # ABACAVIR
UPDATE concept_answer
SET answer_concept = 814
WHERE answer_concept = 90176;
UPDATE concept_set
SET concept_id = 814
WHERE concept_id = 90176;
UPDATE obs
SET value_coded = 832
WHERE value_coded = 90135; # Weight Loss
UPDATE concept_answer
SET answer_concept = 832
WHERE answer_concept = 90135;
UPDATE obs
SET value_coded = 836
WHERE value_coded = 117543; # Herpes Zoster
UPDATE concept_set
SET concept_id = 836
WHERE concept_id = 117543;
UPDATE obs
SET value_coded = 90114
WHERE value_coded = 867; # INSOMNIA
UPDATE obs
SET value_coded = 90117
WHERE value_coded = 877; # DIZZINESS
UPDATE obs
SET value_coded = 118789
WHERE value_coded = 881; # Dysphagia
UPDATE obs
SET value_coded = 116344
WHERE value_coded = 890; #  Leprosy
UPDATE obs
SET value_coded = 117767
WHERE value_coded = 893; #  Gonorrhea
UPDATE obs
SET value_coded = 127990
WHERE value_coded = 901; # Fever of Unknown origin
UPDATE obs
SET value_coded = 90137
WHERE value_coded = 902; # PELVIC INFLAMMATORY DISEASE
UPDATE obs
SET value_coded = 117399
WHERE value_coded = 903; # Hypertension
UPDATE obs
SET value_coded = 512
WHERE value_coded = 5950; # RASH - retired concept that is to be deleted
UPDATE obs
SET value_coded = 512
WHERE value_coded = 5180; # RASH - retured concept that is to be deleted
UPDATE obs
SET value_coded = 512
WHERE value_coded = 90098; # RASH
UPDATE concept_answer
SET concept_id = 512
WHERE concept_id = 90098;
UPDATE concept_answer
SET answer_concept = 512
WHERE answer_concept = 90098;
UPDATE obs
SET value_coded = 139084
WHERE value_coded = 620; # HEADACHE
UPDATE concept_answer
SET answer_concept = 139084
WHERE answer_concept = 620;
UPDATE obs
SET value_coded = 973
WHERE value_coded = 90283; #  GRANDPARENT
UPDATE concept_answer
SET answer_concept = 973
WHERE answer_concept = 90283;
UPDATE obs
SET value_coded = 90008
WHERE value_coded = 1056; # SEPARATED
UPDATE concept_answer
SET answer_concept = 90008
WHERE answer_concept = 1056;
UPDATE obs
SET value_coded = 90007
WHERE value_coded = 1058; # DIVORCED
UPDATE concept_answer
SET answer_concept = 90007
WHERE answer_concept = 1058;
UPDATE obs
SET value_coded = 90009
WHERE value_coded = 1059; # WIDOWED
UPDATE concept_answer
SET answer_concept = 90009
WHERE answer_concept = 1059;
UPDATE obs
SET value_coded = 99415
WHERE value_coded = 1367; # ON ART
UPDATE concept_answer
SET answer_concept = 99415
WHERE answer_concept = 1367;
UPDATE obs
SET value_coded = 99562
WHERE value_coded = 1499; #  Moderate
UPDATE concept_answer
SET answer_concept = 99562
WHERE answer_concept = 1499;
UPDATE concept_set
SET concept_id = 99562
WHERE concept_id = 1499;
UPDATE obs
SET value_coded = 99561
WHERE value_coded = 1500; # Severe
UPDATE concept_answer
SET answer_concept = 99561
WHERE answer_concept = 1500;
UPDATE concept_set
SET concept_id = 99561
WHERE concept_id = 1500;
UPDATE obs
SET value_coded = 99726
WHERE value_coded = 1734; #  years
UPDATE concept_answer
SET answer_concept = 99726
WHERE answer_concept = 1734;
UPDATE concept_set
SET concept_id = 99726
WHERE concept_id = 1734;
UPDATE obs
SET value_coded = 90003
WHERE value_coded = 1065; # YES
UPDATE concept_answer
SET answer_concept = 90003
WHERE answer_concept = 1065;
UPDATE obs
SET value_coded = 90004
WHERE value_coded = 1066; # No
UPDATE concept_answer
SET answer_concept = 90004
WHERE answer_concept = 1066;
UPDATE obs
SET value_coded = 90001
WHERE value_coded = 1067; # Unknown
UPDATE concept_answer
SET answer_concept = 90001
WHERE answer_concept = 1067;

UPDATE obs SET value_coded = 5136 WHERE value_coded = 90128;  # DEMENTIA
UPDATE concept_answer
SET answer_concept = 5136
WHERE answer_concept = 90128;
UPDATE obs SET value_coded = 90109 WHERE value_coded = 5245; # PALLOR
UPDATE concept_answer
SET answer_concept = 90109
WHERE answer_concept = 5245;
UPDATE obs SET value_coded = 90087 WHERE value_coded = 5275; #  INTRAUTERINE DEVICE
UPDATE concept_answer
SET answer_concept = 90087
WHERE answer_concept = 5275;
UPDATE obs SET value_coded = 90106 WHERE value_coded = 5313; # MUSCLE TENDERNESS
UPDATE concept_answer
SET answer_concept = 90106
WHERE answer_concept = 5313;
UPDATE obs SET value_coded = 90006 WHERE value_coded = 5555; # MARRIED
UPDATE concept_answer
SET answer_concept = 90006
WHERE answer_concept = 5555;
UPDATE obs SET value_coded = 5829 WHERE value_coded = 90187 ; # PYRAZINAMIDE
UPDATE concept_answer
SET answer_concept = 5829
WHERE answer_concept = 90187;
UPDATE obs
SET value_coded = 141600
WHERE value_coded = 5960; # SHORTNESS OF BREATH
UPDATE obs
SET value_coded = 140238
WHERE value_coded = 5945; #  FEVER
UPDATE obs
SET value_coded = 140238
WHERE value_coded = 90103; #  FEVER
UPDATE concept_answer
SET concept_id = 140238
WHERE concept_id = 90103;
UPDATE concept_answer
SET answer_concept = 140238
WHERE answer_concept = 90103;
UPDATE obs
SET value_coded = 140238
WHERE value_coded = 90131; # FEVER
UPDATE concept_answer
SET answer_concept = 140238
WHERE answer_concept = 90131;
UPDATE obs
SET value_coded = 9091
WHERE value_coded = 5978; # NAUSEA
UPDATE concept_answer
SET answer_concept = 9091
WHERE answer_concept = 5978;
UPDATE obs
SET value_coded = 90136
WHERE value_coded = 5995; # URETHRAL DISCHARGE
UPDATE concept_answer
SET answer_concept = 90136
WHERE answer_concept = 5995;
UPDATE obs
SET value_coded = 90105
WHERE value_coded = 6006; # CONFUSION
UPDATE concept_answer
SET answer_concept = 90105
WHERE answer_concept = 6006;
UPDATE obs
SET value_coded = 118771
WHERE value_coded = 6020; # DYSURIA
UPDATE concept_answer
SET answer_concept = 118771
WHERE answer_concept = 6020;
UPDATE obs
SET value_coded = 90158
WHERE value_coded = 90049; #  POOR ADHERENCE
UPDATE concept_answer
SET answer_concept = 90158
WHERE answer_concept = 90049;
UPDATE obs
SET value_coded = 136443
WHERE value_coded = 90115; # JAUNDICE
UPDATE concept_answer
SET concept_id = 136443
WHERE concept_id = 90115;
UPDATE concept_answer
SET answer_concept = 136443
WHERE answer_concept = 90115;

UPDATE obs
SET value_coded = 119537
WHERE value_coded = 90154; # DEPRESSION
UPDATE concept_answer
SET answer_concept = 119537
WHERE answer_concept = 90154;
UPDATE obs
SET value_coded = 119537
WHERE value_coded = 90120; # DEPRESSION
UPDATE concept_answer
SET concept_id = 119537
WHERE concept_id = 90120;
UPDATE concept_answer
SET answer_concept = 119537
WHERE answer_concept = 90120;

UPDATE obs
SET value_coded = 374
WHERE value_coded = 90239; # FAMILY PLANNING STATUS
UPDATE concept_answer
SET concept_id = 374
WHERE concept_id = 90239;
UPDATE concept_answer
SET answer_concept = 374
WHERE answer_concept = 90239;
UPDATE obs
SET value_coded = 90258
WHERE value_coded = 90265; # ADDRESS
UPDATE obs
SET value_coded = 99416
WHERE value_coded = 99549; #  Facility Based
UPDATE obs
SET value_coded = 140501
WHERE value_coded = 5949; # FATIGUE
UPDATE concept_answer
SET answer_concept = 140501
WHERE answer_concept = 5949;
UPDATE obs
SET value_coded = 140501
WHERE value_coded = 90093; # FATIGUE
UPDATE concept_answer
SET concept_id = 140501
WHERE concept_id = 90093;
UPDATE concept_answer
SET answer_concept = 140501
WHERE answer_concept = 90093;
UPDATE obs
SET value_coded = 99475
WHERE value_coded = 99473; # Regular partner tested for HIV
UPDATE obs
SET value_coded = 99476
WHERE value_coded = 99474; # Casual partner tested for HIV
UPDATE obs
SET value_coded = 90045
WHERE value_coded = 99890; # ARV stop - Drug Stock out
UPDATE obs
SET value_coded = 90158
WHERE value_coded = 90049; # Poor adherence
UPDATE obs
SET value_coded = 90051
WHERE value_coded = 99891; # Patient lacks financial resources
UPDATE obs
SET value_coded = 90052
WHERE value_coded = 99892; # Patient decision

# Malaria concepts to be retired
UPDATE obs
SET value_coded = 116128
WHERE value_coded = 123;
UPDATE obs
SET value_coded = 116128
WHERE value_coded = 906;

/* Delete orphaned concept names */
DELETE FROM concept_name_tag_map
WHERE concept_name_id IN (
  SELECT concept_name_id
  FROM concept_name
  WHERE concept_id IN (
    49 # POSTPARTUM HEMORRHAGE
    , 57 #YELLOW JACK
    , 90188 # STREPTOMYCIN
    , 497 # decreased sensation
    , 5950 # RASH
    , 90098 # RASH
    , 90174 #STAVUDINE
    , 90173 #LAMIVUDINE
    , 90177 # NEVIRAPINE
    , 90178 # EFAVIRENZ
    , 90179 #NELFINAVIR
    , 90184 #ISONIAZID
    , 90186 # ETHAMBUTOL
    , 90175 # DIDANOSINE
    , 90172 # ZIDOVUDINE
    , 90183 # TENOFOVIR
    , 90176 # ABACAVIR
    , 90135 # WEIGHT LOSS
    , 971 # No name description family member
    , 87 # FANSIDAR
    , 90283 # GRANDPARENT
    , 90128 # DEMENTIA
    , 90187 # PYRAZINAMIDE
    , 90103 # FEVER
    , 1067 # UNKNOWN
    , 1065 # YES
    , 1066 # NO
    , 5555 # MARRIED
    , 1058 # DIVORCED
    , 1056 # SEPARATED
    , 1059 # WIDOWED
    , 190 # CONDOMS
    , 5275 # IUD
    , 5978 # NAUSEA
    , 620 # HEADACHE
    , 3 # ANEMIA
    , 151 # ABDOMINAL PAIN
    , 219 # PSYCHOSIS
    , 6006 # CONFUSION
    , 5313 # MUSCLE TENDERNESS
    , 5245 # PALLOR
    , 867 # INSOMNIA
    , 877 # DIZZINESS
    , 5995 # URETHRAL DISCHARGE
    , 902 # PELVIC INFLAMMATORY DISEASE
    , 90049 # POOR ADHERENCE
    , 91 # TRIMETHOPRIM
    , 92 # DAPSONE
    , 795 # RITONAVIR
    , 90239 # FAMILY PLANNING STATUS
    , 90265 # ADDRESS
    , 99569 # CHILD
    , 99464 # HIV TEST
    , 99350 # Condition of Breast of Mother
    , 1367 # ON ART
    , 99473 # Regular Partner tested for HIV
    , 99474 # Casual Partner tested for HIV
    , 90128 # DEMENTIA
    , 90131 # FEVER
    , 6039 # HEADACHE
    , 88 # ASPRIN
    , 172 # GASTRITIS
    , 467 # SCHIZOPRENIA
    , 43 # PNEUMONIA
    , 210 # PEPTIC ULCER
    , 218 # OTITIS EXTERNA
    , 890 # LEPROSY
    , 123 # MALARIA
    , 906 # MALARIA
    , 5945 # FEVER
    , 5960 # SHORTNESS OF BREATH
    , 90094 # HEADACHE

  )
);

DELETE FROM concept_name_tag_map
WHERE concept_name_id IN (
  SELECT concept_name_id
  FROM concept_name
  WHERE concept_id IN (
    991 # DEHYDRATION
    , 992 # TINEA VERSICOLOR
  ) AND concept_name.concept_name_type IS NULL
);


/* Delete orphaned concept names */
DELETE FROM concept_name
WHERE concept_id IN (
  49 # POSTPARTUM HEMORRHAGE
  , 57 #YELLOW JACK
  , 90188 # STREPTOMYCIN
  , 497 #decreased sensation
  , 5950 # RASH
  , 90098 # RASH
  , 90174 #STAVUDINE
  , 90173 #LAMIVUDINE
  , 90177 # NEVIRAPINE
  , 90178 # EFAVIRENZ
  , 90179 #NELFINAVIR
  , 90184 #ISONIAZID
  , 90186 # ETHAMBUTOL
  , 90175 # DIDANOSINE
  , 90172 # ZIDOVUDINE
  , 90183 # TENOFOVIR
  , 90176 # ABACAVIR
  , 90135 # WEIGHT LOSS
  , 971 # No name description family member
  , 87 # FANSIDAR
  , 90283 # GRANDPARENT
  , 90187 # PYRAZINAMIDE
  , 90103 # FEVER
  , 1067 # UNKNOWN
  , 1065 # YES
  , 1066 # NO
  , 5555 # MARRIED
  , 1058 # DIVORCED
  , 1056 # SEPARATED
  , 1059 # WIDOWED
  , 190 # CONDOMS
  , 5275 # IUD
  , 5978 # NAUSEA
  , 620 # HEADACHE
  , 3 # ANEMIA
  , 151 # ABDOMINAL PAIN
  , 219 # PSYCHOSIS
  , 6006 # CONFUSION
  , 5313 # MUSCLE TENDERNESS
  , 5245 # PALLOR
  , 867 # INSOMNIA
  , 877 # DIZZINESS
  , 5995 # URETHRAL DISCHARGE
  , 902 # PELVIC INFLAMMATORY DISEASE
  , 90049 # POOR ADHERENCE
  , 91 # TRIMETHOPRIM
  , 92 # DAPSONE
  , 795 # RITONAVIR
  , 90239 # FAMILY PLANNING STATUS
  , 90265 # ADDRESS
  , 99569 # CHILD
  , 99464 # HIV TEST
  , 99350 # Condition of Breast of Mother
  , 1367 # ON ART
  , 99473 # Regular Partner tested for HIV
  , 99474 # Casual Partner tested for HIV
  , 90128 # DEMENTIA
  , 90131 # FEVER
  , 6039 # HEADACHE
  , 88 # ASPRIN
  , 172 # GASTRITIS
  , 467 # SCHIZOPRENIA
  , 43 # PNEUMONIA
  , 210 # PEPTIC ULCER
  , 218 # OTITIS EXTERNA
  , 890 # LEPROSY
  , 123 # MALARIA
  , 906 # MALARIA
  , 5945 # FEVER
  , 5960 # SHORTNESS OF BREATH
  , 90094 # HEADACHE
);

# duplicated syonyms in concept name table
DELETE FROM concept_name
WHERE concept_id IN (
  991 # DEHYDRATION
  , 992 # TINEA VERSICOLOR
) AND concept_name.concept_name_type IS NULL;

/* Delete concept answers
 */

DELETE FROM concept_answer
WHERE concept_id IN (
  971 # No name description family member
  , 1147
  , 99350
);

DELETE FROM concept_answer
WHERE answer_concept IN (
  1137, 1138, 871, 971, 972, 1139, 1140, 99569
);


/* Delete orphaned concept descriptions
 */

DELETE FROM concept_description
WHERE concept_id IN (
  159 # patient died
  , 49 # Post partum Hemorrage
  , 497 #decreased sensation
  , 971 # No name description family member
  , 57 # yellow fever
  , 90094
);

/* Delete orphaned concept set items */
DELETE FROM concept_set
WHERE concept_id IN (126, 99101);


/* Delete duplicated concepts to ensure that the dictionary is clean after moving the data */
DELETE FROM concept
WHERE uuid IN (
  'dc53ff54-30ab-102d-86b0-7a5022ba4115', 'dc540e3c-30ab-102d-86b0-7a5022ba4115', 'dc54722c-30ab-102d-86b0-7a5022ba4115', 'dc54f5de-30ab-102d-86b0-7a5022ba4115', 'dc650021-30ab-102d-86b0-7a5022ba4115', '111633AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA', 'dc6540eb-30ab-102d-86b0-7a5022ba4115', 'dc65b33d-30ab-102d-86b0-7a5022ba4115', 'dc65b77f-30ab-102d-86b0-7a5022ba4115', 'dc65c3dc-30ab-102d-86b0-7a5022ba4115', 'dc68ce3b-30ab-102d-86b0-7a5022ba4115', 'dc68d771-30ab-102d-86b0-7a5022ba4115', 'dc68dbcb-30ab-102d-86b0-7a5022ba4115', 'dc6986c6-30ab-102d-86b0-7a5022ba4115', 'dc669506-30ab-102d-86b0-7a5022ba4115', 'dc66f0dd-30ab-102d-86b0-7a5022ba4115', 'dc674700-30ab-102d-86b0-7a5022ba4115', 'dc694cdf-30ab-102d-86b0-7a5022ba4115', 'dc69c9fa-30ab-102d-86b0-7a5022ba4115', 'dc6a94d2-30ab-102d-86b0-7a5022ba4115', 'dc75e0b5-30ab-102d-86b0-7a5022ba4115', 'dc75e0b5-30ab-102d-86b0-7a5022ba4115', 'dc7c7b83-30ab-102d-86b0-7a5022ba4115', 'dc7e4c16-30ab-102d-86b0-7a5022ba4115', 'dc887354-30ab-102d-86b0-7a5022ba4115', 'dc8dbdc2-30ab-102d-86b0-7a5022ba4115', 'dc8dcd46-30ab-102d-86b0-7a5022ba4115', 'dc8dd1a1-30ab-102d-86b0-7a5022ba4115', 'dc8df0fe-30ab-102d-86b0-7a5022ba4115', 'dc8e0717-30ab-102d-86b0-7a5022ba4115', 'dc8e2e85-30ab-102d-86b0-7a5022ba4115', 'dc8e66aa-30ab-102d-86b0-7a5022ba4115', 'dc8ef120-30ab-102d-86b0-7a5022ba4115', 'dc8f1afc-30ab-102d-86b0-7a5022ba4115', 'dc8f22f9-30ab-102d-86b0-7a5022ba4115', 'dcd51912-30ab-102d-86b0-7a5022ba4115', 'dccf54ae-30ab-102d-86b0-7a5022ba4115', 'dc913621-30ab-102d-86b0-7a5022ba4115', 'dc96bdbf-30ab-102d-86b0-7a5022ba4115', 'dc96c695-30ab-102d-86b0-7a5022ba4115', 'dc98e48b-30ab-102d-86b0-7a5022ba4115', 'dc98e8b3-30ab-102d-86b0-7a5022ba4115', 'dc98f86a-30ab-102d-86b0-7a5022ba4115', 'dc9957ef-30ab-102d-86b0-7a5022ba4115', 'dc998884-30ab-102d-86b0-7a5022ba4115', 'dcddc259-30ab-102d-86b0-7a5022ba4115', 'dc98f439-30ab-102d-86b0-7a5022ba4115', 'dc98f86a-30ab-102d-86b0-7a5022ba4115', '72681AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA', '71279025-e01f-43d5-94d5-a01d8ee687f6', 'dd28108c-30ab-102d-86b0-7a5022ba4115', 'd6522d62-093d-4157-a9d3-9359d1a33480', '9a8059f5-3fa8-48f0-9efb-78a090639c8e', 'd858f8cb-fe9e-4131-8d91-cd9929cc53de', '7684f1d3-c050-4b00-85d6-00395469fae6', '2ba50eaf-fadc-49de-a45c-f76bc3d81ac9', '2b142c8e-dd16-4afd-bd2b-f7f1ffc257eb', '8a0b28f1-c0b2-49fb-b53a-a17fa53f3b83', 'dcde6fa4-30ab-102d-86b0-7a5022ba4115', 'dc69ab8d-30ab-102d-86b0-7a5022ba4115', 'dc66e361-30ab-102d-86b0-7a5022ba4115', 'dcd48a93-30ab-102d-86b0-7a5022ba4115', 'dc6979b9-30ab-102d-86b0-7a5022ba4115', 'dcdf0a67-30ab-102d-86b0-7a5022ba4115', 'dcde4653-30ab-102d-86b0-7a5022ba4115', 'dc66a9b1-30ab-102d-86b0-7a5022ba4115', 'dc696af0-30ab-102d-86b0-7a5022ba4115', 'dc6656e9-30ab-102d-86b0-7a5022ba4115', 'dc689047-30ab-102d-86b0-7a5022ba4115', 'dcde2a26-30ab-102d-86b0-7a5022ba4115', 'dc7fdcd0-30ab-102d-86b0-7a5022ba4115', 'dcde88c8-30ab-102d-86b0-7a5022ba4115', 'dcddd7bf-30ab-102d-86b0-7a5022ba4115', 'dccf483e-30ab-102d-86b0-7a5022ba4115', 'dcddab4c-30ab-102d-86b0-7a5022ba4115', 'dc6625ec-30ab-102d-86b0-7a5022ba4115', 'dcde8cfc-30ab-102d-86b0-7a5022ba4115', 'dce0aa79-30ab-102d-86b0-7a5022ba4115', 'dcdfa74e-30ab-102d-86b0-7a5022ba4115', 'dcde75ed-30ab-102d-86b0-7a5022ba4115', 'dcdfa331-30ab-102d-86b0-7a5022ba4115', 'dcdf6b70-30ab-102d-86b0-7a5022ba4115', 'dcdf60ab-30ab-102d-86b0-7a5022ba4115', 'dcdf7811-30ab-102d-86b0-7a5022ba4115', 'dcdf7c2b-30ab-102d-86b0-7a5022ba4115', 'dcdf8048-30ab-102d-86b0-7a5022ba4115', 'dcdf9709-30ab-102d-86b0-7a5022ba4115', 'dcdf9f38-30ab-102d-86b0-7a5022ba4115', 'dcdf6fc6-30ab-102d-86b0-7a5022ba4115', 'dcdf5a7e-30ab-102d-86b0-7a5022ba4115', 'dcdf92d6-30ab-102d-86b0-7a5022ba4115', 'dcdf73eb-30ab-102d-86b0-7a5022ba4115', 'dcde9e0d-30ab-102d-86b0-7a5022ba4115', '117543AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA', '1067AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA', '1065AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA', '1066AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA', 'dcbe1f9e-30ab-102d-86b0-7a5022ba4115', 'dc96d878-30ab-102d-86b0-7a5022ba4115', 'dc96cada-30ab-102d-86b0-7a5022ba4115', 'dc96dcbf-30ab-102d-86b0-7a5022ba4115', 'dc692ad3-30ab-102d-86b0-7a5022ba4115', 'dcb2f595-30ab-102d-86b0-7a5022ba4115', 'dccff72c-30ab-102d-86b0-7a5022ba4115', 'dc685df9-30ab-102d-86b0-7a5022ba4115', 'dc69b49c-30ab-102d-86b0-7a5022ba4115', 'dcd446b5-30ab-102d-86b0-7a5022ba4115', 'dcb574a9-30ab-102d-86b0-7a5022ba4115', 'dcb24c93-30ab-102d-86b0-7a5022ba4115', 'dc699c43-30ab-102d-86b0-7a5022ba4115', 'dcd041e4-30ab-102d-86b0-7a5022ba4115', 'dcda7b99-30ab-102d-86b0-7a5022ba4115', 'dc65c7d5-30ab-102d-86b0-7a5022ba4115', 'dce122f3-30ab-102d-86b0-7a5022ba4115', 'dd1e1d59-30ab-102d-86b0-7a5022ba4115', 'dca2817c-30ab-102d-86b0-7a5022ba4115', '83cb0c17-b44c-4ae5-aa6a-988b846200f3', 'dbfb1471-dfb4-44aa-a653-9403a506a29d', '9f7d91ca-a9f6-47eb-b974-27ec16a75dd3', '1500AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA', '1499AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA', '1734AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA',
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         'dccf3652-30ab-102d-86b0-7a5022ba4115', 'dccfa115-30ab-102d-86b0-7a5022ba4115',
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         'dc6521a2-30ab-102d-86b0-7a5022ba4115' #yellow jack
  , 'dc68854d-30ab-102d-86b0-7a5022ba4115' #patient died
  , 'dc7d35f4-30ab-102d-86b0-7a5022ba4115' # Decreased sensation
  , 'dc91252b-30ab-102d-86b0-7a5022ba4115' # No name description family member
  , 'dc668353-30ab-102d-86b0-7a5022ba4115', 'dc8f927e-30ab-102d-86b0-7a5022ba4115' # MALARIA
  , 'dcddaf94-30ab-102d-86b0-7a5022ba4115'
);

/** Updates to missing fully qualified concept names */
UPDATE concept_name
SET concept_name_type = 'FULLY_SPECIFIED'
WHERE concept_id IN (
  176 #Assault nos
  , 492 # SNAKE ANTI-VENOM
  , 923 # ZANTAC
  , 1050 # 30-60 MIN
  , 1141 #NASCOP
  , 1290 # ROOF
  , 1291 # TIN
  , 1370 # REGIMEN UPDATE
);


UPDATE concept_name
SET concept_name_type = 'FULLY_SPECIFIED'
WHERE concept_id = 880 AND `name` = 'ALLERGIC RHINITIS';

UPDATE concept_name
SET concept_name_type = 'FULLY_SPECIFIED'
WHERE concept_id = 937 AND `name` = 'FUNGAL SKIN INFECTION';

UPDATE concept_name
SET concept_name_type = 'FULLY_SPECIFIED'
WHERE concept_id = 1051 AND `name` = '1-2 HR';

UPDATE concept_name
SET concept_name_type = 'FULLY_SPECIFIED'
WHERE concept_id = 1052 AND `name` = '>2 HR';

UPDATE concept_name
SET concept_name_type = 'FULLY_SPECIFIED'
WHERE concept_id = 1136 AND `name` = 'PLEURAL EFFUSION';

UPDATE concept_name
SET concept_name_type = 'FULLY_SPECIFIED'
WHERE concept_id = 1148 AND `name` = 'TOTAL PMTCT';

UPDATE concept_name
SET concept_name_type = 'FULLY_SPECIFIED'
WHERE concept_id = 1172 AND `name` = 'BREECH PRESENTATION';

UPDATE concept_name
SET concept_name_type = 'FULLY_SPECIFIED'
WHERE concept_id = 1305 AND `name` = 'VIRAL LOAD - QUAL';

# Unvoid concept names in the English locale
UPDATE concept_name
SET voided = NULL, voided_by = NULL, date_voided = NULL
WHERE concept_id IN (
  1490 # Physical Injury
  , 1498 # Mild
  , 1513 # Tablets
  , 1514 # Packets
  , 1518 # Suppository
  , 1608 # Capsule
  , 1732 # Units of Duration
  , 1733 # Minutes
  , 1822 # Hours
  , 71617 # Asprin
  , 72609 # Vivarin
  , 73667 # Codeine
  , 77413 # Heparin
  , 77414 # HEPARIN SODIUM
  , 77419 # HEPARINOIDS
  , 80106 # Morphine
  , 84462 #SULFADOXINE
  , 99131 # PMTCT REGIMEN
  , 104811 # HEPARINOIDS / HYALURONIDASE
  , 104813 # HEPARINOIDS / SALICYLIC ACID
  , 105232 # PYRIMETHAMINE / SULFADOXINE
  , 110834 # Gastritis
  , 111061 # Hives
  , 111636 # Urinary incontinence
  , 112198 # Trichiasis of eyelid
  , 112287 # Trachoma
  , 112561 # Superficial head injury
  , 112989 # Shock
  , 112992 # Sexually transmitted disease
  , 113087 # Secondary hypertension
  , 113155 # Schizophrenia
  , 113230 # Rheumatic fever without heart involvement
  , 113279 # Retained placenta or membranes, without Hemorrhage
  , 113926 # Post-traumatic stress disorder
  , 114100 # Pneumonia
  , 114174 # Phlebitis and thrombophlebitis
  , 114262 # Peptic ulcer disease
  , 114431 # Otitis externa
  , 115491 # Other Noninfectious Disorders of Lymphatic Channels
  , 115491 # Multiple gestation
  , 115797 # Metabolic disorder
  , 115835 # MENINGITIS

  , 116214 # Hypotension
  , 116344 # LEPROSY
  , 116376 # Late Effects of Cerebrovascular Disease
  , 116474 # Kwashiorkor
  , 116543 # burn
  , 116700 # Intestinal helminthiasis, other
  , 117146 # Trichomoniasis
  , 117152 # SCHISTOSOMIASIS
  , 117315 # Hypovolaemia
  , 117386 # Hypertensive heart disease
  , 117399 # concept_id = 117399
  , 117617 # Hemorrhage in early pregnancy,
  , 117767 # Gonorrhea
  , 117829 # Genital herpes
  , 117889 # gastroenteritis
  , 118652 # Encephalocele
  , 118771 # Dysuria
  , 118773 # Dystonia
  , 118789 # Dysphagia
  , 119027 # Disease of bone and joint
  , 119112 # Disorder of Nervous System
  , 110598 # Acute pain
  , 113228 # Rheumatic fever without heart involvement
  , 113881 # Traumatic neurosis
  , 115191 # Other Noninfectious Disorders of Lymphatic Channels
  , 116128 # MALARIA


) AND locale = 'en';

/* Bulk unvoiding of concept names for entities without concept names */
DROP TABLE IF EXISTS concept_for_unvoid;

/* create a table with concepts that are to be unvoided */
CREATE TABLE concept_for_unvoid (
  concept_id INT NOT NULL
)
  SELECT concept_id
  FROM concept_name
  WHERE locale = 'en' AND voided_by IS NOT NULL AND voided = 1 AND concept_id NOT IN (SELECT concept_id
                                                                                      FROM concept_name
                                                                                      WHERE
                                                                                        locale = 'en' AND voided_by IS NULL
                                                                                        AND voided = 0
                                                                                      GROUP BY concept_id
                                                                                      HAVING count(name) > 0);

UPDATE concept_name
SET voided = NULL, voided_by = NULL, date_voided = NULL
WHERE locale = 'en' AND concept_id IN (
  SELECT concept_id
  FROM concept_for_unvoid
);

DROP TABLE concept_for_unvoid;

/* Delete duplicated concept with missing concepts */
DELETE FROM concept_set
WHERE uuid IN ('425AEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE',
               '1834AEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE',
               '1832AEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE',
               '1984AEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE');

/* Add missing concept names */
INSERT INTO openmrs.concept_name (concept_id, name, locale, locale_preferred, voided, creator, date_created, concept_name_type, voided_by, date_voided, void_reason, uuid)
VALUES
  (1173, 'EXPRESSED BREASTMILK', 'en', 1, 0, 2, '2016-03-01 09:17:40', 'FULLY_SPECIFIED', NULL, NULL, NULL,
   '8eaa7a27-1e9d-4f51-aa16-f7deff791142');

INSERT INTO concept_name_tag_map (concept_name_id, concept_name_tag_id)
  SELECT
    concept_name_id,
    4
  FROM concept_name
  WHERE concept_name.uuid IN (
    '8eaa7a27-1e9d-4f51-aa16-f7deff791142'
  );

# cleanup any concept names, concept name tags, answers and sets after the concept removal
DELETE FROM concept_name_tag_map
WHERE concept_name_id IN (
  SELECT concept_name_id
  FROM concept_name
  WHERE concept_id NOT IN (SELECT concept_id
                           FROM concept));

/* Mass delete of concept names without concepts */
DELETE FROM concept_name
WHERE concept_id NOT IN (SELECT concept_id
                         FROM concept);

/* Delete orphaned concept answers
 */

DELETE FROM concept_answer
WHERE concept_id NOT IN (SELECT concept_id
                         FROM concept);

DELETE FROM concept_answer
WHERE answer_concept NOT IN (SELECT concept_id
                             FROM concept);

/*!40101 SET SQL_MODE = @OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS = @OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS = @OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT = @OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS = @OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION = @OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES = @OLD_SQL_NOTES */;