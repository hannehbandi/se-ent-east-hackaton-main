DROP TABLE IF EXISTS VehicleRatings;
CREATE TABLE VehicleRatings
(
  uuid STRING,
  VehiclePicture STRING,
  OverallRating STRING,
  OverallFrontCrashRating STRING,
  FrontCrashDriversideRating STRING,
  FrontCrashPassengersideRating STRING,
  FrontCrashPicture STRING,
  FrontCrashVideo STRING,
  OverallSideCrashRating STRING,
  SideCrashDriversideRating STRING,
  SideCrashPassengersideRating STRING,
  SideCrashPicture STRING,
  SideCrashVideo STRING,
  combinedSideBarrierAndPoleRatingFront STRING,
  combinedSideBarrierAndPoleRatingRear STRING,
  sideBarrierRatingOverall STRING,
  RolloverRating STRING,
  RolloverRating2 STRING,
  RolloverPossibility STRING,
  RolloverPossibility2 STRING,
  dynamicTipResult STRING,
  SidePoleCrashRating STRING,
  SidePolePicture STRING,
  SidePoleVideo STRING,
  NHTSAElectronicStabilityControl STRING,
  NHTSAForwardCollisionWarning STRING,
  NHTSALaneDepartureWarning STRING,
  ComplaintsCount STRING,
  RecallsCount STRING,
  InvestigationCount STRING,
  ModelYear STRING,
  Make STRING,
  Model STRING,
  VehicleDescription STRING,
  VehicleId STRING,
  PRIMARY KEY(uuid)
)
PARTITION BY HASH PARTITIONS 16
STORED AS KUDU;

DROP TABLE IF EXISTS VehicleComplaints;
CREATE TABLE VehicleComplaints
(
  odiNumber INT,
  manufacturer STRING,
  crash STRING,
  fire STRING,
  numberOfInjuries STRING,
  numberOfDeaths STRING,
  dateOfIncident STRING,
  dateComplaintFiled STRING,
  vin STRING,
  components STRING,
  summary STRING,
  products STRING,
  PRIMARY KEY(odiNumber)
)
PARTITION BY HASH PARTITIONS 16
STORED AS KUDU;

DROP TABLE IF EXISTS flat_tsbs;
CREATE TABLE flat_tsbs
(
  ID INT COMMENT 'NHTSA ITEM NUMBER',
  MODELTXT STRING COMMENT 'VEHICLE/EQUIPMENT MODEL',
  BULNO STRING COMMENT 'SERVICE BULLETIN NUMBER',
  BULREP STRING COMMENT 'REPLACEMENT SERVICE BULLETIN NUMBER',
  BULDTE STRING COMMENT 'DATE OF BULLETIN',
  COMPNAME STRING COMMENT 'CODE FOR FAILING COMPONENT',
  MAKETXT STRING COMMENT 'VEHICLE/EQUIPMENT MAKE',
  YEARTXT STRING COMMENT 'MODEL YEAR, 9999 IF UNKNOWN or N/A',
  DATEA STRING COMMENT 'DATE ADDED TO FILE',
  SUMMARY STRING COMMENT 'DESCRIPTION OF SUMMARY',
  PRIMARY KEY (ID, MODELTXT)
)
PARTITION BY HASH PARTITIONS 16
STORED AS KUDU;


DROP TABLE IF EXISTS flat_inv;
CREATE TABLE flat_inv
(
  NHTSA_ACTION_NUMBER STRING COMMENT 'NHTSA Identification Number',
  MODEL STRING COMMENT 'Vehicle/Equipment Model',
  YEAR STRING COMMENT 'Model Year, 9999 if Unknown or N/A',
  MAKE STRING COMMENT 'Vehicle/Equipment Make',
  COMPNAME STRING COMMENT 'Component Description',
  MFR_NAME STRING COMMENT 'Manufacturer Name',
  ODATE STRING COMMENT 'Date Opened (YYYYMMDD)',
  CDATE STRING COMMENT 'Date Closed (YYYYMMDD)',
  CAMPNO STRING COMMENT 'Recall Campaign Number, if applicable',
  SUBJECT STRING COMMENT 'Summary Description',
  SUMMARY STRING COMMENT 'Summary Detail',
  PRIMARY KEY (NHTSA_ACTION_NUMBER, MODEL, YEAR)
)
PARTITION BY HASH PARTITIONS 16
STORED AS KUDU;


