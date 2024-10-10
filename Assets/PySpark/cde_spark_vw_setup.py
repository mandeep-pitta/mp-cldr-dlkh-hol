# VARIABLES - change "<user_id>" & "<cdp_env_bucket>"
user_id = "<user_id>"
cdp_env_bucket = "s3a://<cdp_env_bucket>"
csv_database_name = user_id + "_airlines_csv"
odl_database_name = user_id + "_airlines"
maint_database_name = user_id + "_airlines_maint"


# CREATE DATABASES
spark.sql(f"CREATE DATABASE IF NOT EXISTS {csv_database_name}").show()
spark.sql(f"CREATE DATABASE IF NOT EXISTS {odl_database_name}").show()
spark.sql(f"CREATE DATABASE IF NOT EXISTS {maint_database_name}").show()


# CSV FILE SETTINGS
format = "ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n'"
tblprop = "tblproperties('skip.header.line.count'='1')"
stored_as = "STORED AS TEXTFILE"

# CREATE CSV TABLES
# --- flights_csv
flights_cols_1 = "month int, dayofmonth int, dayofweek int, deptime int, crsdeptime int, arrtime int, crsarrtime int, "
flights_cols_2 = "uniquecarrier string, flightnum int, tailnum string, actualelapsedtime int, crselapsedtime int, "
flights_cols_3 = "airtime int, arrdelay int, depdelay int, origin string, dest string, distance int, taxiin int, taxiout int, "
flights_cols_4 = "cancelled int, cancellationcode string, diverted string, carrierdelay int, weatherdelay int, nasdelay int, securitydelay int, lateaircraftdelay int"
flights_part_cols = "year int"
flights_cols = flights_cols_1 + flights_cols_2 + flights_cols_3 + flights_cols_4 + ", " + flights_part_cols

spark.sql(f"drop table if exists {csv_database_name}.flights_csv").show()

loc = f"LOCATION '{cdp_env_bucket}/airlines-csv/flights'"
spark.sql(f"CREATE EXTERNAL TABLE {csv_database_name}.flights_csv ({flights_cols}) {format} {stored_as} {loc} {tblprop}").show()

# --- planes_csv
planes_cols_1 = "tailnum string, owner_type string, manufacturer string, issue_date string, model string, "
planes_cols_2 = "status string, aircraft_type string, engine_type string, year int"
planes_cols = planes_cols_1 + planes_cols_2

spark.sql(f"drop table if exists {csv_database_name}.planes_csv").show()

loc = f"LOCATION '{cdp_env_bucket}/airlines-csv/planes'"
spark.sql(f"CREATE EXTERNAL TABLE {csv_database_name}.planes_csv ({planes_cols}) {format} {stored_as} {loc} {tblprop}").show()

# --- airlines_csv
airlines_cols = "code string, description string"

spark.sql(f"drop table if exists {csv_database_name}.airlines_csv").show()

loc = f"LOCATION '{cdp_env_bucket}/airlines-csv/airlines'"
spark.sql(f"CREATE EXTERNAL TABLE {csv_database_name}.airlines_csv ({airlines_cols}) {format} {stored_as} {loc} {tblprop}").show()

# --- airports_csv
airports_cols = "iata string, airport string, city string, state DOUBLE, country string, lat DOUBLE, lon DOUBLE"

spark.sql(f"drop table if exists {csv_database_name}.airports_csv").show()

loc = f"LOCATION '{cdp_env_bucket}/airlines-csv/airports'"
spark.sql(f"CREATE EXTERNAL TABLE {csv_database_name}.airports_csv ({airports_cols}) {format} {stored_as} {loc} {tblprop}").show()

# --- unique_tickets_csv
tickets_cols_1 = "ticketnumber BIGINT, leg1flightnum BIGINT, leg1uniquecarrier STRING, leg1origin STRING,   leg1dest STRING, leg1month BIGINT, leg1dayofmonth BIGINT, "
tickets_cols_2 = "leg1dayofweek BIGINT, leg1deptime BIGINT, leg1arrtime BIGINT, "
tickets_cols_3 = "leg2flightnum BIGINT, leg2uniquecarrier STRING, leg2origin STRING, "
tickets_cols_4 = "leg2dest STRING, leg2month BIGINT, leg2dayofmonth BIGINT,   leg2dayofweek BIGINT, leg2deptime BIGINT, leg2arrtime BIGINT"
tickets_cols = tickets_cols_1 + tickets_cols_2 + tickets_cols_3 + tickets_cols_4

spark.sql(f"drop table if exists {csv_database_name}.unique_tickets_csv").show()

loc = f"LOCATION '{cdp_env_bucket}/airlines-csv/unique_tickets'"
spark.sql(f"CREATE EXTERNAL TABLE {csv_database_name}.unique_tickets_csv ({tickets_cols}) {format} {stored_as} {loc} {tblprop}").show()


#
# OPEN DATA LAKEHOUSE
#

# - CREATE HIVE TABLE FORMAT STORED AS PARQUET
tblprop = ""
stored_as = "STORED AS PARQUET"

# --- planes Hive Table
spark.sql(f"drop table if exists {odl_database_name}.planes").show()

loc = f"LOCATION '{cdp_env_bucket}/warehouse/tablespace/external/hive/{odl_database_name}.db/planes'"
spark.sql(f"CREATE EXTERNAL TABLE {odl_database_name}.planes ({planes_cols}) {stored_as} {loc} {tblprop}").show()

spark.sql(f"INSERT INTO {odl_database_name}.planes SELECT * FROM {csv_database_name}.planes_csv").show()

# --- unique_tickets Hive Table
spark.sql(f"drop table if exists {odl_database_name}.unique_tickets").show()

loc = f"LOCATION '{cdp_env_bucket}/warehouse/tablespace/external/hive/{odl_database_name}.db/unique_tickets'"
spark.sql(f"CREATE EXTERNAL TABLE {odl_database_name}.unique_tickets ({tickets_cols}) {stored_as} {loc} {tblprop}").show()

spark.sql(f"INSERT INTO {odl_database_name}.unique_tickets SELECT * FROM {csv_database_name}.unique_tickets_csv").show()


# --- flights_iceberg Iceberg Table partitioned PARQUET file format
tblprop = "TBLPROPERTIES('format-version'='2')"
partitioned_by = f"PARTITIONED BY ({flights_part_cols})"

spark.sql(f"drop table if exists {odl_database_name}.flights_iceberg").show()

flights_cols = flights_cols_1 + flights_cols_2 + flights_cols_3 + flights_cols_4
spark.sql(f"CREATE TABLE {odl_database_name}.flights_iceberg ({flights_cols}) USING ICEBERG {partitioned_by} {tblprop}").show()

spark.sql(f"INSERT INTO {odl_database_name}.flights_iceberg SELECT * FROM {csv_database_name}.flights_csv WHERE year IN (2005, 2006)").show()


# [optional: Table Maintenance] --- flights Iceberg Table partitioned PARQUET file format
tblprop = "TBLPROPERTIES('format-version'='2')"
partitioned_by = f"PARTITIONED BY ({flights_part_cols})"

spark.sql(f"drop table if exists {maint_database_name}.flights").show()

flights_cols = flights_cols_1 + flights_cols_2 + flights_cols_3 + flights_cols_4
spark.sql(f"CREATE TABLE {maint_database_name}.flights ({flights_cols}) USING ICEBERG {partitioned_by} {tblprop}").show()
