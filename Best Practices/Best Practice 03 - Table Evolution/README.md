#  Best Practice 05 - Table Evolution

## Overview
The evolution of tables in data lakehouses primarily involved transitioning from the traditional data warehouse concept of strictly structured tables to more flexible, open table formats like Apache Iceberg and Delta Lake, allowing for better handling of large, diverse datasets while maintaining data quality and enabling efficient data operations like updates and deletes, which were previously difficult in traditional data lakes; this shift was driven by the need to combine the scalability of data lakes with the performance and reliability of data warehouses, leading to the "lakehouse" architecture.

Using the table evolution features in a data lakehouse is considered a best practice for several reasons:

- **Adaptability to changing requirements** because business needs and data sources evolve.
- **Minimize Disruption** as traditional data management often requires downtime during schema changes. 
- **Data Integrity and Compatibility** as schemas evolve, table evolution helps maintain compatibility with existing data, ensuring that updates do not lead to data inconsistencies or loss of integrity. 
- **Version Control and Historical Reference** allows for maintaining a history of schema changes. 
- **Improved Performance** on evolution can include optimizations like changing partitioning strategies or reorganizing data, which can enhance query performance and reduce data retrieval times.

![best_practice_3a.jpg](../../images/best_practice_3a.jpg)

## Table structure, partitioned by year:

```sql
CREATE TABLE transaction (id INT, time TIMESTAMP, ...) 
PARTITIONED BY YEARS(time);
```

## Adding new partitions. First, break down by month, then by day:

```sql
ALTER TABLE transaction ADD PARTITION FIELD MONTH(time)
```

```sql
ALTER TABLE transaction ADD PARTITION FIELD DAY(time)
```

## IceTip
Monitor the amount of data ingested in each partition, and the query’s patterns, to define when a new partition is needed to keep consumption jobs performant. 
Leverage in-place partition evolution to break down data into more granular partitions easily. 

End-user doesn’t need to be aware of the partition changes, even changing how to query the table.
