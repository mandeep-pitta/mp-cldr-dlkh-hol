## Module 06 - Time Travel

## Iceberg Time Travel Using SQL

This module explores the Time Travel feature of Iceberg tables on Cloudera Data Platform (CDP). Time Travel allows querying data from a specific point in time, valuable for tasks like regulatory compliance.

**Iceberg Snapshots and Time Travel:**

Whenever data is added, deleted, or updated in an Iceberg table, a snapshot is automatically captured. These snapshots provide a historical record of the table's state at different points in time. Time Travel leverages these snapshots to enable querying data as it existed at a specific moment.

**Using Time Travel in CDP:**

The example demonstrates using Time Travel in CDP's Impala interface:

1. **`DESCRIBE HISTORY`**: This command displays all available snapshots for the `flights` Iceberg table.
2. **Time Travel Queries**: Two example queries showcase querying data based on specific points in time:
    - **`FOR SYSTEM_TIME AS OF`**: This allows querying data as it existed at a specified timestamp (either absolute or relative).
    - **`FOR SYSTEM_VERSION AS OF`**: This enables querying data based on a specific snapshot ID.

The example highlights how both approaches can retrieve data from a particular point in time, ensuring you see the state of the table as it was at that moment. This functionality is useful for scenarios where regulations require access to historical data states.

Remember to replace `${user_id}` and `${create_ts}` with your actual user ID and chosen timestamp, and `${snapshot_id}` with the specific snapshot ID you wish to query against.

To begin, select the sub-module below:

## Submodules

`01` [Time Travel Using SQL](time_travel_SQL.md)