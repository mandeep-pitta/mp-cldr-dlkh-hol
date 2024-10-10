# Snapshot Expiration - save storage space

- In Hive VW

  - Execute to see snapshots

```
    -- EXPIRE SNAPSHOT(S)
    SELECT * FROM ${user_id}_airlines_maint.flights.snapshots;
```

- Select one of the Snapshots

- Execute the following to remove all Snapshots up to this Snapshot

```
    -- Expire Snapshots up to the specified timestamp
    --      BE CAREFUL: Once you run this you will not be able to Time Travel for any Snapshots that you Expire
    ALTER TABLE ${user_id}_airlines_maint.flights EXECUTE expire_snapshots('${create_ts}');
```

- Execute to see the snapshots have been removed

```
    -- Ensure Snapshots have been removed
    SELECT * FROM ${user_id}_airlines_maint.flights.snapshots;
```
