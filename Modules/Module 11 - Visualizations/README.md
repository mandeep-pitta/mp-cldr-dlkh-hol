# Module 11 - Visualizations

## Overview

In this module, we will explore how to create visualizations using **Apache Iceberg** and **Hive** tables in **Cloudera Data Visualization (CDV)**. This module showcases how to combine Iceberg tables with existing Hive tables in CDV, allowing for gradual table migrations while maintaining analytics capabilities.

### Key Concepts

#### 1. Combining Iceberg and Hive Tables

- Learn how to create dashboards that integrate both Iceberg and Hive tables, supporting a phased approach to migrating tables to Iceberg.

#### 2. Airline Dashboard Example

- Explore the **Airline Dashboard** in CDV, which uses Iceberg tables (flights, planes, airports) and a Hive table (unique\_tickets) within a single visualization.

#### 3. Exploring Data Models

- Understand how to navigate the data model in CDV to identify the source table formats (Iceberg or Hive).

#### 4. Verifying Table Formats

- Use the `DESCRIBE FORMATTED` query in Impala to confirm whether a table is in Iceberg or Hive format.

### Methods Covered in This Module

#### 1. Visualizing Mixed Table Formats

Learn how to use CDV to create visualizations that combine Iceberg and Hive tables. The example focuses on the Airline Dashboard, showing how to work with mixed table formats.

#### 2. Verifying Table Formats Using Impala

Verify the formats of Iceberg and Hive tables using the `DESCRIBE FORMATTED` query in Impala.

### Key Takeaways

- CDV allows for the creation of dashboards that combine Iceberg and Hive tables, enabling phased migrations.
- You can easily verify the table formats (Iceberg or Hive) through Impala queries.
- Iceberg provides flexibility in data management without needing to convert all tables at once, allowing for gradual adoption.

> **Note**: Replace `${prefix}` with your user ID throughout the process.

## Submodules

`01` [Query Using Data Viz](query_iceberg_and_hive_single_query_DV.md)
