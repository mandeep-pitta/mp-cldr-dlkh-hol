# Best Practice 10 - Metadata Caching

## Overview

Caching metadata is a best practice for data lakehouses because it significantly enhances data retrieval speed and query planning efficiency:

- **Faster Queries** By caching deserialized Avro files in memory, queries can avoid the decompression and parsing stages, which often slow down smaller queries. This leads to quicker query execution and can help reduce operational costs.
- **Optimized Query Performance** Iceberg's metadata provides valuable information about schema, partitioning, and data location, which can be leveraged to optimize query performance.
- **Enhanced Data Governance** Apache Iceberg's metadata tables can be accessed using Dremio's SQL syntax, facilitating better data governance, ensuring data integrity, and aiding in regulatory compliance.

## Metadata Caching

![best_practice_10a.jpg](../../images/best_practice_10a.jpg)

## Let's dive into the Manifest File

![best_practice_10b.jpg](../../images/best_practice_10b.jpg)

## IceTip
Enabling the manifest caching feature helps to reduce repeated reads of small Iceberg manifest files from remote storage by Impala Coordinators and Catalogd.
