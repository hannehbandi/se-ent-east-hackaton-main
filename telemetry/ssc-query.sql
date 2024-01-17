-- Query the Kafka event stream across slices of time for min, max and average speeds,
-- allowing easy identification of drivers frequently exceeding 75 mph.
SELECT
  driver_id,
  HOP_END(eventTimestamp, INTERVAL '1' DAY, INTERVAL '30' DAY) as windowEnd,
  count(*) as readCount,  
  avg(cast(speed as float)) as speedAverage,
  min(speed) as speedMin,
  max(speed) as speedMax,
  sum(case when speed > 75 then 1 else 0 end) as speedGreaterThan75  
FROM kafka_tm_events_raw
GROUP BY
  driver_id,
  HOP(eventTimestamp, INTERVAL '1' DAY, INTERVAL '30' DAY)