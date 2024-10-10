# Migrate Existing Tables to Iceberg Tables Using Spark DataFrame

## Overview

This submodule provides guidance on migrating existing tables to the Iceberg format using Spark DataFrames on the Cloudera Data Platform (CDP). It covers two primary methods:

1. **In-Place Migration**: Convert an existing Hive table to Iceberg format using Spark DataFrames without moving the data.
2. **Create Table as Select (CTAS)**: Create a new Iceberg table by selecting data from an existing Hive table and writing it out using Spark DataFrames.

These methods allow you to leverage Iceberg's capabilities for efficient data management and enhanced query performance.

## Prerequisites

Before starting, ensure you have:

- Access to a Cloudera Data Engineering (CDE) session.
- Proper permissions to execute Spark commands.
- Your `${prefix}` (e.g., your User ID) ready for use in the code.

## Method 1: In-Place Migration (Convert Existing Table to Iceberg)

### Step 1: Set Up Variables

Begin by setting up your environment variables. Replace `<prefix>` with your unique value (e.g., your User ID).

  ``` python
  # Variables - replace <prefix> with your unique value (i.e., your User ID)
  prefix = "<prefix>"
  odl_database_name = prefix + "_airlines"
  ```

### Step 2: Check the Current Table Format

Before migrating, check the current table format to confirm it is in Hive format.

  ``` python
  # CHECK TABLE FORMAT - before migration (returns 'hive')
  (spark.sql(f"DESCRIBE FORMATTED {odl_database_name}.planes")
      .filter("col_name=='Provider'")
      .collect()[0]
      .data_type)
  ```

### Step 3: Migrate the Table to Iceberg Format

Execute the following SparkSQL command to migrate the table in place:

``` python
# MIGRATE planes Hive table format IN PLACE to Iceberg table format
spark.sql(f"CALL system.migrate('{odl_database_name}.planes')").show()
```

### Step 4: Verify the Migration

After migration, check the table format again to ensure it has been successfully converted to Iceberg.

  ``` python
  # CHECK TABLE FORMAT - after migration (returns 'iceberg')
  (spark.sql(f"DESCRIBE FORMATTED {odl_database_name}.planes")
      .filter("col_name=='Provider'")
      .collect()[0]
      .data_type)
  ```

**Note:** In the output, look for the `Provider` field to confirm that it indicates "ICEBERG".

TODO: Placeholder for Image: ../../images/.png

### Summary of In-Place Migration

This method allows you to migrate tables to Iceberg format without altering the original data files. The process is efficient and minimizes disruption by focusing on metadata updates.

## Method 2: Create Table as Select (CTAS)

### Step 1: Set Up Variables

Set up your environment variables, replacing `<prefix>` with your unique value (e.g., your User ID).

  ``` python
  # Variables - replace <prefix> with your unique value (i.e., your User ID)
  prefix = "<prefix>"
  csv_database_name = prefix + "_airlines_csv"
  odl_database_name = prefix + "_airlines"
  ```

### Step 2: Migrate Using CTAS

Read the data from the existing Hive table into a Spark DataFrame, then write it out as a new Iceberg table.

  ```
  python
  # MIGRATE airports_csv Hive table format using CTAS to Iceberg table format
  spark_df = spark.read.table(f"{csv_database_name}.airports_csv")

  spark_df.write.format("iceberg").mode("overwrite").saveAsTable(f"{odl_database_name}.airports")
  ```

### Step 3: Verify the Migration

Check the table format after migration to ensure it has been successfully converted to Iceberg.

  ``` python
  # CHECK TABLE FORMAT - after migration CTAS (returns 'iceberg')
  (spark.sql(f"DESCRIBE FORMATTED {odl_database_name}.airports")
      .filter("col_name=='Provider'")
      .collect()[0]
      .data_type)
  ```

**Note:** In the output, look for the `Provider` field to confirm that it indicates "ICEBERG".

### Summary of CTAS

This method is useful when you want to create a new table from scratch in Iceberg format using Spark DataFrames. It allows you to migrate data efficiently while taking full advantage of Iceberg's features.

## Conclusion

You’ve now explored two methods for migrating tables to Iceberg format using Spark DataFrames: in-place conversion and CTAS. Both approaches help you optimize data management and query performance by leveraging the capabilities of Iceberg.
