# ACID Merge with Spark SQL in CML

## Overview

In this submodule, we will demonstrate how to perform an ACID `MERGE` operation using Spark SQL in Cloudera Machine Learning (CML). This showcases Iceberg's multi-engine capabilities by running ACID transactions in a PySpark environment within CML.

## Step-by-Step Guide

### Step 1. Create a CML Project

1. Open your CML workspace and create a new project.
   - **Project Name**: `${prefix}-iceberg-project` (replace `${prefix}` with your user ID).
   - **Template**: Select **Python** from the dropdown.
   - **Kernel**: Set to **Python 3.7**.

2. In the left navigation, click **Files**, and then create a new file:
   - **File Name**: `iceberg_acid.py`
   - Check **Open in Editor**.

	![Create File](../../images/66.png)

### Step 2. Start a CML Session

1. Start a new session in the Workbench:
   - **Name**: `iceberg-acid-session`
   - Enable **Spark** and select **Spark 3.2.0**.

	![Start Session](../../images/67.png)

2. Add the connection snippet for **Spark Data Lake** to the session.

	![Connection Snippet](../../images/69.png)

### Step 3. Perform the ACID Merge

1. Copy and paste the following code into your Workbench Editor (replacing `${prefix}` with your user ID) to:
   - Create an Iceberg table.
   - Load data into the table.
   - Perform an ACID `MERGE` to update a record.
  
```
    ### Code to add
    # Replace <prefix> with your user ID in the following code

    # Query Raw Data Table
    spark.sql("SELECT * FROM ${prefix}_airlines_csv.airlines_csv limit 5").show()

    # Create Iceberg Table
    spark.sql("CREATE EXTERNAL TABLE ${prefix}_airlines.airlines (code string, description string) USING ICEBERG TBLPROPERTIES ('format-version' = '2')")

    # Load Data into Iceberg Table
    spark.sql("INSERT INTO ${prefix}_airlines.airlines SELECT * FROM ${prefix}_airlines_csv.airlines_csv")

    # Review Results to ensure record was updated
    spark.sql("SELECT * FROM ${prefix}_airlines.airlines WHERE code ='UA'").show()

    # ICEBERG ACID - Change row for UA (United Airlines) to reflect new name of Adrenaline Airways
    spark.sql('MERGE INTO ${prefix}_airlines.airlines s USING (SELECT t.code, "Adrenaline Airways" AS description FROM ${prefix}_airlines.airlines t WHERE t.code = "UA") source \
    ON s.code = source.code \
    WHEN MATCHED AND s.description <> source.description THEN UPDATE SET s.description = source.description \
     ')
```

2. After pasting the code, click **Run > Run All** to execute the script.

	![Run All](../../images/71.png)

3. Review the session output to verify that the data has been successfully updated.

	![Session Output](../../images/72.png)

## Summary

In this submodule, you learned how to perform an ACID `MERGE` operation using Spark SQL in CML. You successfully created an Iceberg table, loaded data into it, and performed an ACID transaction to update records, showcasing Iceberg’s multi-engine and multi-function support.

## Next Steps

To continue your journey with Iceberg, consider exploring these related modules:

- **[Module 08 - Schema Evolution](module_08.md)**: Learn how to adapt your Iceberg table schema as your data evolves, without breaking existing queries.
- **[Module 09 - Security](module_09.md)**: Implement robust security measures to control access to your Iceberg tables and safeguard your data.
