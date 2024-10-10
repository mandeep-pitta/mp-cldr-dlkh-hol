# Time Travel

In the previous steps we have been loading data into the flights Iceberg table.  Each time we add (delete or update) data a Snapshot is captured.  This is important for many reasons but the main point of the Snapshot is to ensure eventual consistency and allow for multiple reads/writes concurrently (from various engines or the same engine).  In this Runbook you take advantage of one of the features, Time Travel.  We will use this to query data from a specific point in time, a good use case where this is important is regulatory compliance.

**Time Travel feature**

- In the next few steps execute the following in HUE for Impala VW

```
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
```

- Highlight and Execute the “DESCRIBE HISTORY” line.  This returns all of the available Snapshots for the flight Iceberg table.  There were 2 Snapshots automatically captured each time we loaded data

![59.png](../../images/59.png)

- In the create\_ts parameter box enter a date/time (this can be relative or specific timestamp) in the orange box under creation\_time, in this example I picked a time between the 2 snapshots of 2022-11-15 21:50:00

- In the snapshot\_id parameter box enter the number in the blue box under snapshot\_id, in this example it is 7116728088845144567

![60.png](../../images/60.png)

- Highlight and Execute the Query with the “FOR SYSTEM\_TIME AS OF”.  You can use a specific timestamp or you can use a relative timestamp and Iceberg will take the Snapshot that was in effect as of that time specified

![61.png](../../images/61.png)

- Highlight and Execute the Query with the “FOR SYSTEM\_VERSION AS OF”.  This uses the specific snapshot\_id specified.

* In the examples used in this Runbook you should get the exact same output.  Both statements will use the same Snapshot which was our first data load that was for all data <= 2006.  If you specify the other Snapshot and run the same queries, you will see the same data plus you will see the year 2007 because this snapshot is for the last load we ran.

