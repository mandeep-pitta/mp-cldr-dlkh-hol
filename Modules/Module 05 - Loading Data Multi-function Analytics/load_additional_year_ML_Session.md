# Load an Additional Year of Data Using Spark AI/ML Session

## Overview

This submodule demonstrates how to use Apache Spark in Cloudera Data Engineering (CDE) to load an additional year of data (2008) into an Iceberg table. You will execute a Python script that reads data from a CSV file stored in AWS S3, filters the data for a specific year, and inserts it into the existing Iceberg table.

The goal is to showcase Iceberg's multi-engine capabilities, specifically highlighting Spark for data manipulation and Impala for querying the results in Cloudera Data Warehouse (CDW/Hue).

## Step-by-Step Guide

### Step 1. Create a CML Project

1. Open your CML workspace and create a new project.
   - **Project Name**: `${prefix}-iceberg-project` (replace `${prefix}` with your user ID).
   - **Template**: Select **Python** from the dropdown.
   - **Kernel**: Set to **Python 3.7**.

2. In the left navigation, click **Files**, and then create a new file:
   - **File Name**: `IcebergAdd2008.py`
   - Check **Open in Editor**.

	![Create File](../../images/66.png)

### Step 2. Start a CML Session

1. Start a new session in the Workbench:
   - **Name**: `iceberg-Add2008-session`
   - Enable **Spark** and select **Spark 3.2.0**.

	![Start Session](../../images/67.png)

2. Add the connection snippet for **Spark Data Lake** to the session.

	![Connection Snippet](../../images/69.png)

### Step 3. Perform the Add Additional 2008 Year Data

1. Copy and paste the following code into your Workbench Editor (replacing `${prefix}` with your user ID) to:
   - Create an Iceberg table.
   - Load data into the table.
   - Perform add additional 2008 year data.
  
```
#****************************************************************************
# 
#  ICEBERG (Multi-function Analytics) - LOAD DATA  into table created in CDW
#
#***************************************************************************/
from pyspark.sql import SparkSession
from pyspark.sql.functions import *
import pyspark.sql.functions as F
import cml.data_v1 as cmldata
#---------------------------------------------------
#               CREATE SPARK SESSION
#---------------------------------------------------

#-----------------------------------------------------------------------------------
# LOAD DATA 1 YEAR (2008) FROM RAW DATA CSV FILES ON AWS S3 CLOUD STORAGE
#          A  TABLE IS ALREADY CREATED ON TOP OF THE CSV FILE
#          RUN INSERT INTO ICEBERG TABLE FROM THE RAW CSV TABLE
#
#-----------------------------------------------------------------------------------


CONNECTION_NAME = "cdp-acxiom-hol-aw-dl"
conn = cmldata.get_connection(CONNECTION_NAME)
spark = conn.get_spark_session()

# Sample usage to run query through spark
EXAMPLE_SQL_QUERY = "show databases"
spark.sql(EXAMPLE_SQL_QUERY).show()

### Code to add
# Replace <prefix> with your user ID in the following code
prefix = "user094"

print("JOB STARTED...")
spark.sql("INSERT INTO " + prefix + "_airlines.flights SELECT * FROM " + prefix +"_airlines_csv.flights_csv WHERE year = 2008 ")

print("JOB COMPLETED.\n\n")

```

2. After pasting the code, click **Run > Run All** to execute the script.

	![Run All](../../images/71.png)

3. Review the session output to verify that the data has been successfully updated.

	![Session Output](../../images/72.png)

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
