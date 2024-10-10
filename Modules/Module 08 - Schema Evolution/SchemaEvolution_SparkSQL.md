# Schema Evolution - SparkSQL

In this Demo, we'll be exploring in-place schema evolution.

**In-place Schema Evolution feature - Add columns to table**

* Execute the folling in a CDE Session

```
# Variables - replace <user_id> with your user id
user_id = "<user_id>"
odl_database_name = user_id + "_airlines"

# CHECK TABLE FORMAT - before in-palce schema evolution
spark.sql(f"DESCRIBE FORMATTED {odl_database_name}.airlines").show()

# EVOLVE PARTITOIN IN-PLACE - add another column to partition to improve performance
spark.sql(f"ALTER TABLE {odl_database_name}.airlines ADD COLUMNS(status STRING, updated TIMESTAMP)").show()

# CHECK TABLE FORMAT - after schema evolution
spark.sql(f"DESCRIBE FORMATTED {odl_database_name}.airlines").show()

```

   ![.png](../../images/.png)

   - The existing table data is **not modified** with this statement


* Add data into the new schema for `airlines` table

* Query `airlines` table to see old and new schema data

```
# INSERT A NEW RECORD USING NEW COLUMNS - status & updated
spark.sql(f"INSERT INTO {odl_database_name}.airlines VALUES("Z999","Adrenaline Airways","NEW",now())").show()

# INSERT A NEW RECORD USING NEW COLUMNS - status & updated
spark.sql(f"SELECT * FROM {odl_database_name}.airlines WHERE code > 'Z'").show()

```

   - As you scroll through the results you will see the 2 columns that we added will contain "NULL" values for the data that was already in the table and the new record we inserted will have value in the new columns `status` and `updated`

   ![.png](../../images/.png)
