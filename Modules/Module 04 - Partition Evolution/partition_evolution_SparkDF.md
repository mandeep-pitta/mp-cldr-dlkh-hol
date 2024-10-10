# Partition Evolution Using Spark DataFrame

## Overview

In this submodule, we’ll explore in-place partition evolution using Spark DataFrames within a Cloudera Data Engineering (CDE) session. Partition evolution allows you to modify the partitioning strategy of your tables with minimal data movement, enhancing performance and scalability.

## Prerequisites

Before starting, ensure you have:

- Access to a Cloudera Data Engineering (CDE) session.
- Proper permissions to execute Spark commands.
- Your `${prefix}` (e.g., your User ID) ready for use in the code.

## Step-by-Step Guide

### Step 1: Set Up Variables

Begin by setting up your environment variables. Replace `<prefix>` with your unique value (e.g., your User ID).

``` python
from pyspark.sql.functions import col

# Variables - replace <prefix> with your user id
prefix = "<prefix>"
csv_database_name = prefix + "_airlines_csv"
odl_database_name = prefix + "_airlines"
```

### Step 2: Check Current Partitioning

Before evolving the partition, check the current partitioning strategy of the `flights` table. This will confirm that the table is currently partitioned by year.

``` python
# CHECK TABLE FORMAT - before in-place partition evolution (will return 'year')
spark_df = spark.sql(f"DESCRIBE FORMATTED {odl_database_name}.flights")
spark_df.filter(spark_df.col_name.isin(['Part 0', 'Part 1', 'Part 2'])).show()
```

### Step 3: Evolve the Partition In-Place

Use Spark DataFrames to add another column (`month`) to the partitioning strategy. This operation happens in-place, improving performance without moving any existing data.

``` python
# EVOLVE PARTITION IN-PLACE & WRITE DATA USING NEW PARTITION (single DF statement) - add another column to partition to improve performance
spark.sql(f"ALTER TABLE {odl_database_name}.flights ADD PARTITION FIELD month").show()
```

> **Note**: This ALTER TABLE operation happens in-place, so no data is manipulated, and the existing data remains indexed by year.

### Step 4: Verify the New Partitioning

After evolving the partition, verify that the table is now partitioned by both year and month.

``` python
# CHECK TABLE FORMAT - after partition evolution (will return 'year', 'month')
spark_df = spark.sql(f"DESCRIBE FORMATTED {odl_database_name}.flights")
spark_df.filter(spark_df.col_name.isin(['Part 0', 'Part 1', 'Part 2'])).show()
```

> **Note**: In the output, look for the Partition Spec to confirm the table is now partitioned by year and month.

TODO: Placeholder for Image: ../../images/.png

### Step 5: Load and Write Data Using Spark DataFrames

To leverage the new partitioning strategy, load data for the year 2007 and write it to the `flights` table using Spark DataFrames.

``` python
# READ 2007 DATA
spark_df = spark.read.table(f"{csv_database_name}.flights_csv").where(col("year").isin([2007]))

# WRITE 2007 DATA TO TABLE
spark_df.writeTo(f"{odl_database_name}.flights").using("iceberg").append()
```

### Step 6: Verify the Data Load

After loading the data, run a query to verify that the data has been correctly inserted into the Iceberg table and is organized by year.

``` python
# CHECK RESULTS
spark.read.table(f"{odl_database_name}.flights").groupBy(col("year")).count().orderBy(col("year"), ascending=False).show()
```

### Step 7: Query the Iceberg Table Using Impala

Switch to Impala to query the Iceberg table and analyze the benefits of the new partitioning strategy.

1. First, run the following query to analyze the data for the year 2006 (which uses the original year-only partition).

``` sql
-- RUN EXPLAIN PLAN ON THIS QUERY
SELECT year, month, count(*)
FROM ${prefix}_airlines.flights
WHERE year = 2006 AND month = 12
GROUP BY year, month
ORDER BY year desc, month asc;
```

2. Next, run the following query to analyze the data for the year 2007 (which uses the new year and month partition).

``` sql
-- RUN EXPLAIN PLAN ON THIS QUERY; AND COMPARE RESULTS
SELECT year, month, count(*)
FROM ${prefix}_airlines.flights
WHERE year = 2007 AND month = 12
GROUP BY year, month
ORDER BY year desc, month asc;
```

### Step 8: Analyze the Explain Plans

After running the queries, use the EXPLAIN feature in HUE to analyze the performance of each query.

1. Highlight the first `SELECT` statement up to the `;` and click on the EXPLAIN button. Scroll down to the bottom of the Explain tab to review the results.

    ![52.png](../../images/52.png)

    ![54.png](../../images/54.png)

2. Next, highlight the second `SELECT` statement up to the `;` and click on the EXPLAIN button again. Scroll down to the bottom of the Explain tab to review the results.

    ![56.png](../../images/56.png)

    ![57.png](../../images/57.png)

> **Explanation**: When comparing the Explain Plans, you'll observe that the query for `year=2006` (using the year partition) scans one partition (~120MB) even though it also filters on the month. However, the query for `year=2007` (using the year and month partition) only scans one month of data, which is one partition of about 9MB. This results in a significant performance boost.

**Query for year=2006**                                             **Query for year=2007**

![58.png](../../images/58.png)

### Summary

You have successfully evolved the partitions of your Iceberg table in-place using Spark DataFrames and demonstrated the performance benefits of optimized partitioning with Impala. This process allows you to maintain scalability and performance as your data evolves.

## Next Steps

Having completed Module 04, you're now ready to explore more advanced features and functionalities of Iceberg tables. Here are some recommended modules to continue your learning:

- **[Module 05 - Loading Data Multi-function Analytics](Module%2005%20-%20Loading%20Data%20Multi-function%20Analytics/README.md):** Explore advanced data loading techniques to support various analytics use cases across multiple services.
  
- **[Module 06 - Time Travel](Module%2006%20-%20Time%20Travel/README.md):** Leverage Iceberg's time travel capabilities to query historical data at specific points in time, enabling powerful analytics and audits.

- **[Module 07 - ACID Transactions](Module%2007%20-%20ACID/README.md):** Learn how Iceberg ensures data consistency and integrity through ACID transactions within your tables.

These modules will build on the foundational knowledge you've gained and introduce you to more sophisticated data management techniques within the Iceberg framework.
