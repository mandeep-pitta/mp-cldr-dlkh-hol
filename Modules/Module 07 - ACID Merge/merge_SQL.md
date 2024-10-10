# SQL ACID Merge feature - shown in Hive

Here we will be taking advantage of the ACID capabilities of Iceberg using the **SQL MERGE** command.

**HUE in Hive VW** 

- Run the following to create the table that will be the target table.

```
-- Create Iceberg Table
DROP TABLE IF EXISTS ${user_id}_airlines.airlines;

CREATE EXTERNAL TABLE ${user_id}_airlines.airlines (
code string, description string
)
STORED BY ICEBERG
TBLPROPERTIES ('format-version' = '2', 'external.table.purge'='true')
;

-- Load Data into Iceberg Table
INSERT INTO ${user_id}_airlines.airlines 
SELECT * FROM ${user_id}_airlines_csv.airlines_csv;


-- Review Results to ensure record was updated
SELECT *
FROM ${user_id}_airlines.airlines
WHERE code IN ('UA','04Q','05Q','Z999');
```
   - You should see the following results
![ACID_Merge_before.png](../../images/ACID_Merge_before.png)

- Run the following to perform the SQL ACID Merge statement to Insert/Update/Delete records into the target table from the source table.

```
-- ACID Merge (Iceberg Table)
   -- Upate row with code '05Q' from "Comlux Aviation to Comlux Aviation
   -- Delete row with code '04Q'
   -- Insert new row for Z999 Adrenaline Airways (it really inserts all new records found in the source table)

MERGE INTO ${user_id}_airlines.airlines AS t
  USING (
  SELECT * FROM ${user_id}_airlines_csv.airlines_csv
  UNION
  SELECT "Z999" AS code, "Adrenaline Airways" AS description FROM ${user_id}_airlines_csv.airlines_csv a WHERE a.code = "UA"
  ) s ON t.code = s.code
WHEN MATCHED AND t.code = "04Q" THEN DELETE
WHEN MATCHED AND t.code = "05Q" THEN UPDATE SET description = "Comlux Aviation"
WHEN NOT MATCHED THEN INSERT VALUES (s.code, s.description);
```

- Execute the following to explore what happened from the MERGE INTO statement

```
-- Review Results to ensure records were inserted, updated, and deleted
SELECT *
FROM ${user_id}_airlines.airlines
WHERE code IN ('UA','04Q','05Q','Z999');
```
   - You should see the following results after running the MERGE statement
![ACID_Merge_after.png](../../images/ACID_Merge_after.png)
