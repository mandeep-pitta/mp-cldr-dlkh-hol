# Manual Table Compaction & Manifest rewrite - ensures optimal performance

- In   project “\<user-id>-iceberg-project”

- Create a new file, named “iceberg\_table\_maintenance.py”

  - Copy paste the following code

```
    # Replace <user-id> below with your user id

    user_id = "<user-id>"

    table_name = user_id + "_airlines_maint.flights"
    insert_stmt = "INSERT INTO " + table_name + " SELECT * FROM " + user_id + "_airlines_csv.flights_csv"

    # Load Data Files, to create larger number of files written for table
    for i in range(1,32):
       spark.sql(insert_stmt + " WHERE year = 2006 AND month = 1 AND dayofmonth = " + str(i))
       print("Data Loaded for Day of Month: ", i)

    # INSERT "BAD" RECORD INTO FLIGHTS TABLE
    insert_stmt = "INSERT INTO " + table_name
    spark.sql(insert_stmt + " VALUES(99,99,99,9999,9999,9999,9999,'DL',947,'N981DL',95,86,70,113,104,'XXX','ATL',356,11,14,0,'n/a','0',0,0,113,0,0,9999)")

    print("Data Load Complete")

    # Query Raw Data Table, to see that 1 month of data is loaded for 2006 ~50k records
    spark.sql("SELECT year, count(*) FROM " + table_name + " GROUP BY year ORDER BY year desc").show()

    # The 2006 partition data contains 60+ files, about 200KB each (for just 1 month loaded for each day)
    #    When reading this data it will cause overhead in opening many smaller files instead of fewer 
    #    appropriately sized files
    spark.sql("SELECT file_path, file_size_in_bytes FROM " + table_name + ".files").show(100)

    # Table Maintenance to Manually Compact files to size of 500MB
    #    Compact flights table files into fewer files
    spark.sql("CALL spark_catalog.system.rewrite_data_files(table => '" + table_name + "', options => map('target-file-size-bytes','52428800'))").show()

    # After Compaction, see that there is only 1 file which is about 11MB that needs to be read in the same directory
    spark.sql("SELECT file_path, file_size_in_bytes FROM " + table_name + ".files").show(100)

    ## Also should clean up Manifest files
    spark.sql("SELECT path, length, added_snapshot_id, added_data_files_count FROM jing_airlines_maint.flights.manifests").show(100)

    # Table Maintenance to Manually Compact files to size of 500MB
    #    Compact flights table files into fewer files
    spark.sql("CALL spark_catalog.system.rewrite_manifests(table => 'jing_airlines_maint.flights')").show()

    # After Compaction, see that there is only 1 file which is about 11MB that needs to be read in the same directory
    spark.sql("SELECT path, length, added_snapshot_id, added_data_files_count FROM jing_airlines_maint.flights.manifests").show(100)
```

Now let's investigate the "Bad" record we saw previously
