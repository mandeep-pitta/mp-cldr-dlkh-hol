# Tagging

In this section we will work with Tags to retain a Snapshot for 365 days.  Iceberg tagging is available in Hive only. Iceberg tagging is not available in Impala or Spark.

Tags are named references to snapshots with their own independent lifecycle.  You can use a <b>Tag</b> to set retention policies on specific Snapshots.  Other use cases inclue GDPR requirements and retaining important historical snapshots for auditing.

**Query the Flights' Table History (in CDW HUE)**

- Execute the following in HUE for Hive VW

```
SELECT *
FROM ${user_id}_airlines.flights.HISTORY;
```

- In results you see various Snapshots that have been created.  From the results, copy the Snapshot ID for the first Snapshot.  This was the original data loaded into the table.


**Create Tag to Retain Snapshot for 365 Days**

- Execute the following in HUE for Hive VW

- Enter "audit" in the tag_name prompt

```
-- CREATE TAG (for the tag_name do NOT use capital letters)
ALTER TABLE ${user_id}_airlines.flights 
   CREATE TAG `${tag_name}` 
   FOR SYSTEM_VERSION AS OF ${snapshot_ID} 
   RETAIN 365 DAYS;
```

**Query the Flights' Table  (in CDW HUE)**

- Execute the following in HUE for Hive VW

- Paste the copied Snapshot ID into the "snapshot_id" prompt box

```
-- SHOW ALL TAGS & BRANCHES
SELECT * from ${user_id}_airlines.flights.REFS;
```

- In results you see the Tag named **audit** and if looking at the retention column you can see that this Tag is retained for 365 days represented in milliseconds

**Query the Audit Tag Created for the Flights' Table (in CDW HUE)**

- Execute the following to query the Tag

```
-- Query tag to see data in the Tag
SELECT *
  FROM ${user_id}_airlines.flights.tag_${tag_name}
LIMIT 100;
```

