#  Best Practice 01 # - Medallion Architecture

## Overview
For the past several decades, there have been many iterations around building a high-performance and scalable architecture that supports the growing data demands of business users. The Medallion Architecture is not new, but it was created to help organizations architect data solutions for their ever-growing data assets that can come in any format. This architecture consists of three distinct layers – **bronze (raw), silver (validated), and gold (enriched)** – each representing progressively higher levels of quality. The architecture is considered a best practice for the Data Lakehouse because of the following characteristics. 

- **Layered Data Organization** as stated above bronze, silver, and gold.
- **Improved Data Quality** by processing data through multiple stages, it facilitates rigorous data cleansing and validation, ensuring that only high-quality data reaches the final layer for analysis.
- **Scalability and Flexibility** as it supports the incremental processing of data, making it easier to scale and adapt to changing data sources or analytical needs without disrupting the entire system.
- **Enhanced Performance** that optimizes storage, and access patterns at each layer.
- **Facilitated Collaboration** is provided by structured layers, where different teams can work simultaneously on various data transformations and analyses, which promotes collaboration and faster insights across the organization. 

![best_practice_1a.jpg](../../images/best_practice_1a.jpg)

## Medallion Architecture at Cloudera

![best_practice_1b.jpg](../../images/best_practice_1b.jpg)

## IceTip 

Leverage the **Medallion Architecture** pattern to simplify the maintenance of the different stages of the data that will be ingested into the Lakehouse.
Keep the data format closer to the origin data source in the Bronze layer and perform the additional transformations and enrichment for the upper layers. 
Materialized Views can also be leveraged for the Gold layer as a mechanism to facilitate multiple table aggregation creation and maintenance. 
