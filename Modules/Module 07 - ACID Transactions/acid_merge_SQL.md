# ACID Merge with SQL in Hive

## Overview

In this submodule, we will leverage the ACID capabilities of Iceberg using the **SQL MERGE** command. This feature allows for the combination of insert, update, and delete operations in a single command, ensuring data integrity and consistency within the Iceberg table.

## Step-by-Step Guide

### Step 1. Create the Iceberg Table

Run the following command in Hue (Hive Virtual Warehouse) to create the target Iceberg table:

```
-- Create Iceberg Table
DROP TABLE IF EXISTS ${prefix}_airlines.airlines;

CREATE EXTERNAL TABLE ${prefix}_airlines.airlines (
  code string, 
  description string
)
STORED BY ICEBERG
TBLPROPERTIES ('format-version' = '2', 'external.table.purge'='true')
;

-- Load Data into Iceberg Table
INSERT INTO ${prefix}_airlines.airlines 
SELECT * FROM ${prefix}_airlines_csv.airlines_csv;

-- Review Results to ensure the record was updated
SELECT *
FROM ${prefix}_airlines.airlines
WHERE code IN ('UA','04Q','05Q','Z999');
```

- After running the above commands, you should see the following results:
	
	![ACID Merge Before](../../images/ACID_Merge_before.png)

### Step 2. Perform the SQL ACID Merge

Run the following SQL `MERGE` command to insert, update, and delete records into the target Iceberg table from the source table:

```
-- ACID Merge (Iceberg Table)
   -- Update row with code '05Q' from "Comlux Aviation" to "Comlux Aviation"
   -- Delete row with code '04Q'
   -- Insert new row for Z999 Adrenaline Airways

MERGE INTO ${prefix}_airlines.airlines AS t
  USING (
  SELECT * FROM ${prefix}_airlines_csv.airlines_csv
  UNION
  SELECT "Z999" AS code, "Adrenaline Airways" AS description FROM ${prefix}_airlines_csv.airlines_csv a WHERE a.code = "UA"
  ) s ON t.code = s.code
WHEN MATCHED AND t.code = "04Q" THEN DELETE
WHEN MATCHED AND t.code = "05Q" THEN UPDATE SET description = "Comlux Aviation"
WHEN NOT MATCHED THEN INSERT VALUES (s.code, s.description);
```

### Step 3. Review the Results

After running the `MERGE` statement, execute the following query to review the changes made:

```
-- Review Results to ensure records were inserted, updated, and deleted
SELECT *
FROM ${prefix}_airlines.airlines
WHERE code IN ('UA','04Q','05Q','Z999');
```

- You should see the following results after running the `MERGE` statement:
	
	![ACID Merge After](../../images/ACID_Merge_after.png)

## Summary

In this submodule, you learned how to perform an ACID `MERGE` operation on an Iceberg table using SQL in Hue (Hive Virtual Warehouse). You successfully inserted, updated, and deleted records in the table, demonstrating Iceberg’s ACID capabilities.

## Next Steps

To continue exploring ACID transactions with Iceberg, proceed to the next submodule:

- [ACID Merge with Spark SQL in CML](acid_merge_SparkSQL.md)