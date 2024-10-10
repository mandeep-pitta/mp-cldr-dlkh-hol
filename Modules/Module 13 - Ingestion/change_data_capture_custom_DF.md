# CDC Custom Data Flow

## PutIcebergCDC Processor - CDF Flow Designer

- This Flow will simulate loading CDC transactions related to Airline Carrier changes

- The Flow will process an Update, a Delete, and an Insert into the target Iceberg table

- The Iceberg table “airlines” must be using the v2 Iceberg format ie. TBLPROPERTIES ("format-version"="2")

- The source is a GenerateFlowFile processor that has a JSON that mimics what data would be transmitted from GoldenGate

- The target is the “**\<user-id>\_airlines.airlines**” Iceberg table

- **NOTE:** the CDC data can be written the the Iceberg table as singleton inserts, deletes, and updates.  HOWEVER, if you try to query the Iceberg table (as of 2023-12-14) immediately after writing the data the query WILL Fail.

  - Failure is due to not supporting Equality Deletes currently

  - To resolve you first need to run “Table Compaction” and then the query will work successfully

|                                                                                                                                                                                                   |                                                                                                                                                                                                                          |
| :-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------: | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| ![](../../images/df_menu.png) | Click on Flow Design ->![](../../images/flow_designer_link.png) |

**Setup**

