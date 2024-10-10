# Create Iceberg Table Feature - SparkSQL

## Overview

This submodule guides you through creating a partitioned Iceberg table using SparkSQL within a Cloudera Data Engineering (CDE) session. This approach leverages SparkSQL to define and manage Iceberg tables, allowing for efficient data storage and querying with advanced features like partitioning and schema management.

## Prerequisites

Before starting, ensure you have:

- Access to a Cloudera Data Engineering (CDE) session.
- Proper permissions to execute SparkSQL commands.
- Your `${prefix}` (e.g., your User ID) ready for use in the code.

## Step-by-Step Guide

### Step 1: Set Up Variables

Begin by setting up your environment variables. Replace `<prefix>` with your unique value (e.g., your User ID).

``` python
# VARIABLES - change "<prefix>"
prefix = "<prefix>"
odl_database_name = prefix + "_airlines"

flights_cols_1 = "month int, dayofmonth int, dayofweek int, deptime int, crsdeptime int, arrtime int, crsarrtime int, "
flights_cols_2 = "uniquecarrier string, flightnum int, tailnum string, actualelapsedtime int, crselapsedtime int, "
flights_cols_3 = "airtime int, arrdelay int, depdelay int, origin string, dest string, distance int, taxiin int, taxiout int, "
flights_cols_4 = "cancelled int, cancellationcode string, diverted string, carrierdelay int, weatherdelay int, nasdelay int, securitydelay int, lateaircraftdelay int"
flights_cols = flights_cols_1 + flights_cols_2 + flights_cols_3 + flights_cols_4

flights_part_cols = "year int"
```

### Step 2: Create the Iceberg Table

Execute the following SparkSQL commands to create a new partitioned Iceberg table named `flights`. This table will be partitioned by the `year` column and stored in the Iceberg format.

``` python
# --- flights Iceberg Table partitioned PARQUET file format
tblprop = "TBLPROPERTIES('format-version'='2')"
partitioned_by = f"PARTITIONED BY ({flights_part_cols})"

spark.sql(f"drop table if exists {odl_database_name}.flights").show()

spark.sql(f"CREATE TABLE {odl_database_name}.flights ({flights_cols}) USING ICEBERG {partitioned_by} {tblprop}").show()
```

### Step 3: Verify the Table Creation

After creating the table, it’s important to verify that the table has been created with the correct schema and properties. Run the following commands to see the table's creation details and partitioning information:

``` python
spark.sql(f"SHOW CREATE TABLE {odl_database_name}.flights").show()

# CHECK PARTITION - list of columns (returns 'year')
spark_df = spark.sql(f"DESCRIBE FORMATTED {odl_database_name}.flights")
# ---- show all metadata
spark_df.show(100, truncate=False)
# ---- show partition details only
spark_df.filter(spark_df.col_name.isin(['Part 0', 'Part 1', 'Part 2'])).show()
```

### Step 4: Check the Table Format

Finally, ensure that the table is stored using the Iceberg format by checking the table's provider.

``` python
# CHECK TABLE FORMAT (returns 'iceberg')
(spark.sql(f"DESCRIBE FORMATTED {odl_database_name}.flights").filter("col_name=='Provider'").collect()[0].data_type)
```

**Note:** In the output, look for the correct partitioning by `year` and ensure that the table is stored using the Iceberg format with the appropriate properties.

TODO: Placeholder for Image: ../../images/.png

### Summary

You have successfully created a partitioned Iceberg table using SparkSQL in a CDE session. This table is now ready to be populated with data and utilized for efficient querying and data management.

## Next Steps

To continue, select one of the following modules or submodules based on your requirements:

- [Module 03 - Loading Data: Load Iceberg Table Using SQL](load_iceberg_tbl_SQL.md)
- [Module 13 - Loading New Data to Flights Using DataFrame](load_new_data_to_flights_DF.md)

