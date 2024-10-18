# Module 08 - Schema Evolution

## Overview

This module explores **schema evolution** for Iceberg tables on the Cloudera Data Platform (CDP). Schema evolution allows you to modify table schemas without rewriting data, ensuring backward and forward compatibility for your queries.

### Key Concepts of Iceberg Schema Evolution:

1. **Backward and Forward Compatibility**
   - Backward compatibility ensures that data does not need to be rewritten.
   - Forward compatibility allows applications to handle schema changes smoothly, even if they are unaware of new or changed columns.

2. **Column ID-based Schema Changes**
   - Iceberg tracks schema changes safely by referencing column names and types with IDs. This avoids ambiguity when columns are renamed or reordered.

3. **Metadata Layer Tracking**
   - Schema changes are tracked in the metadata layer, so they occur independently of the data files, allowing efficient and reliable schema evolution.

### Why In-place Schema Evolution is Important?

One of Iceberg's strengths is handling schema evolution without costly table rewrites or disruption to queries on existing data. Schema changes occur without requiring data migrations, making it adaptable to evolving business needs. Key benefits include:

- **No data rewrites or migrations:** Modifying a schema doesn't break existing queries or data.
- **Flexibility:** Allows you to adapt to new data sources and changing business processes.
- **Efficient schema modifications:** Enables changes like adding, dropping, renaming, or reordering columns in-place.

### Methods Covered in This Module

#### 1. In-place Schema Evolution Using SQL

This method demonstrates how to modify an existing Iceberg table (`airlines`) by adding new columns to the schema using the `ALTER TABLE` statement in SQL.

#### 2. Schema Evolution Using Spark SQL

This method shows how to evolve the schema using Spark SQL to add new columns, retaining backward compatibility with the old data schema.

#### 3. Schema Evolution Using Spark DataFrames

This method uses Spark DataFrames to evolve schemas programmatically within an Iceberg table, showcasing how easy it is to handle schema changes in Spark environments.

### Key Takeaways

- Schema evolution does not require rewriting existing data, as changes are applied at the metadata level.
- Old data and schemas are still queryable post-evolution.
- Schema evolution allows for adding, dropping, renaming, changing column types, and reordering columns without disrupting data.

> **Note:** Remember to replace `${prefix}` with your chosen value (e.g., your User ID) throughout the process.

## Submodules

Choose one of the following submodules to get started:

- `01` [Evolve Iceberg Table Schema Using SQL](SchemaEvolution_SQL.md)
- `02` [Evolve Iceberg Table Schema Using Spark SQL](SchemaEvolution_SparkSQL.md)
- `03` [Evolve Iceberg Table Schema Using Spark DataFrames](SchemaEvolution_SparkDF.md)
