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

/* Cleanup of duplicated concepts that may have existing data - this script should be run before the migration begins */
UPDATE obs
SET value_coded = 121629
WHERE value_coded = 3; # ANEMIA
UPDATE obs
SET value_coded = 121375
WHERE value_coded = 5; # Asthma
UPDATE obs
SET value_coded = 16
WHERE value_coded = 142412; # Diarrhea
UPDATE obs
SET value_coded = 114100
WHERE value_coded = 43; # Pneumonia
UPDATE obs
SET value_coded = 114100
WHERE value_coded = 90127; # Pneumonia
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
UPDATE obs
SET value_coded = 90170
WHERE value_coded = 92; # Dapsone
UPDATE obs
SET value_coded = 143264
WHERE value_coded = 107; # cough
UPDATE obs
SET value_coded = 143264
WHERE value_coded = 90132; # cough
UPDATE obs
SET value_coded = 131113
WHERE value_coded = 114; # Otitis Media
UPDATE obs
SET value_coded = 119558
WHERE value_coded = 131; # Dental Caries
UPDATE obs
SET value_coded = 116543
WHERE value_coded = 135; # Burns
UPDATE obs
SET value_coded = 90100
WHERE value_coded = 151; # Abdominal Pain
UPDATE obs
SET value_coded = 135488
WHERE value_coded = 161; # LYMPHADENOPATHY
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
UPDATE obs
SET value_coded = 120939
WHERE value_coded = 204; # CANDIDIASIS
UPDATE obs
SET value_coded = 119537
WHERE value_coded = 207; # Depression
UPDATE obs
SET value_coded = 114262
WHERE value_coded = 210; # Peptic Ulcer
UPDATE obs
SET value_coded = 90115
WHERE value_coded = 215; # Jaundice
UPDATE obs
SET value_coded = 114431
WHERE value_coded = 218; # Otititis Externa
UPDATE obs
SET value_coded = 90101
WHERE value_coded = 219; # Psychosis
UPDATE obs
SET value_coded = 117889
WHERE value_coded = 197; #  GASTROENTERITIS
UPDATE obs
SET value_coded = 117152
WHERE value_coded = 363; # SCHISTOSOMIASIS
UPDATE obs
SET value_coded = 438
WHERE value_coded = 90188; #  STREPTOMYCIN
UPDATE obs
SET value_coded = 5135
WHERE value_coded = 497; # DECREASED SENSATION
UPDATE obs
SET value_coded = 113155
WHERE value_coded = 467; # SCHIZOPHRENIA
UPDATE obs
SET value_coded = 625
WHERE value_coded = 90174; # STAVUDINE
UPDATE obs
SET value_coded = 628
WHERE value_coded = 90173; # LAMIVUDINE
UPDATE obs
SET value_coded = 631
WHERE value_coded = 90177; # NEVIRAPINE
UPDATE obs
SET value_coded = 633
WHERE value_coded = 90178; # EFAVIRENZ
UPDATE obs
SET value_coded = 635
WHERE value_coded = 90179; # NELFINAVIR
UPDATE obs
SET value_coded = 656
WHERE value_coded = 90184; # ISONIAZID
UPDATE obs
SET value_coded = 745
WHERE value_coded = 90186; # ETHAMBUTOL
UPDATE obs
SET value_coded = 90181
WHERE value_coded = 795; # RITONAVIR
UPDATE obs
SET value_coded = 796
WHERE value_coded = 90175; # DIDANOSINE
UPDATE obs
SET value_coded = 797
WHERE value_coded = 90172; # ZIDOVUDINE
UPDATE obs
SET value_coded = 802
WHERE value_coded = 90183; #  TENOFOVIR
UPDATE obs
SET value_coded = 814
WHERE value_coded = 90176; # ABACAVIR
UPDATE obs
SET value_coded = 832
WHERE value_coded = 90135; # Weight Loss
UPDATE obs
SET value_coded = 836
WHERE value_coded = 117543; # Herpes Zoster
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
UPDATE obs
SET value_coded = 139084
WHERE value_coded = 620; # HEADACHE
UPDATE obs
SET value_coded = 973
WHERE value_coded = 90283; #  GRANDPARENT
UPDATE obs
SET value_coded = 90008
WHERE value_coded = 1056; # SEPARATED
UPDATE obs
SET value_coded = 90007
WHERE value_coded = 1058; # DIVORCED
UPDATE obs
SET value_coded = 90009
WHERE value_coded = 1059; # WIDOWED
UPDATE obs
SET value_coded = 99415
WHERE value_coded = 1367; # ON ART
UPDATE obs
SET value_coded = 99562
WHERE value_coded = 1499; #  Moderate
UPDATE obs
SET value_coded = 99561
WHERE value_coded = 1500; # Severe
UPDATE obs
SET value_coded = 99726
WHERE value_coded = 1734; #  years
UPDATE obs
SET value_coded = 90003
WHERE value_coded = 1065; # YES
UPDATE obs
SET value_coded = 90004
WHERE value_coded = 1066; # No
UPDATE obs
SET value_coded = 90001
WHERE value_coded = 1067; # Unknown

