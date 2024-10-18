# Module 16 - Table Maintenance

# Iceberg Table Maintenance with Compaction, Rollback and Snapshot Expiration

This module dives into maintaining Iceberg tables in your Cloudera Data Platform (CDP) environment. It covers three key functionalities:

1. **Manual Compaction:** Optimizes table performance by reducing the number of small files.
2. **Rollback:** Reverts the table to a previous state in case of bad data insertion.
3. **Snapshot Expiration:** Manages storage space by removing old snapshots.

The module utilizes a sample "flights" table within the `prefix` project for demonstration purposes.

**Submodules:**

- **Table maintenance manual compaction:** This section guides you through manually compacting the "flights" table to improve query performance. It includes:
    
    - Script to load sample data (including a bad record).
    - Steps to identify the large number of small files generated.
    - Code to manually compact the table files into a single, larger file (500MB).
    - Instructions to clean up manifest files after compaction.
- **Table maintenance with rollback:** This section demonstrates how to recover from bad data insertions using rollback functionality. It includes:
    
    - Steps to identify a bad record (year 9999) in the "flights" table.
    - Instructions to view existing snapshots and pinpoint the one containing the bad data.
    - Code to rollback the table to the last known good state using the snapshot ID.
    - Verification steps to confirm the bad record has been removed.
- **Table maintenance with snapshot expiration:** This section explains how to manage storage space by expiring old snapshots. It includes:
    
    - Instructions to view existing snapshots in the "flights" table.
    - Code to expire all snapshots up to a specific point in time (be cautious as expired snapshots cannot be recovered for time travel queries).
    - Steps to verify that snapshots have been successfully removed.

**Remember to replace `${prefix}` with your actual user ID throughout the process.**

**Additional Notes:**

- While the provided Python script demonstrates data manipulation, the focus of this module is on Iceberg table maintenance functionalities.
- Separate modules might exist for detailed explanations of data loading or manipulation techniques.

To begin, select one of the sub-modules below:

## Submodules

`01` [Table Maintenance with Manual Compaction](01_table_maintenance_manual_compaction.md)

`02` [Table Maintenance with Rollback](02_table_maintenance_rollback.md)

`03` [Table Maintenance with Snapshot Expiration](03_table_maintenance_snapshot_expiration.md)
