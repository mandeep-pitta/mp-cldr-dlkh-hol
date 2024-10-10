# Module 10 - Visualizations

## Visualizations with Iceberg and Hive Tables

This module explores using Apache Iceberg tables alongside existing Hive tables for data visualization in Cloudera Data Visualization (CDV).

**Combining Iceberg and Hive Tables:**

The example showcases an Airline Dashboard that leverages both Iceberg tables (flights, planes, airports) and a Hive table (unique\_tickets) from the same database. This highlights that:

- You can gradually migrate tables to Iceberg format when it makes sense for your specific needs.
- CDV can effectively work with mixed Iceberg and Hive table formats within a single dashboard.

**Exploring the Data Model:**

The guide instructs you to navigate the CDV interface to explore the "Airlines Lakehouse" dataset and its data model. This helps you identify the sources (Iceberg vs. Hive) for the tables used in the Airline Dashboard.

**Verifying Table Formats:**

While you've already encountered Iceberg tables in previous modules, one table (unique\_tickets) remains in Hive format. You can confirm this using a DESCRIBE statement in Impala.

**Optional: Single Query with Mixed Formats:**

The module mentions the possibility of using CDV dashboards to create visualizations that combine data from Iceberg and Hive tables within a single query. An example DESCRIBE statement is provided for illustrative purposes.

Remember to replace `${user_id}` with your actual user ID throughout the process.

To begin, select the sub-module below:

## Submodules

`01` [Query Using Data Viz](query_iceberg_and_hive_single_query_DV.md)