UPDATE obs SET value_coded = 5136 WHERE value_coded = 90128;  # DEMENTIA
UPDATE obs SET value_coded = 90109 WHERE value_coded = 5245; # PALLOR
UPDATE obs SET value_coded = 90087 WHERE value_coded = 5275; #  INTRAUTERINE DEVICE
UPDATE obs SET value_coded = 90106 WHERE value_coded = 5313; # MUSCLE TENDERNESS
UPDATE obs SET value_coded = 90006 WHERE value_coded = 5555; # MARRIED
UPDATE obs SET value_coded = 5829 WHERE value_coded = 90187 ; # PYRAZINAMIDE
UPDATE obs
SET value_coded = 141600
WHERE value_coded = 5960; # SHORTNESS OF BREATH
UPDATE obs
SET value_coded = 140238
WHERE value_coded = 5945; #  FEVER
UPDATE obs
SET value_coded = 140238
WHERE value_coded = 90103; #  FEVER
UPDATE obs
SET value_coded = 140238
WHERE value_coded = 90131; # FEVER
UPDATE obs
SET value_coded = 9091
WHERE value_coded = 5978; # NAUSEA
UPDATE obs
SET value_coded = 90136
WHERE value_coded = 5995; # URETHRAL DISCHARGE
UPDATE obs
SET value_coded = 90105
WHERE value_coded = 6006; # CONFUSION
UPDATE obs
SET value_coded = 118771
WHERE value_coded = 6020; # DYSURIA
UPDATE obs
SET value_coded = 90158
WHERE value_coded = 90049; #  POOR ADHERENCE
UPDATE obs
SET value_coded = 136443
WHERE value_coded = 90115; # JAUNDICE
UPDATE obs
SET value_coded = 119537
WHERE value_coded = 90154; # DEPRESSION
UPDATE obs
SET value_coded = 119537
WHERE value_coded = 90120; # DEPRESSION
UPDATE obs
SET value_coded = 374
WHERE value_coded = 90239; # FAMILY PLANNING STATUS
UPDATE obs
SET value_coded = 90258
WHERE value_coded = 90265; # ADDRESS
UPDATE obs
SET value_coded = 99416
WHERE value_coded = 99549; #  Facility Based
UPDATE obs
SET value_coded = 140501
WHERE value_coded = 5949; # FATIGUE
UPDATE obs
SET value_coded = 140501
WHERE value_coded = 90093; # FATIGUE
UPDATE obs
SET value_coded = 99475
WHERE value_coded = 99473; # Regular partner tested for HIV
UPDATE obs
SET value_coded = 99476
WHERE value_coded = 99474; # Casual partner tested for HIV

/*!40101 SET SQL_MODE = @OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS = @OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS = @OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT = @OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS = @OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION = @OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES = @OLD_SQL_NOTES */;