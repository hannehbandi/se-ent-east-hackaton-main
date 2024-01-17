-- DML statements used for inserting queried telemetry data into either Kudu of Kafka.

SET 'table.local-time-zone' = 'UTC';

-- Used for streaming generated telemetry data directly into Kudu from Streaming SQL Console.
INSERT INTO `nirchi-kudu`.`default_database`.`default.tm_events_raw`
SELECT 
  tm_event_id,
  driver_id,
  trip_num,
  speed,
  lat_accel,
  long_accel,
  throttle_pos,
  brake_press,
  steer_ang,
  steer_ang_rate,
  DATE_FORMAT(TO_TIMESTAMP_LTZ(ts_timestamp, 3),'MM-dd-yyyy hh:mm:ss a') as tm_event_dt,
  ts_timestamp
FROM ssc_tm_events_raw;

-----------------

SET 'table.local-time-zone' = 'UTC';

-- Used for streaming generated telemetry data into Kafka from Streaming SQL Console.
INSERT INTO kafka_tm_events_raw
SELECT 
  tm_event_id,
  driver_id,
  trip_num,
  speed,
  lat_accel,
  long_accel,
  throttle_pos,
  brake_press,
  steer_ang,
  steer_ang_rate,
  ts_timestamp,
  TO_TIMESTAMP_LTZ(ts_timestamp, 3) as eventTimestamp
FROM ssc_tm_events_raw;