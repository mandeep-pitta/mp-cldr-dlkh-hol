# Iceberg Table Format Table(s) joined with Hive Table Format Table(s) using Data Viz

It is NOT a requirement to convert all tables to Iceberg Table format.  In fact, this can be something that you move to over time.

**DataViz - Explore the “Airline Dashboard” Dashboard**

- Click on VISUALS tab

- Click on the Dashboard named “**Airline Dashboard**”

![75.png](../../images/75.png)

- **VALUE**: combine Iceberg with Hive table formats, means you can convert to use Iceberg where it makes sense and also can migrate over time vs. having to migrate at the same time

  - This Dashboard uses the same **Iceberg** tables (flights, planes, airports) that you have been working on in the Airlines DW (database name “**\<user\_id>**\_airlines”) and combines this with an existing table in the same database, named “unique\_carrier” which is still in a Hive Table format.

* Let’s explore the Dataset to see the various tables that are part of this Data Model

  - Click on the DATA tab, you will now have a Dataset named “Airlines Lakehouse”

![30.png](../../images/30.png)

- Click on the “Airlines Lakehouse” to open the Dataset

  - On the left navigation menu select Data Model

  - Click on the ![31.png](../../images/31.png)button

    - Click on the “unique\_tickets” table, to find the source table

      - Database: \<user\_id>\_airlines

      - Table: unique\_tickets

    - Click on the “flights” table, to find the source table

      - Database: \<user\_id>\_airlines

      - Table: unique\_tickets

    - Instead of showing each table lets take a look at the table types

* Execute the following in HUE for Impala VW

  - Remember that we have already seen the following tables in Iceberg Table format

    - flights (via Create Table in Iceberg format)

    - planes (migrated via Alter Table utility)

    - airports (CTAS to Iceberg table)

  - So, let’s see about the Unique Tickets table.  We’ll see that this table is still in Hive Table Format - see SerDe Library = ParquetHiveSerDe (not the Iceberg SerDe).  So we have a Dashboard that is combining both table formats in a single Dashboard

```
    --
    -- [optional] SINGLE QUERY USING ICEBERG & HIVE TABLE FORMAT
    --            Uses CDV Dashboard, could also just query in HUE
    DESCRIBE FORMATTED ${user_id}_airlines.flights;
    DESCRIBE FORMATTED ${user_id}_airlines.unique_tickets;
```

![65.png](../../images/65.png)

