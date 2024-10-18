# Module 05 - Multi-Function Analytics with Iceberg and Spark

## Overview

In this module, you will learn how to use Apache Spark on Cloudera Data Engineering (CDE) to perform multi-function analytics with Iceberg tables on the Cloudera Data Platform (CDP). Iceberg’s engine-agnostic nature allows for seamless interaction with different compute engines. This module focuses on using Spark to add data to an existing Iceberg table, continuing from the previous demos with Cloudera Data Warehouse (CDW) and Hue.

You will gain hands-on experience running a Spark job in CDE to load additional data into an Iceberg table and verify the data using Impala in CDW/Hue.

### Prerequisites

Before proceeding, ensure that the following prerequisites are met:

- You have completed the previous modules where you created the Iceberg table using CDW (Hive).
- You have access to a Cloudera Data Engineering (CDE) virtual cluster and the ability to run Spark jobs.
- You have the necessary credentials (Kerberos) to access cloud storage (AWS S3) where the data is stored.
- The Python script for loading data into Iceberg is prepared, and you are familiar with the basic usage of Spark and CDW.

### What You'll Learn

By the end of this module, you will be able to:

- Use Apache Spark on CDE to load data into Iceberg tables.
- Understand how to configure and run Spark jobs in Cloudera Data Engineering.
- Verify data insertion using Impala queries in CDW/Hue.
- Demonstrate Iceberg’s multi-engine capability, showcasing Spark and Impala for data manipulation and querying.

### Methods Covered in This Module

**Load an Additional Year of Data Using Spark SQL**  
   This submodule demonstrates how to use Spark in CDE to load an additional year of data (2008) into the Iceberg table created in earlier steps. You will learn how to:
   - Set up and run a Spark job using a Python script that reads data from a CSV file stored in AWS S3.
   - Filter the data for a specific year and insert it into the Iceberg table.
   - Use CDW/Hue (Impala) to verify that the data has been successfully loaded.

   [Go to Submodule 01 - Load an Additional Year of Data Using Spark SQL](load_additional_year_DE.md)

### Key Takeaways

This module showcases how Spark can be integrated with Iceberg to perform multi-function analytics, further demonstrating Iceberg's flexibility and engine-agnostic nature. The use of both Spark (for data manipulation) and Impala (for querying) highlights the power of the Cloudera Data Platform for handling complex data workflows.

As always, remember to replace `${prefix}` with your actual user ID throughout the process.

## Submodules

To continue, proceed to the submodule below:

- `01` [Load an Additional Year of Data Using Spark SQL](load_additional_year_DE.md)
