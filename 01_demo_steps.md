# Demo Steps

The following describes the steps to take and how to deliver this demo.


# Prior to Demo - Prep Data Services that you’ll demo<a id="prior-to-demo---prep-data-services-that-youll-demo"></a>

- Open HUE for Hive VW in a browser window tab
   - Copy & paste the SQL below

- Open HUE for Impala VW in a browser window tab
   - Copy & paste the SQL below

- Open Ranger in a browser window tab

- Open CDE in a browser window tab

- Open CML Workspace in a browser window tab


# Prior to Demo - SQL that will be run in Hive VW HUE<a id="prior-to-demo---sql-that-will-be-run-in-hive-vw-hue"></a>

- Copy & paste the following to the HUE Editor for the Hive VW named **\<user-id>-iceberg-hive-vw**.  It will be Executed later

```
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
    --     1. [CML] Table Compaction
    --     2. Rollback
    --     3. Expire Snapshot(s)

    -- 1. Go to run CML code first, as this will load the data

    -- 2. Check data that was loaded - will see year=9999 (invalid)
    SELECT year, count(*) 
    FROM ${user_id}_airlines_maint.flights
    GROUP BY year
    ORDER BY year desc;

    -- See Snapshot to determine when this data was loaded
    SELECT * FROM ${user_id}_airlines_maint.flights.snapshots;

    -- SELECT DATA USING TIMESTAMP FOR SNAPSHOT
    --      Using the previous Snapshot will see that this is where the records were loaded (Rollback needed)
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
    --      BE CAREFUL: Once you run this you will not be able to Time Travel for any Snapshots that you Expire
    ALTER TABLE ${user_id}_airlines_maint.flights EXECUTE expire_snapshots('${create_ts}');

    -- Ensure Snapshots have been removed
    SELECT * FROM ${user_id}_airlines_maint.flights.snapshots;
```

# Prior to Demo - SQL that will be run in Impala VW HUE<a id="prior-to-demo---sql-that-will-be-run-in-impala-vw-hue"></a>

- In HUE Editor for the Impala VW named **\<user-id>-iceberg-impala-vw**, make sure to select the IMPALA Editor (for now do not use Unified Analytics, hasn’t been test for this Runbook)

  - To switch to the Impala Editor - on the left navigation click on the ![](../images/43.png) and select ![](../images/44.png)

\
![](../images/43.png)

 Notice in the gray bar that this is using the Unified Analytics as the Editor

![](../images/46.png)

After that you will see “Impala” in the gray bar above the SQL Editor.

- Copy & paste the following to the HUE Editor.  It will be Executed later 

```
    --
    -- QUERY TO SEE DATA LOADED FROM CDE
    SELECT year, count(*) 
    FROM ${user_id}_airlines.flights
    GROUP BY year
    ORDER BY year desc;

    --
    -- Typical analytic query patterns that need to be run

    -- RUN EXPLAIN PLAN ON THIS QUERY
    SELECT year, month, count(*) 
    FROM ${user_id}_airlines.flights
    WHERE year = 2006 AND month = 12
    GROUP BY year, month
    ORDER BY year desc, month asc;

    -- RUN EXPLAIN PLAN ON THIS QUERY; AND COMPARE RESULTS
    SELECT year, month, count(*) 
    FROM ${user_id}_airlines.flights
    WHERE year = 2007 AND month = 12
    GROUP BY year, month
    ORDER BY year desc, month asc;

    --
    -- SELECT SNAPSHOSTS THAT HAVE BEEN CREATED
    DESCRIBE HISTORY ${user_id}_airlines.flights;

    -- SELECT DATA USING TIMESTAMP FOR SNAPSHOT
    SELECT year, count(*) 
    FROM ${user_id}_airlines.flights
      FOR SYSTEM_TIME AS OF '${create_ts}'
    GROUP BY year
    ORDER BY year desc;

    -- SELECT DATA USING TIMESTAMP FOR SNAPSHOT
    SELECT year, count(*) 
    FROM ${user_id}_airlines.flights
      FOR SYSTEM_VERSION AS OF ${snapshot_id}
    GROUP BY year
    ORDER BY year desc;
    --
    -- [optional] SINGLE QUERY USING ICEBERG & HIVE TABLE FORMAT
    --            Uses CDV Dashboard, could also just query in HUE
    -- DESCRIBE FORMATTED ${user_id}_airlines.flights;
    DESCRIBE FORMATTED ${user_id}_airlines.unique_tickets;

    -- [optional] Query combining Hive Table Format (unique_tickets) and Iceberg Table Format (flights)
    SELECT 
    t.leg1origin,
    f.dest,
    count(*) as num_passengers
    FROM ${user_id}_airlines.unique_tickets t
    LEFT OUTER JOIN ${user_id}_airlines.flights f ON
      t.leg1origin = f.origin
      AND t.leg1dest = f.dest
      AND t.leg1flightnum = f.flightnum
      AND t.leg1month = f.month
      AND t.leg1dayofmonth = f.dayofmonth
    GROUP BY t.leg1origin, f.dest;

    --
    -- SDX FINE GRAINED ACCESS CONTROL
    --     1. Run query to see Tailnum in plain text
    --     2. Ranger - enable policy
    --     3. Run query again to see Tailnum is Hashed
    SELECT * FROM ${user_id}_airlines.planes;
```