Download the Flow Definition - [here](https://drive.google.com/open?id=1fjDf0FbN77fqV6OX20DkNNUMT5kn3gh1)

- **Prerequisite** steps

  - Ensure you have DFFlowAdmin Role for the Environment

![](../../images/dfflowadmin_resource_role.png)

- Open DataFlow > Catalog

![](../../images/df_catalog_import_flow_definition.png)

1. Import the Flow Definition - click on the “Import Flow Definition” button

   - Give the flow a name - “**\<user-id>-ice-cdc-version-1**”

   - Upload the Flow Definition .json file you just downloaded

   - Click the Import button

![](../../images/import_flow_json.png)

**Getting the Flow to Execute**

- Create New Draft from Catalog - click on “\<user-id>-ice-cdc” flow to open the properties page

![](../../images/cdc_in_flow_catalog.png)

- Click on “Create New Draft” button to create a New Draft

![](../../images/cdc_create_new_draft.png)

- In “Target Workspace” select your CDF Environment

- Target Project - is optional

- In “Draft Name” name the Draft “**\<user-id>-ice-cdc**”

- Click on the “Create” button

![](../../images/cdc_draft_properties.png)

- This will open the Draft in **Flow Designer** - for draft named “**\<user-id>-ice-cdc**”

  1. Modify Parameters - 

![](../../images/cdc_flow_parameters.png)

- Database - modify to “\<user-id>\_airlines”

- Table Name - name of the table to apply CDC transactions to; no change required

- Hive Metastore URI - URI to the Hive Metastore, found in your Datalake settings

  - Go to Environment > click on Data Lake tab > click on Nodes in the bottom left corner

  - Under the Master section - you will see 1 or 2 nodes

    - Click on the copy button to the right of each Master node

    - The format of the Hive Metastore URI is - for 1 node = thrift://\<first-copied-fqdn>:9083; for 2 nodes = thrift://\<first-copied-fqdn>:9083,thrift://\<second-copied-fqdn>:9083

      - Replace the \<first/second-copied-fqdn> by pasting the copied FQDNs

![](../../images/data_lake_thrift_nodes.png)

- Workload User - your workload user that you use to sign in to CDP

- Workload Password - your workload password

* Start Test Session - click on “Flow Options” > Start buttons.  This will take several minutes to start

![](../../images/cdc_start_test_session.png)

Click “Start Test Session” button

![](../../images/cdc_start_test_session_config.png)

- Enable **all** Controller Services - click on “Flow Options” > Services.

![](../../images/cdc_navigate_to_services.png)

1. Enable each of these Services - by selecting the Service and then clicking on the Enable button for each Service

![](../../images/cdc_enable_services.png)

- HiveCatalogService

- JsonRecordSetWriter

- JsonTreeReader

- KerberosPasswordUserService

* Run the Flow - **start** the following Processors as specified

  1. In the “Get Change Data Capture Data” Processor Group

     - Start the ConvertRecord Processor

     - Start the SplitJSON Processor

     - Start the GetCDCdata\_outputPort Output Port

     - Run the GenerateFlowFile Processor, just 1time.  Right click on the processor and select “Run Once”

![](../../images/cdc_processor_run_once.png)

2. On the main canvas

   - View the generated CDC Records that are now in the Queue - right click on the Connection going into the PutIcebergCDC processor and click on “List Queue”

![](../../images/cdc_list_queue.png)

- Select any 1 of the items in the Queue

![](../../images/cdc_view_queue_flowfile.png)

- Click on “Open in Data Viewer”

![](../../images/cdc_view_flowfile_contents.png)

You will see the Data Viewer - show the contents of the FlowFile

![](../../images/cdc_flowfile_contents_formatted.png)

- Start the PutIcebergCDC Processor to send the CDC records to change the Airlines table

  - Check what has been changed by going to HUE and querying the airlines table


#### Custom

**Detailed Information on Flow - GenerateFlowFile \[located in “Get Change Data Capture Data” Process Group] (Custom)**

This CDC example will simulate data coming from any sort of CDC processing engine (3rd party or custom built) by using a GenerateFlowFile Processor.  This example concentrates on the aspects that write the changes to an Iceberg table.  Normally, the data would come from a Kafka topic.

![](../../images/custom_cdc_input.png)

- The CDC records for this example will use the “Custom” record format

  - This processor is set up to run 1 time per day for now to avoid situations where this processor can send a bunch of records at 1 time, but should only be run 1 time.  Once the records are updated there is no need to run this again

  - This is a JSON representation of the records to be changed (truncated to show the important parts of the JSON record)

    - The follow depicts the relationship between the settings required to make this Processor work and the incoming JSON for this example.  This will help for those that need to use different schema for their “custom” CDC records.

![](../../images/cdc_custom_json_path_mappings.png)

- “Operation RecordPath” - will represent the path in the JSON document where the ACID operation is located in this JSON it is located in the “details” section and is named “operation”, so the RecordPath is “/details/operation”

- “Insert Operation Type”, “Delete Operation Type”, and “Update Operation Type” - reflect the value that is found in the “Operation RecordPath” value field

- “Before Data RecordPath” - represents the details of what the record looks like before changes to the record (this can be any path, you just need to make sure that the Property contains the correct path)

- “After Data RecordPath” - represents the details of what the record looks like after changes to the record (this can be any path, you just need to make sure that the Property contains the correct path)

* “operation” reflects the CDC operation to be performed (this can be any path, you just need to make sure that the Property “Operation RecordPath” contains the correct path).  For the JSON used in this example the Record Path for this field is “/details/operation” which reflects the nested JSON fields for more details on Record Paths see - <https://nifi.apache.org/docs/nifi-docs/html/record-path-guide.html#structure>

  - “insert” - indicates this record will be inserted (this can be any value you just need to make sure that the Property “Insert Operation Type” matches this)

    - The “before” section of the JSON record should be “null”

    - The “after” section of the JSON record will contain the data to be inserted in the schema of the target table

```
    {
      "details": {
        "before": null,
        "after": {
          "code": "000",
          "description": "FlyByNight"
        },
        "db": "airline_logistics",
        "table": "airlines",
        "operation": "insert",
        "ts_ms": 1486500577691
      }
    }
```

- “update” - indicated this record will be updated

  - The “before” record will contain the data to be changed in the schema of the target table 

  - The “after” record will contain the data of the new value in the schema of the target table

```
    {
      "details": {
        "before": {
          "code": "02Q",
          "description": "Titan Airways"
        },
        "after": {
          "code": "02Q",
          "description": "Adrenaline Airways"
        },
        "db": "airline_logistics",
        "table": "airlines",
        "operation": "update",
        "ts_ms": 1486500577291
      }
    }
```

- “delete” - indicates this record will be deleted

  - The “before” record will contain the data to be deleted in the schema of the target table

  - The “after” section of the JSON record should be “null”

```
    {
      "details": {
        "before": {
          "code": "DOL",
          "description": "Dolphin Airways Inc."
        },
        "after": null,
        "db": "airline_logistics",
        "table": "airlines",
        "operation": "delete",
        "ts_ms": 1486500577091
      }
    } 
```

**Detailed Information on Flow - PutIcebergCDC (Custom)**

This processor will write the CDC changes to the Iceberg Table specified within the Properties of this Processor.

![](../../images/puticeberg_cdc_processor_custom_properties.png)

- The PutIcebergCDC Processor will update, insert, and/or delete records using an existing Iceberg table.  The records are read using the Record Reader.

- File Format describes the file format for the Iceberg table, by default this processor uses PARQUET, but you could also use ORC or AVRO.  Since this is blank it will used the value of “write.format.default”, which for this Data Lakehouse happens to be set to PARQUET

- The Iceberg table that will have records inserted into will be identified by the “Catalog Namespace” and “Table Name” properties

  - The “Catalog Namespace” is equivalent to the Database Name in the Data Lakehouse

  - The “Table Name” is obviously the name of the Iceberg table

  - These properties are Parameterized to allow for changes to these properties

- There are 10 other Properties that are required to be defined

1. Catalog Service - **HiveCatalogService**

   - To configure the Catalog Service you need to provide:

     - The Hive Metastore URI(s) - URI to the Hive Metastore, found in your Datalake settings and will be in the format: thrift://\<datalake-master0-uri>:9083 \[,thrift://\<datalake-master1-uri>:9083]

     - The Hadoop Configuration Resources - use the “CDPEnvironment” parameter

![](../../images/hive_catalog_service_properties.png)

- These Properties are Parameterized to allow for varying Environments to be configured

2. RecordType - select “**Custom**” for this example as this is the format of the incoming CDC Records.  When using this option the record format is fairly flexible

3. Record Reader

   - The record is in a JSON format.

![](../../images/json_tree_reader_properties.png)

- Properties - use Schema Access Strategy of “Infer Schema”

4. Kerberos User Service

   - This Service will identify the Principal User and Password used to connect to the Hive Metastore Service

![](../../images/kerberos_pw_user_service_properties.png)

- These Properties are Parameterized to allow any user to run the flow (as long as they have access to write to the Iceberg Table)

5. Operation RecordPath - this is the record path to the Key Value pair that will contain the value for which ACID operation to perform.  It can be any name, in this example it is named “operation”.  In this example, the operation field is nested within the “details” section, so the path is “/details/operation”

![](../../images/cdc_custom_input_details_operation.png)

6. Insert Operation Type, Delete Operation Type, and Update Operation Type - these 3 properties are used to define what will be in the value of the Key Value pair defined in Operation RecordPath.  These properties are case sensitive and values can be any value to represent what is Insert, Delete, and Update

![](../../images/cdc_custom_input_operation_values.png)

7. Before Data RecordPath

   - This is the Record Path to the data of what the record looked like prior to performing an Update or Delete on the record

   - For Inserts this Key Value pair’s value will be NULL

   - This does not need to be named “before” and can be nested or not

   - Within this RecordPath it is expected to contain the schema of the record

![](../../images/cdc_custom_input_before_recordpath.png)

8. After Data RecordPath

   - This is the Record Path to the data of what the record will become for Inserts and Updates.  Ie. this will be what the new record will contain

   - For Deletes this Key Value pair’s value will be NULL

   - This does not need to be named “after” and can be nested or not

   - Within this RecordPath it is expected to contain the schema of the record

![](../../images/cdc_custom_input_after_recordpath.png)

## CDE - Session (run Table Compaction)

Once this flow completes - **_you MUST run Table Compaction_** before querying the data in the airlines table after running the PutIcebergCDC Processor.

Otherwise you will get this error message or similar depending on whether you are running Hive or Impala.

This will not be necessary in the near future, but for now Table Compaction must be run first before you can query the data.  Once Equality Deletes are supported, this step will not be required and this step will become part of the regular table maintenance process to ensure that performance is the best possible.

The compaction can be run in the background (ie. a scheduled CDE Job).  Just note that getting the timing to line up before the query runs could be difficult, unless you do something like run the Job every minute - which is not the best idea, especially if you try this for a larger amount of CDC transactions.

Using a CDE Session was the easiest way to accomplish running the Table Compaction - this also shows the strength of multi-function analytics as you can use any engine against a single copy of the data.

The size of the compaction is super small for this to ensure that the compaction will run against these small files that will be created for the airlines table (each record is only maybe 25-50 bytes).  Normally this size would be much larger like 256-512MB.

```
    # SPARK CODE to compact Airlines Iceberg Table after CDC

    user_id = "<user-id>"

    table_name = user_id + "_airlines.airlines"

    spark.sql("CALL spark_catalog.system.rewrite_data_files(table => '" + table_name + "', options => map('target-file-size-bytes','50'))").show()
```     
