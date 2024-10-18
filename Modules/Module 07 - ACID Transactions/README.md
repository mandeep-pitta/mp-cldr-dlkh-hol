# Module 07 - ACID Transactions

## Overview

This module demonstrates the use of **ACID transactions** with Iceberg tables in Cloudera Data Platform (CDP), using the `MERGE` statement in both SQL and Spark SQL. The `MERGE` statement enables the combination of insert, update, and delete operations into a single command, ensuring data consistency and integrity in the Iceberg table.

You will learn how to run an ACID `MERGE` operation using both the SQL interface in Hue and PySpark in Cloudera Machine Learning (CML), showing Iceberg's multi-engine and multi-function capabilities.

### Prerequisites

Before proceeding, ensure the following:

- You have access to Iceberg tables in CDP.
- You can access Hue for SQL queries and CML for Spark queries.
- You have the necessary permissions to run Spark and SQL jobs.
  
### What You'll Learn

By the end of this module, you will be able to:

- Perform ACID transactions on Iceberg tables using the `MERGE` statement.
- Use SQL to run `MERGE` commands in Hue (Hive Virtual Warehouse).
- Use Spark SQL to run `MERGE` commands in Cloudera Machine Learning (CML).
- Understand how Iceberg enables reliable data updates within its tables, leveraging its ACID capabilities.

### Methods Covered in This Module

#### ACID With Iceberg Merge in SQL  
   This submodule demonstrates how to use the SQL `MERGE` command in Hue to perform ACID transactions on an Iceberg table. You will learn how to:
   - Create and load an Iceberg table.
   - Run a `MERGE` command to insert, update, and delete data.
   - Review the results of the ACID transaction.

   [Go to Submodule 01 - ACID With Iceberg Merge (SQL)](acid_merge_SQL.md)

#### ACID With Iceberg Merge in Spark SQL  
   This submodule demonstrates how to use Spark SQL in CML to perform ACID transactions on an Iceberg table. You will learn how to:
   - Set up a CML project and session for running PySpark code.
   - Create and load an Iceberg table using Spark SQL.
   - Perform a `MERGE` operation to update specific records.

   [Go to Submodule 02 - ACID With Iceberg Merge (Spark SQL)](acid_merge_SparkSQL.md)

### Key Takeaways

This module showcases Iceberg’s ACID transaction capabilities, using the `MERGE` statement to handle inserts, updates, and deletes within Iceberg tables. It highlights Iceberg’s multi-engine and multi-function support by demonstrating how ACID transactions can be performed using both SQL (in Hue) and Spark SQL (in CML).

As always, remember to replace `${prefix}` with your actual user ID throughout the process.

## Submodules

- `01` [ACID With Iceberg Merge (SQL)](acid_merge_SQL.md)
- `02` [ACID With Iceberg Merge (Spark SQL)](acid_merge_SparkSQL.md)
