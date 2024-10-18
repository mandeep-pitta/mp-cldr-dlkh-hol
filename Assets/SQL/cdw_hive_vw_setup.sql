-- CREATE DATABASES
CREATE DATABASE ${prefix}_airlines_csv;
CREATE DATABASE ${prefix}_airlines;
CREATE DATABASE ${prefix}_airlines_maint;

-- CREATE CSV TABLES
drop table if exists ${prefix}_airlines_csv.flights_csv;

CREATE EXTERNAL TABLE ${prefix}_airlines_csv.flights_csv (month int, dayofmonth int, dayofweek int, deptime int, crsdeptime int, arrtime int, crsarrtime int, uniquecarrier string, flightnum int, tailnum string, actualelapsedtime int, crselapsedtime int, airtime int, arrdelay int, depdelay int, origin string, dest string, distance int, taxiin int, taxiout int, cancelled int, cancellationcode string, diverted string, carrierdelay int, weatherdelay int, nasdelay int, securitydelay int, lateaircraftdelay int, year int)
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n'
STORED AS TEXTFILE LOCATION 's3a://${cdp_env_bucket}/airlines-csv/flights' tblproperties("skip.header.line.count"="1");

drop table if exists ${prefix}_airlines_csv.planes_csv;

CREATE EXTERNAL TABLE ${prefix}_airlines_csv.planes_csv (tailnum string, owner_type string, manufacturer string, issue_date string, model string, status string, aircraft_type string, engine_type string, year int)
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n'
STORED AS TEXTFILE LOCATION 's3a://${cdp_env_bucket}/airlines-csv/planes' tblproperties("skip.header.line.count"="1");

drop table if exists ${prefix}_airlines_csv.airlines_csv;

CREATE EXTERNAL TABLE ${prefix}_airlines_csv.airlines_csv (code string, description string) 
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n'
STORED AS TEXTFILE LOCATION 's3a://${cdp_env_bucket}/airlines-csv/airlines/' tblproperties("skip.header.line.count"="1");

drop table if exists ${prefix}_airlines_csv. airports_csv;

CREATE EXTERNAL TABLE ${prefix}_airlines_csv.airports_csv (iata string, airport string, city string, state DOUBLE, country string, lat DOUBLE, lon DOUBLE)
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n'
STORED AS TEXTFILE LOCATION 's3a://${cdp_env_bucket}/airlines-csv/airports' tblproperties("skip.header.line.count"="1");

drop table if exists ${prefix}_airlines_csv.unique_tickets_csv;

CREATE external TABLE ${prefix}_airlines_csv.unique_tickets_csv (ticketnumber BIGINT, leg1flightnum BIGINT, leg1uniquecarrier STRING, leg1origin STRING,   leg1dest STRING, leg1month BIGINT, leg1dayofmonth BIGINT,   
 leg1dayofweek BIGINT, leg1deptime BIGINT, leg1arrtime BIGINT,   
 leg2flightnum BIGINT, leg2uniquecarrier STRING, leg2origin STRING,   
 leg2dest STRING, leg2month BIGINT, leg2dayofmonth BIGINT,   leg2dayofweek BIGINT, leg2deptime BIGINT, leg2arrtime BIGINT ) 
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n' 
STORED AS TEXTFILE LOCATION 's3a://${cdp_env_bucket}/airlines-csv/unique_tickets' 
tblproperties("skip.header.line.count"="1");

-- CREATE HIVE TABLE FORMAT STORED AS PARQUET
drop table if exists ${prefix}_airlines.planes;

CREATE EXTERNAL TABLE ${prefix}_airlines.planes (
  tailnum STRING, owner_type STRING, manufacturer STRING, issue_date STRING,
  model STRING, status STRING, aircraft_type STRING,  engine_type STRING, year INT 
) 
STORED AS PARQUET
TBLPROPERTIES ('external.table.purge'='true')
;

INSERT INTO ${prefix}_airlines.planes
  SELECT * FROM ${prefix}_airlines_csv.planes_csv;


drop table if exists ${prefix}_airlines.unique_tickets;

CREATE EXTERNAL TABLE ${prefix}_airlines.unique_tickets (
  ticketnumber BIGINT, leg1flightnum BIGINT, leg1uniquecarrier STRING,
  leg1origin STRING,   leg1dest STRING, leg1month BIGINT,
  leg1dayofmonth BIGINT, leg1dayofweek BIGINT, leg1deptime BIGINT,
  leg1arrtime BIGINT, leg2flightnum BIGINT, leg2uniquecarrier STRING,
  leg2origin STRING, leg2dest STRING, leg2month BIGINT, leg2dayofmonth BIGINT,
  leg2dayofweek BIGINT, leg2deptime BIGINT, leg2arrtime BIGINT 
) 
STORED AS PARQUET
TBLPROPERTIES ('external.table.purge'='true');

INSERT INTO ${prefix}_airlines.unique_tickets
  SELECT * FROM ${prefix}_airlines_csv.unique_tickets_csv;

-- CREATE ICEBERG TABLE FORMAT STORED AS PARQUET
drop table if exists ${prefix}_airlines.flights_iceberg;

CREATE EXTERNAL TABLE ${prefix}_airlines.flights_iceberg (
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
STORED AS PARQUET
TBLPROPERTIES ('format-version'='2','external.table.purge'='true')
;

-- LOAD DATA INTO ICEBERG TABLE FORMAT STORED AS PARQUET
INSERT INTO ${prefix}_airlines.flights_iceberg
 SELECT * FROM ${prefix}_airlines_csv.flights_csv
 WHERE year <= 2006;


-- [TABLE MAINTENANCE] CREATE FLIGHTS TABLE IN ICEBERG TABLE FORMAT STORED AS PARQUET
drop table if exists ${prefix}_airlines_maint.flights;

CREATE TABLE ${prefix}_airlines_maint.flights (
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
STORED AS PARQUET
TBLPROPERTIES ('format-version'='2','external.table.purge'='true')
;
