# Rollback - Bad data load, need to be able to restore to last known good state

- In Hive VW

- Execute to see the bad data

```
    -- Check data that was loaded - will see year=9999 (invalid)
    SELECT year, count(*) 
    FROM ${prefix}_airlines_maint.flights
    GROUP BY year
    ORDER BY year desc;
```

- Execute to see Snapshots

```
    -- See Snapshot to determine when this data was loaded
    SELECT * FROM ${prefix}_airlines_maint.flights.snapshots;
```

- Execute this block to ensure this is the Snapshot containing the bad record

```
    -- SELECT DATA USING TIMESTAMP FOR SNAPSHOT
    --      Using the previous Snapshot will see that this is where the records were loaded (Rollback needed)
    SELECT year, count(*) 
    FROM ${prefix}_airlines_maint.flights
      FOR SYSTEM_VERSION AS OF ${snapshot_id}
    GROUP BY year
    ORDER BY year desc;
```

- Execute to Rollback

```
    -- ROLLBACK TO LAST KNOWN "GOOD" STATE FOR THE TABLE
    ALTER TABLE ${prefix}_airlines_maint.flights EXECUTE ROLLBACK(${snapshot_id});
```

- Query to see that bad record has been removed

```
    -- Check data has been restored to last known "GOOD" state - data to year 2006
    SELECT year, count(*) 
    FROM ${prefix}_airlines_maint.flights
    GROUP BY year
    ORDER BY year desc;
```
