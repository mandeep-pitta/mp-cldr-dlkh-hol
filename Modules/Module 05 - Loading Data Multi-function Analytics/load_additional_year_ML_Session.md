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
import cml.data_v1 as cmldata

# Sample in-code customization of spark configurations
#from pyspark import SparkContext
#SparkContext.setSystemProperty('spark.executor.cores', '1')
#SparkContext.setSystemProperty('spark.executor.memory', '2g')

CONNECTION_NAME = "cdp-acxiom-hol-aw-dl"
conn = cmldata.get_connection(CONNECTION_NAME)
spark = conn.get_spark_session()

# Sample usage to run query through spark
EXAMPLE_SQL_QUERY = "show databases"
spark.sql(EXAMPLE_SQL_QUERY).show()

### Code to add
# Replace <prefix> with your user ID in the following code
prefix = <prefix>


# Query Raw Data Table
spark.sql("SELECT * FROM "+ prefix +"_airlines_csv.airlines_csv limit 5").show()

# Create Iceberg Table
spark.sql("CREATE EXTERNAL TABLE "+ prefix +"_airlines.airlines (code string, description string) USING ICEBERG TBLPROPERTIES ('format-version' = '2')")

# Load Data into Iceberg Table
spark.sql("INSERT INTO "+ prefix +"_airlines.airlines SELECT * FROM "+ prefix +"_airlines_csv.airlines_csv")

# Review Results to ensure record was updated
spark.sql("SELECT * FROM "+ prefix +"_airlines.airlines WHERE code ='UA'").show()

# ICEBERG ACID - Change row for UA (United Airlines) to reflect new name of Adrenaline Airways
spark.sql('MERGE INTO ' + prefix + '_airlines.airlines s USING (SELECT t.code, "Adrenaline Airways" AS description FROM '+ prefix + '_airlines.airlines t  WHERE t.code = "UA") source ON s.code = source.code WHEN MATCHED AND s.description <> source.description THEN UPDATE SET s.description = source.description')


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