DROP TABLE IF EXISTS flat_rcl;
CREATE TABLE flat_rcl
(
  RECORD_ID INT COMMENT 'RUNNING SEQUENCE NUMBER, WHICH UNIQUELY IDENTIFIES THE RECORD.',
  CAMPNO STRING COMMENT 'NHTSA CAMPAIGN NUMBER',
  MAKETEXT STRING COMMENT 'VEHICLE/EQUIPMENT MAKE',
  MODELTXT STRING COMMENT 'VEHICLE/EQUIPMENT MODEL',
  YEARTXT STRING COMMENT 'MODEL YEAR, 9999 IF UNKNOWN or N/A',
  MFGCAMPNO STRING COMMENT 'MFR CAMPAIGN NUMBER',
  COMPNAME STRING COMMENT 'COMPONENT DESCRIPTION',
  MFGNAME STRING COMMENT 'MANUFACTURER THAT FILED DEFECT/NONCOMPLIANCE REPORT',
  BGMAN STRING COMMENT 'BEGIN DATE OF MANUFACTURING',
  ENDMAN STRING COMMENT 'END DATE OF MANUFACTURING',
  RCLTYPECD STRING COMMENT 'VEHICLE, EQUIPMENT OR TIRE REPORT',
  POTAFF INT COMMENT 'POTENTIAL NUMBER OF UNITS AFFECTED ',
  ODATE STRING COMMENT 'DATE OWNER NOTIFIED BY MFR',
  INFLUENCED_BY STRING COMMENT 'RECALL INITIATOR (MFR/OVSC/ODI)',
  MFGTXT STRING COMMENT 'MANUFACTURERS OF RECALLED VEHICLES/PRODUCTS',
  RCDATE STRING COMMENT 'REPORT RECEIVED DATE',
  DATEA STRING COMMENT 'RECORD CREATION DATE',
  RPNO STRING COMMENT 'REGULATION PART NUMBER',
  FMVSS STRING COMMENT 'FEDERAL MOTOR VEHICLE SAFETY STANDARD NUMBER',
  DESC_DEFECT STRING COMMENT 'DEFECT SUMMARY',
  CONEQUENCE_DEFECT STRING COMMENT 'CONSEQUENCE SUMMARY',
  CORRECTIVE_ACTION STRING COMMENT 'CORRECTIVE SUMMARY',
  NOTES STRING COMMENT 'RECALL NOTES',
  RCL_CMPT_ID STRING COMMENT 'NUMBER THAT UNIQUELY IDENTIFIES A RECALLED COMPONENT.',
  MFR_COMP_NAME STRING COMMENT 'MANUFACTURER-SUPPLIED COMPONENT NAME',
  MFR_COMP_DESC STRING COMMENT 'MANUFACTURER-SUPPLIED COMPONENT DESCRIPTION',
  MFR_COMP_PTNO STRING COMMENT 'MANUFACTURER-SUPPLIED COMPONENT PART NUMBER',
  PRIMARY KEY (RECORD_ID)
)
PARTITION BY HASH PARTITIONS 16
STORED AS KUDU;

drop table if exists default.tm_events_raw;
-- Real-time telemetry events.
CREATE TABLE default.tm_events_raw (
  tm_event_id	BIGINT COMMENT 'Unique telemetry event ID',  
  driver_id	INT COMMENT 'Unique ID for an insured driver',
  trip_num BIGINT COMMENT 'Vehicle trip number',
  speed	INT COMMENT 'Speed (MPH)',  
  lat_accel FLOAT COMMENT 'Lateral acceleration (m/s^2)',
  long_accel FLOAT COMMENT 'Longitudinal acceleration (m/s^2)',
  throttle_pos FLOAT COMMENT 'Throttle position (%)',
  brake_press FLOAT COMMENT 'Brake pressure (bar)',
  steer_ang FLOAT COMMENT 'Steering angle (deg)',
  steer_ang_rate FLOAT COMMENT 'Steering angle rate (deg/s)',
  tm_event_dt STRING COMMENT 'Event datetime in format: MM-dd-yyyy hh:mm:ss a',
  ts_timestamp BIGINT COMMENT 'Randomized timestamp across timespan',
  primary key(tm_event_id)
)
PARTITION BY HASH PARTITIONS 16
STORED AS KUDU;

drop table if exists default.insured_drivers;
CREATE TABLE default.insured_drivers
(
  driver_id INT COMMENT 'Unique identifier for an insured driver',
  policy_number STRING COMMENT 'The 10-digit insurance policy number',
  first_name STRING COMMENT 'The first name of the insured driver',
  last_name STRING COMMENT 'The last name of the insured driver',
  vin STRING COMMENT 'The unique Vehicle Identification Number (VIN) for the insured vehicle',
  gender STRING COMMENT 'The gender of the driver',
  vehicle_make STRING COMMENT 'The make of the vehicle',
  vehicle_model STRING COMMENT 'The model of the vehicle',
  vehicle_year INT COMMENT 'The year of the vehicle',
  primary key (driver_id)
)
partition by hash partitions 16
stored as kudu;