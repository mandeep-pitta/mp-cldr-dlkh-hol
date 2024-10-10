# Load Data into Iceberg Table Using SQL

## Overview

This submodule provides a step-by-step guide for loading data into an Iceberg table using SQL on the Cloudera Data Platform (CDP). By following these steps, you'll learn how to efficiently insert data from an external source (such as a CSV file) into an Iceberg table, ensuring that your data is stored in a scalable and performant format.

## Prerequisites

Before starting, ensure you have:

- Access to Cloudera Data Warehouse (CDW) HUE.
- Proper permissions to execute SQL commands in the Hive Virtual Warehouse (VW).
- Your `${prefix}` (e.g., your User ID) ready for use in the queries.

## Step-by-Step Guide

### Step 1: Insert Data into the Iceberg Table

Use the `INSERT INTO` statement to load data from a CSV file into your Iceberg table. This example demonstrates loading data from the `flights_csv` table into the `flights` Iceberg table. The data is filtered to include only records for years up to 2006.

``` sql
INSERT INTO ${prefix}_airlines.flights
SELECT * FROM ${prefix}_airlines_csv.flights_csv
WHERE year <= 2006;
```

**Note:** This operation may take a few minutes to complete, depending on the size of the data.

### Step 2: Verify the Data Load

Once the data load is complete, run the following query to verify that the data has been correctly inserted into the Iceberg table. This query counts the number of flights for each year and orders the results in descending order.

``` sql
SELECT year, count(*)
FROM ${prefix}_airlines.flights
GROUP BY year
ORDER BY year DESC;
```

### Summary

You have successfully loaded data into an Iceberg table using SQL. The data is now stored in a scalable, performant format that supports advanced Iceberg features like time travel, schema evolution, and partition management.

## Next Steps

To continue with more advanced data loading methods, explore the other submodules in this module:

- [Load Data into Iceberg Table Using Spark SQL](load_iceberg_tbl_SparkSQL.md)
- [Load Data into Iceberg Table Using Spark DataFrames](load_iceberg_tbl_SparkDF.md)
