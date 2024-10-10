# Module 08 - ACID

## ACID Transactions with Iceberg and Spark

The module demonstrates an ACID operation using Spark SQL's `MERGE` statement on an Iceberg table (`airlines`). The `MERGE` statement combines data manipulation operations like insert, update, and delete into a single operation. Here's how it achieves the update:

1. Matches rows in the target Iceberg table (`airlines`) with rows from a source table containing the update (code: "UA", description: "Adrenaline Airways").
2. For matched rows where the description differs, it updates the description in the Iceberg table with the value from the source table.

**Running the Spark Script in CML:**

The guide outlines steps to run a PySpark script in CML that demonstrates ACID transactions with Iceberg tables:

- Create a CML project with Python 3.7 kernel and Spark 3.2.0 enabled.
- Create a Python file and connect to a Spark Data Lake connection.
- The provided script:
    - Queries a raw data table.
    - Creates an Iceberg table.
    - Loads data into the Iceberg table.
    - Performs an ACID update using `MERGE` to modify a specific record.
    - Verifies the update in the Iceberg table.

This module highlights how Iceberg's ACID capabilities and Spark SQL's `MERGE` statement enable reliable data updates within Iceberg tables.

Remember to replace `${user_id}` with your actual user ID throughout the process.

To begin, select the sub-module below:

## Submodules

`01` [ACID With Iceberg Merge](merge_spark_ML.md)