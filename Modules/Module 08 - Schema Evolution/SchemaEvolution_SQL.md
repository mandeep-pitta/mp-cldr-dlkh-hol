# Evolve Iceberg Table Schema Using SQL

## Overview

In this submodule, we will explore in-place schema evolution for Iceberg tables using SQL in Hue (Hive Virtual Warehouse). This process allows you to modify the table schema without affecting existing data, ensuring backward compatibility and flexibility for evolving business requirements.

## Step-by-Step Guide

### Step 1: Add Columns to the Table

Execute the following in Hue (Hive Virtual Warehouse) to add new columns to the `airlines` table.

```
ALTER TABLE ${prefix}_airlines.airlines ADD COLUMNS(status STRING, updated TIMESTAMP);
```

- The existing table data will **not be modified** with this statement.

   ![In Place Table Evolution](../../images/SchemaEvolution_Add_Columns.png)

### Step 2: Refresh the Table Browser

- Click on the **Refresh** button to the right of `Tables`.
- Click on the `airlines` table to see the newly added columns: `status` and `updated`.

   ![Updated Table Metadata](../../images/SchemaEvolution_Updated_Metadata.png)

### Step 3: Add Data Into the New Schema

Use the following query to insert data into the new schema of the `airlines` table:

```
INSERT INTO ${prefix}_airlines.airlines
VALUES("Z999","Adrenaline Airways","NEW",now());
```

### Step 4: Query the Table to See Old and New Data

Query the `airlines` table to observe how the old and new schema data co-exist. The newly inserted row will have values in the new columns, while existing rows will show `NULL` values for the new columns.

```
SELECT * FROM ${prefix}_airlines.airlines WHERE code > "Z";
```

   ![View Data After Schema Evolution](../../images/SchemaEvolution_View_Results.png)

## Summary

In this submodule, you learned how to evolve the schema of an Iceberg table in-place using SQL commands in Hue. You successfully added new columns without affecting the existing data, demonstrating Iceberg's ability to handle schema changes without costly rewrites.

## Next Steps

To continue exploring schema evolution in Iceberg, proceed to the next submodule:

- `02` **[Evolve Iceberg Table Schema Using Spark SQL](SchemaEvolution_SparkSQL.md)**
