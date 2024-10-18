# Evolve Iceberg Table Schema Using Spark SQL

## Overview

In this submodule, we will explore in-place schema evolution using Spark SQL within a Cloudera Data Engineering (CDE) session. Iceberg’s schema evolution feature allows you to add new columns to tables without modifying existing data, ensuring backward compatibility and efficient schema management.

## Step-by-Step Guide

### Step 1: Set Up the Environment

Start by opening a CDE session. Set up your environment variables by replacing `<prefix>` with your User ID:

``` python
# Variables - replace <prefix> with your user ID
prefix = "<prefix>"
odl_database_name = prefix + "_airlines"
```

### Step 2: Check the Table Schema Before Evolution

Use the following Spark SQL command to check the current schema of the `airlines` table before making changes:

``` python
# CHECK TABLE FORMAT - before in-place schema evolution
spark.sql(f"DESCRIBE FORMATTED {odl_database_name}.airlines").show()
```

### Step 3: Evolve the Schema In-Place

Execute the following Spark SQL command to add new columns (`status`, `updated`) to the `airlines` table. The schema will be modified in-place without affecting existing data:

``` python
# EVOLVE SCHEMA IN-PLACE - add columns to improve the table schema
spark.sql(f"ALTER TABLE {odl_database_name}.airlines ADD COLUMNS(status STRING, updated TIMESTAMP)").show()
```

### Step 4: Verify the Schema After Evolution

After evolving the schema, check the table format again to confirm the changes:

``` python
# CHECK TABLE FORMAT - after schema evolution
spark.sql(f"DESCRIBE FORMATTED {odl_database_name}.airlines").show()
```

### Step 5: Insert Data Into the New Schema

Insert new data into the table to take advantage of the updated schema with the newly added columns:

``` python
# INSERT A NEW RECORD USING NEW COLUMNS - status & updated
spark.sql(f"INSERT INTO {odl_database_name}.airlines VALUES('Z999', 'Adrenaline Airways', 'NEW', now())").show()
```

### Step 6: Query the Updated Data

Query the table to see both the old and new schema data. Existing rows will show `NULL` values for the new columns, while newly inserted rows will display values for the `status` and `updated` columns:

``` python
# Query airlines table to see old and new schema data
spark.sql(f"SELECT * FROM {odl_database_name}.airlines WHERE code > 'Z'").show()
```

## Summary

In this submodule, you learned how to evolve the schema of an Iceberg table in-place using Spark SQL in a CDE session. You successfully added new columns without affecting the existing data and inserted records using the updated schema.

## Next Steps

To continue exploring schema evolution with Iceberg, proceed to the next submodule:

- `03` **[Evolve Iceberg Table Schema Using Spark DataFrames](SchemaEvolution_SparkDF.md)**
