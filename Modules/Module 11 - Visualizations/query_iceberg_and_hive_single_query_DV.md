# Visualizing Iceberg and Hive Tables in CDV

## Overview

In this submodule, we will explore how to use **Cloudera Data Visualization (CDV)** to create visualizations that combine Iceberg and Hive tables within the same dashboard. This flexibility allows you to migrate tables to Iceberg over time, while still maintaining the ability to analyze and visualize data across both table formats.

## Step-by-Step Guide

### Step 1: Explore the "Airline Dashboard"

1. Open the **VISUALS** tab in CDV.
2. Select the **Airline Dashboard** to explore how the dashboard integrates Iceberg and Hive tables.

   ![75.png](../../images/75.png)

- **Value**: CDV allows you to combine Iceberg and Hive table formats in a single visualization, enabling gradual migration without disrupting analytics.

### Step 2: Explore the Data Model

1. Click on the **DATA** tab and select the **Airlines Lakehouse** dataset.
2. Navigate to the **Data Model** section to identify the source tables for the dashboard.

   ![30.png](../../images/30.png)

3. Review the tables, including **unique_tickets** (Hive table) and **flights** (Iceberg table).

   ![31.png](../../images/31.png)

### Step 3: Verify Table Formats Using Impala

1. To confirm table formats, execute the following `DESCRIBE` statements in Impala:

    ``` sql
    --  
    -- DESCRIBE Iceberg and Hive tables  
    DESCRIBE FORMATTED ${prefix}_airlines.flights;  
    DESCRIBE FORMATTED ${prefix}_airlines.unique_tickets;  
    --
    ```

   - This will reveal the format of each table (Iceberg or Hive).

   ![65.png](../../images/65.png)

## Summary

In this submodule, you've learned how to explore visualizations in CDV that combine both Iceberg and Hive tables. You've also learned how to verify the table formats using Impala.

## Next Steps

To continue working with Iceberg and Hive tables, you may want to explore:

- **[Module 05 - Loading Data for Multi-function Analytics](Module%2005%20-%20Loading%20Data/README.md)**: Explore advanced techniques for loading data into Iceberg tables.

- **[Module 06 - Time Travel](Module%2006%20-%20Time%20Travel/README.md)**: Leverage Iceberg’s time travel capabilities to query historical data.
