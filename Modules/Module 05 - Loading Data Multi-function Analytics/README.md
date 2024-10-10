## Module 05 - Multi-Function Analytics with Iceberg and Spark

## Load An Additional Year of Data Using Spark SQL

This module demonstrates using Apache Spark for data manipulation with Iceberg tables on the Cloudera Data Platform (CDP). Iceberg's engine-agnostic nature allows interaction with various engines, including Spark.

**Adding Data Using Spark SQL:**

The example provides a Python script that utilizes Spark SQL to insert data into an existing Iceberg table. The script accomplishes this by:

- Establishing a Spark session for interacting with Spark functionalities.
- Defining a Spark SQL statement that:
    - Reads data from a CSV file stored in cloud storage (AWS S3 is used here).
    - Filters the data to include records for a specific year.
    - Inserts the filtered data into the target Iceberg table (`flights`).

**Running the Spark Job in CDE:**

The guide outlines the process for running the Spark script within CDP:

- You'll save the script as a Python file.
- In CDP's virtual cluster environment, you'll create a new Spark job using the script as the application file.
- Configuration details like Kerberos access for cloud storage will be specified.
- The job can then be submitted for execution.

**Verifying Data Load (CDW/Hue):**

Once the Spark job finishes successfully, you can use a query in CDW/Hue (Impala) to confirm that the data for the new year has been loaded into the `flights` Iceberg table.

This module showcases how Spark can be a valuable tool for working with Iceberg tables on CDP, enabling data manipulation tasks beyond the capabilities of the Iceberg query engine itself.

Remember to replace `${user_id}` with your actual user ID throughout the process.

To begin, select the sub-module below:

## Submodules

`01` [Load an Additional Year of Data](load_additional_year_DE.md)