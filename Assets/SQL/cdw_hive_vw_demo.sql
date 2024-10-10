-- Migrate Table Feature
DESCRIBE FORMATTED ${user_id}_airlines.planes;

ALTER TABLE ${user_id}_airlines.planes
SET TBLPROPERTIES ('storage_handler'='org.apache.iceberg.mr.hive.HiveIcebergStorageHandler');

DESCRIBE FORMATTED ${user_id}_airlines.planes;

--
-- CTAS to create Iceberg Table format
drop table if exists ${user_id}_airlines.airports;

CREATE EXTERNAL TABLE ${user_id}_airlines.airports
STORED BY ICEBERG AS
  SELECT * FROM ${user_id}_airlines_csv.airports_csv;

DESCRIBE FORMATTED ${user_id}_airlines.airports;

--
-- Create Partitioned Iceberg Table
drop table if exists ${user_id}_airlines.flights;

CREATE EXTERNAL TABLE ${user_id}_airlines.flights (
 month int, dayofmonth int, 
 dayofweek int, deptime int, crsdeptime int, arrtime int, 
 crsarrtime int, uniquecarrier string, flightnum int, tailnum string, 
 actualelapsedtime int, crselapsedtime int, airtime int, arrdelay int, 
 depdelay int, origin string, dest string, distance int, taxiin int, 
 taxiout int, cancelled int, cancellationcode string, diverted string, 
 carrierdelay int, weatherdelay int, nasdelay int, securitydelay int, 
 lateaircraftdelay int
) 
PARTITIONED BY (year int)
STORED BY ICEBERG 
STORED AS PARQUET;

SHOW CREATE TABLE ${user_id}_airlines.flights;

--
-- Load Data into Partitioned Iceberg Table
INSERT INTO ${user_id}_airlines.flights
 SELECT * FROM ${user_id}_airlines_csv.flights_csv
 WHERE year <= 2006;

--
-- Query Table
SELECT year, count(*) 
FROM ${user_id}_airlines.flights
GROUP BY year
ORDER BY year desc;

--
-- Partition Evolution
ALTER TABLE ${user_id}_airlines.flights
SET PARTITION spec ( year, month );

SHOW CREATE TABLE ${user_id}_airlines.flights;

--
-- Load Data into Iceberg Table using NEW Partition
INSERT INTO ${user_id}_airlines.flights
 SELECT * FROM ${user_id}_airlines_csv.flights_csv
 WHERE year = 2007;


--
-- [OPTIONAL] TABLE MAINTENANCE FEATURES
--     1. [CML] Table Compaction
--     2. Rollback
--     3. Expire Snapshot(s)

-- 1. Go to run CML code first, as this will load the data

-- 2. Check data that was loaded - will see year=9999 (invalid)
SELECT year, count(*) 
FROM ${user_id}_airlines_maint.flights
GROUP BY year
ORDER BY year desc;

-- See Snapshot to determine when this data was loaded
SELECT * FROM ${user_id}_airlines_maint.flights.snapshots;

-- SELECT DATA USING TIMESTAMP FOR SNAPSHOT
--      Using the previous Snapshot will see that this is where the records were loaded (Rollback needed)
SELECT year, count(*) 
FROM ${user_id}_airlines_maint.flights
  FOR SYSTEM_VERSION AS OF ${snapshot_id}
GROUP BY year
ORDER BY year desc;

-- ROLLBACK TO LAST KNOWN "GOOD" STATE FOR THE TABLE
ALTER TABLE ${user_id}_airlines_maint.flights EXECUTE ROLLBACK(${snapshot_id});

-- Check data has been restored to last known "GOOD" state - data to year 2006
SELECT year, count(*) 
FROM ${user_id}_airlines_maint.flights
GROUP BY year
ORDER BY year desc;

-- 3. EXPIRE SNAPSHOT(S)
SELECT * FROM ${user_id}_airlines_maint.flights.snapshots;

-- Expire Snapshots up to the specified timestamp
--      BE CAREFUL: Once you run this you will not be able to Time Travel for any Snapshots that you Expire
ALTER TABLE ${user_id}_airlines_maint.flights EXECUTE expire_snapshots('${create_ts}');

-- Ensure Snapshots have been removed
SELECT * FROM ${user_id}_airlines_maint.flights.snapshots;

