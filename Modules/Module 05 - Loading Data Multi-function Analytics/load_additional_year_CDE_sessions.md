# Load an Additional Year of Data Using Spark SQL

## Overview

This submodule demonstrates how to use Apache Spark in Cloudera Data Engineering (CDE) to load an additional year of data (2008) into an Iceberg table. You will execute a spark sql using CDE Sessions that reads data from a CSV file stored in AWS S3, filters the data for a specific year, and inserts it into the existing Iceberg table.

The goal is to showcase Iceberg's multi-engine capabilities, specifically highlighting Spark for data manipulation and Impala for querying the results in Cloudera Data Warehouse (CDW/Hue).

## Prerequisites

Before running this submodule, ensure that:

- You have access to a Cloudera Data Engineering (CDE) virtual cluster with Spark capabilities.
- You have set up Kerberos credentials to access AWS S3 cloud storage.
- The Iceberg table (`flights`) was created in earlier steps using CDW/Hue (Hive).
- You have installed an IDE or text editor (e.g., VS Code) to modify the Python script.

## Step-by-Step Guide

## Step1
Go to Cloudera Data Engineering and click on "New Session"
<img width="1092" alt="image" src="https://github.com/user-attachments/assets/d67e60d8-4edf-4447-9472-790a6548a6d6">

## Step2
Create a session "<prefix>_IcebergAdd2008_Session"
<img width="704" alt="image" src="https://github.com/user-attachments/assets/70e0cd30-8482-46c2-852e-286351472d62">

## Step3
Once this is created click on Interact to use Spark Shell commands.
```
from pyspark.sql import SparkSession
from pyspark.sql.functions import *
import pyspark.sql.functions as F
```
Replace <prefix> with your desired prefix

```
print("JOB STARTED...")
spark.sql("INSERT INTO <prefix>_airlines.flights SELECT * FROM <prefix>_airlines_csv.flights_csv WHERE year = 2008 ")
print("JOB COMPLETED.\n\n")
```

### Step 4: Verify the Data in CDW/Hue

Once the Spark job completes, verify that the data has been added to the Iceberg table using Impala in CDW/Hue.

1. In CDW/Hue, execute the following query to check the record count for the year 2008:
   ```
   SELECT year, count(*)
   FROM ${prefix}_airlines.flights
   GROUP BY year
   ORDER BY year desc;
   ```

2. You should see the records for the year 2008 along with data for the previous years.

   ![Query Results](../../images/64.png)

## Conclusion

This submodule demonstrated how to use Spark in Cloudera Data Engineering to load data into an Iceberg table. You have successfully inserted data for an additional year (2008) and verified the results using CDW/Hue. This process highlights Iceberg’s multi-engine capabilities, enabling both Spark-based data manipulation and Impala querying for analysis.

## Next Steps

Continue exploring more advanced functionality with Iceberg and Spark, or return to the main module for additional exercises and insights.
