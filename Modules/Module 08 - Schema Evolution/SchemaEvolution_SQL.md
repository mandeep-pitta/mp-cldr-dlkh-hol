# Schema Evolution

In this Demo, we'll be exploring in-place schema evolution.

**In-place Schema Evolution feature - Add columns to table**

* Execute the folling in HUE for the Hive VW
```
ALTER TABLE ${prefix}_airlines.airlines ADD COLUMNS(status STRING, updated TIMESTAMP);
```

   ![In Place Table Evolution](../../images/SchemaEvolution_Add_Columns.png)

   - The existing table data is **not modified** with this statement

* Refresh the table browser to see new columns added

   - Click on the refresh button to the right of `Tables`

   - Click `airlines` table to see the new columns: `status` and `updated`
   
   ![Updated Table Metadata](../../images/SchemaEvolution_Updated_Metadata.png)

* Add data into the new schema for `airlines` table

```
INSERT INTO ${prefix}_airlines.airlines
VALUES("Z999","Adrenaline Airways","NEW",now());
```

* Query `airlines` table to see old and new schema data

```
SELECT * FROM ${prefix}_airlines.airlines WHERE code > "Z";
```

   - As you scroll through the results you will see the 2 columns that we added will contain "NULL" values for the data that was already in the table and the new record we inserted will have value in the new columns `status` and `updated`

   ![View data after Schema Evolution](../../images/SchemaEvolution_View_Results.png)
