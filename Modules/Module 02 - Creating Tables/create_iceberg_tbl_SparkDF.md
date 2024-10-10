# Create Iceberg Table Feature - Spark DataFrame

## Overview

This submodule guides you through creating a partitioned Iceberg table using Spark DataFrames within a Cloudera Data Engineering (CDE) session. This approach leverages Spark DataFrames to define and manage Iceberg tables, providing flexibility in data handling and efficient query performance.

## Prerequisites

Before starting, ensure you have:

- Access to a Cloudera Data Engineering (CDE) session.
- Proper permissions to execute Spark commands.
- Your `${prefix}` (e.g., your User ID) ready for use in the code.

## Step-by-Step Guide

### Step 1: Define the Schema

First, define the schema for the `flights` table using Spark’s `StructType` and `StructField`. Replace `<prefix>` with your unique value (e.g., your User ID).

``` python
from pyspark.sql.types import StructField, StructType, IntegerType, StringType

# VARIABLES - change "<prefix>"
prefix = "<prefix>"
odl_database_name = prefix + "_airlines"

flightsSchema = StructType([
    StructField("month", IntegerType()),
    StructField("dayofmonth", IntegerType()),
    StructField("dayofweek", IntegerType()),
    StructField("deptime", IntegerType()),
    StructField("crsdeptime", IntegerType()),
    StructField("arrtime", IntegerType()),
    StructField("crsarrtime", IntegerType()),
    StructField("uniquecarrier", StringType()),
    StructField("flightnum", IntegerType()),
    StructField("tailnum", StringType()),
    StructField("actualelapsedtime", IntegerType()),
    StructField("crselapsedtime", IntegerType()),
    StructField("airtime", IntegerType()),
    StructField("arrdelay", IntegerType()),
    StructField("depdelay", IntegerType()),
    StructField("origin", StringType()),
    StructField("dest", StringType()),
    StructField("distance", IntegerType()),
    StructField("taxiin", IntegerType()),
    StructField("taxiout", IntegerType()),
    StructField("cancelled", IntegerType()),
    StructField("cancellationcode", StringType()),
    StructField("diverted", StringType()),
    StructField("carrierdelay", IntegerType()),
    StructField("weatherdelay", IntegerType()),
    StructField("nasdelay", IntegerType()),
    StructField("securitydelay", IntegerType()),
    StructField("lateaircraftdelay", IntegerType()),
    StructField("year", IntegerType())
])
```

### Step 2: Create the Iceberg Table

Next, use the schema to create a new partitioned Iceberg table named `flights`. The table will be partitioned by the `year` column and stored in the Iceberg format.

``` python
# --- flights Iceberg Table partitioned PARQUET file format
spark_df = spark.createDataFrame([], flightsSchema)

spark_df.writeTo(f"{odl_database_name}.flights").using("iceberg").partitionedBy("year").tableProperty("format-version","2").createOrReplace()
```

### Step 3: Verify the Table Schema

After creating the table, verify the schema to ensure it has been correctly defined:

``` python
# SHOW TABLE SCHEMA
spark_df.printSchema()
```

### Step 4: Check the Partitioning and Table Format

Check the table's partitioning and format to confirm it has been successfully set up as an Iceberg table.

```python
# CHECK PARTITION - list of columns (returns 'year')
spark_df = spark.sql(f"DESCRIBE FORMATTED {odl_database_name}.flights")
spark_df.filter(spark_df.col_name.isin(['Part 0', 'Part 1', 'Part 2'])).show()

# CHECK TABLE FORMAT (returns 'iceberg')
(spark.sql(f"DESCRIBE FORMATTED {odl_database_name}.flights").filter("col_name=='Provider'").collect()[0].data_type)
```

**Note:** In the output, look for the correct partitioning by `year` and ensure that the table is stored using the Iceberg format with the appropriate properties.

TODO: Placeholder for Image: ../../images/.png

### Summary

You have successfully created a partitioned Iceberg table using Spark DataFrames in a CDE session. This table is now ready to be populated with data and utilized for efficient querying and data management.

## Next Steps

To continue, select one of the following modules or submodules based on your requirements:

- [Module 03 - Loading Data: Load Iceberg Table Using SQL](load_iceberg_tbl_SQL.md)
- [Module 13 - Loading New Data to Flights Using DataFrame](load_new_data_to_flights_DF.md)

