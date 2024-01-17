-- Streaming SQL Console (SSC) Virtual Table DDL Script

-- Create virtual table data source for raw telemetry data generation.
CREATE TABLE ssc_tm_events_raw (
 tm_event_id BIGINT, 
 driver_id INT,
 trip_num BIGINT, 
 speed INT,
 lat_accel FLOAT,
 long_accel FLOAT,
 throttle_pos FLOAT,
 brake_press FLOAT,
 steer_ang FLOAT,
 steer_ang_rate FLOAT,
 ts_timestamp BIGINT
) WITH (
'connector' = 'ts_gen',
'avro_schema_file_name' = 'tm-gen.avro',
'ts_schema_location' = '/tmp',
'avro_schema_location' = '/tmp',
'ts_schema_file_name' = 'tm-gen.json'
)