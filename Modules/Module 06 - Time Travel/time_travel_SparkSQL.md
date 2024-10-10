# Time Travel - Spark SQL

In the previous steps we have been loading data into the flights Iceberg table.  Each time we add (delete or update) data a Snapshot is captured.  This is important for many reasons but the main point of the Snapshot is to ensure eventual consistency and allow for multiple reads/writes concurrently (from various engines or the same engine).  In this Runbook you take advantage of one of the features, Time Travel.  We will use this to query data from a specific point in time, a good use case where this is important is regulatory compliance.

- In the next few steps execute the following in CDE Session started using Spark version 3.5.1 (version 3.3.x should work as well)


**Time Travel feature - SYSTEM_VERSION **

- In the next few steps execute the following in HUE for Impala VW

```
from pyspark.sql.functions import col

# Variables - replace <user_id> with your user id
user_id = "<user_id>"
odl_database_name = user_id + "_airlines"

# RETURN SNAPSHOTS (History)
history_df = spark.sql(f"SELECT * FROM {odl_database_name}.flights.snapshots")

history_df.show()

# GET FIRST SNAPSHOT CREATED - committed_at
history_df = history_df.filter(col("parent_id").isNull())

snapshot_id = history_df.first().snapshot_id

print("Actual Timestamp of Snapshot: ", snapshot_id)

# TIME TRAVEL TO THIS DATE
spark.sql(f"SELECT year, count(*) FROM {odl_database_name}.flights SYSTEM_VERSION AS OF {snapshot_id} GROUP BY year ORDER BY year desc").show()

```


**Time Travel feature - SYSTEM_TIME **

```
from pyspark.sql.functions import col
import datetime

# Variables - replace <user_id> with your user id
user_id = "<user_id>"
odl_database_name = user_id + "_airlines"

# RETURN SNAPSHOTS (History)
history_df = spark.sql(f"SELECT * FROM {odl_database_name}.flights.snapshots")

history_df.show()

# GET FIRST SNAPSHOT CREATED - committed_at
history_df = history_df.filter(col("parent_id").isNull())

first_date = history_df.first().committed_at

# Add 1 minute to date & truncate date to seconds
time_change = datetime.timedelta(minutes=1) 
relative_ts = first_date + time_change
relative_ts = relative_ts.replace(second=0, microsecond=0)

print("Actual Timestamp of Snapshot: ", first_date)
print("Relative Timestamp for Time Travel: ", relative_ts)

# TIME TRAVEL TO THIS DATE
spark.sql(f"SELECT year, count(*) FROM {odl_database_name}.flights FOR SYSTEM_TIME AS OF '{relative_ts}' GROUP BY year ORDER BY year desc").show()

```

**Notes:
- The line "SELECT * FROM \<db>.\<table>.snapshots” line returns all of the available Snapshots for the flights Iceberg table.  These Snapshots were automatically captured each time we loaded data.

![.png](../../images/.png)

* In the examples used in this Runbook you should get the exact same output.  Both statements will use the same Snapshot which was our first data load that was for all data <= 2006.  If you specify the other Snapshot and run the same queries, you will see the same data plus you will see the year 2007 (or possibly year 2008) because this snapshot is for the last load we ran.

