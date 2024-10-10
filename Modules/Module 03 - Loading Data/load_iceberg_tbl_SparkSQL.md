# Load Data into Iceberg Table Using SparkSQL

## Overview

This submodule provides a guide for loading data into an Iceberg table using SparkSQL within a Cloudera Data Engineering (CDE) session. By leveraging SparkSQL, you'll experience the power of multi-function analytics and understand how Iceberg ensures consistency and handles concurrent writes from multiple services.

## Prerequisites

Before starting, ensure you have:

- Access to a Cloudera Data Engineering (CDE) session.
- Proper permissions to execute SparkSQL commands.
- Your `${prefix}` (e.g., your User ID) ready for use in the code.

## Step-by-Step Guide

### Step 1: Set Up Variables

Begin by setting up your environment variables. Replace `<prefix>` with your unique value (e.g., your User ID).

``` python
# Variables - replace <prefix> with your user id
prefix = "<prefix>"
csv_database_name = prefix + "_airlines_csv"
odl_database_name = prefix + "_airlines"
```

### Step 2: Insert Data into the Iceberg Table

Use SparkSQL to load data from a CSV file into your Iceberg table. This example demonstrates loading two years of data (2005 and 2006) from the `flights_csv` table into the `flights` Iceberg table.

``` python
# INSERT 2 YEARS OF DATA INTO FLIGHTS TABLE
spark.sql(f"INSERT INTO {odl_database_name}.flights SELECT * FROM {csv_database_name}.flights_csv WHERE year IN (2005, 2006)").show()
```

**Note:** This operation may take a few minutes to complete, depending on the size of the data.

### Step 3: Verify the Data Load

After the data load is complete, execute the following query to verify that the data has been correctly inserted into the Iceberg table. This query counts the number of flights for each year and orders the results in descending order.

``` python
# CHECK RESULTS
spark.sql(f"SELECT year, count(*) FROM {odl_database_name}.flights GROUP BY year ORDER BY year DESC").show()
```

### Value Proposition

This submodule demonstrates the versatility of Iceberg, showing how it can handle concurrent writes from multiple services while maintaining consistency. By mastering data loading with SparkSQL, you'll be better equipped to manage and analyze large datasets in a distributed environment.

### Summary

You have successfully loaded data into an Iceberg table using SparkSQL in a CDE session. The data is now stored in a scalable, performant format that supports advanced Iceberg features like time travel, schema evolution, and partition management.

## Next Steps

To continue with more advanced data loading methods, explore the other submodules in this module:

- [Load Data into Iceberg Table Using Spark DataFrames](load_iceberg_tbl_SparkDF.md)
