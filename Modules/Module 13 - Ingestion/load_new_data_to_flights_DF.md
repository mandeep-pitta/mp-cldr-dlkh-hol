# NiFi (NiFi user interface & Flow Designer)

The following describes the steps to perform to leverage the Iceberg Processors available in CDF.


## PutIceberg Processor - NiFi DataHub

- This Flow will load “newer” Flight data from year 2009-2023 (not complete 2023)

- The source data is located in a “public” S3 bucket

- The target will be the “**\<user-id>\_airlines.flights**” Iceberg table

- This flow can also be deployed using Flow Designer as well - just follow this same approach

- At time of writing this document, researching acquiring a Public AWS bucket for the new flights data and for the CSV files that are used to build the Data Lakehouse

**Setup**

Download the Flow Definition - [here](https://drive.google.com/file/d/1liwmeFEkiUp7_-pDRWGu-Y9SKCFSmcX7/view?usp=drive_link)

Open the DataHub NiFi and create a new Process Group

![import_flow_definition.png](../../images/import_flow_definition.png)

Browse to the JSON file on your disk, once uploaded you will see the following:

![process_group.png](../../images/process_group.png)

Double click on the Process Group.  This will be the resulting Flow (with a few comments added to this screenshot)

![nifi_flow.png](../../images/nifi_flow.png)

**Getting the Flow to Execute**

- **Prerequisite** steps

  - Open CDP > Management Console > Environments > **your-environment**

  - Click on Data Lake tab

  - Open Cloudera Manager by going to the Data Lake tab and clicking on the CM URL

![datalake_cm_url.png](../../images/datalake_cm_url.png)

1. On the left nav - select Clusters > Hive Metastore

![cm_hive_metastore_config.png](../../images/cm_hive_metastore_config.png)

2. Click on Actions > Download Client Configuration

![cm_download_hms_client_config.png](../../images/cm_download_hms_client_config.png)

- Once the client configuration is downloaded to your machine, unzip the file

![client_config_folder.png](../../images/client_config_folder.png)

- Open hive-site.xml file in Text Editor - find the Hive Metastore URI

  1. Search for “hive.metastore.uris”

  2. Use the whole string between the \<value> and \</value> tags.  This is either 1 or more URIs separated by a comma

![hive_metastore_uris.png](../../images/hive_metastore_uris.png)

- Open a command prompt terminal \[DataHub NiFi or NiFi on-prem ONLY]

  1. \[For Flow Designer use the parameter #CDPEnvironment] - so the follow steps are not required

  2. Change directory to the client configuration unzipped directory

  3. scp hive-site.xml, core-site.xml, and hdfs-site.xml to the NiFi worker nodes using the node’s public IP address

```
    scp <file>-site.xml <worker-pub-ip>:~
```

4. ssh to each worker node

   - Create a directory in /tmp

   - Copy the xml files to this directory

   - Ensure the nifi user has access to the directory plus these 3 files

   - Below is the sample of commands that need to be executed.  Replace \<user-id> with your user-id you’ve been using

```
    ssh <worker-pub-ip>
    mkdir /tmp/<user-id>
    cp *.xml /tmp/<user-id>/
    sudo chown -R nifi:nifi /tmp/<user-id>
```

- **NiFi UI**

  - Modify Parameters

    1. Access Key ID - your AWS access key to the CDP bucket where the new (2009-2023) flight data data resides

    2. Secret Key ID - your AWS secret key to the CDP bucket where the new (2009-2023) flight data data resides

    3. Workload User - your CDP workload user id

    4. Workload Password - your workload user password

    5. Hadoop Configuration Resources - this should contain the path to the xml files on the NiFi Worker nodes, ie. /tmp/\<user-id>/hive-site.xml,/tmp/\<user-id>/core-site.xml,/tmp/\<user-id>/hdfs-site.xml

    6. Database - should be “\<user-id>\_airlines” , using the \<user-id> you used to run the SQL to create the Data Lakehouse in the DW steps

    7. Hive Metastore URI - use the Hive Metastore URIs found in the previous step

![update_parameter_context.png](../../images/update_parameter_context.png)

- Start Controller Services

  1. Right Click and select Configure

![configure_flow.png](../../images/configure_flow.png)

2. Go to Controller Services tab

![controler_svcs_tab.png](../../images/controler_svcs_tab.png)

3. Enable all the Controller Services by clicking on the lightning bolt next to each Controller Service that has not yet been enabled

![enable_controler_svcs.png](../../images/enable_controler_svcs.png)

- If you see this message, you have not correctly set up the Environment in the NiFi Worker nodes.

![warning_nifi_not_setup_correctly.png](../../images/warning_nifi_not_setup_correctly.png)

1. These are some common issues to look out for:

   - You may have missed copying 1 or more of the .xml files to the Worker nodes

   - The permissions on the /tmp/\<user-id> directory do not allow the nifi user or group access to this directory properly

   - The permissions on the .xml files in /tmp/\<user-id> do not allow the nifi user or group access to the files properly

- Run the Flow - **start all** of the Processors

  - Check what is loaded by going to HUE and querying the flights table

**Detailed Information on Flow - ConvertRecord Processor**

- Convert Record Processor configuration

  - This processor is used to convert the incoming CSV flight records for years 2009-2023 to match the format of the Iceberg table.  This includes removing columns from the input CSV files and changing the data types as necessary.

  - The CSV file is converted to an AVRO format, in case additional processing is needed.  To take advantage of processors like the UpdateRecord processor

![configure_convert_record_processor.png](../../images/configure_convert_record_processor.png)

- The “Record Reader” and “Record Writer” properties need to be 

  - Record Reader - CSV Reader Controller Service

![configure_csv_reader_controller_service.png](../../images/configure_csv_reader_controller_service.png)

- Set “Schema Access Strategy” to “User ‘Schema Text’ Property”

- In “Schema Text” use this AVRO Schema for new flights data CSV files:

```
    {
      "type": "record",
      "namespace": "com.cloudera",
      "name": "flights_new_data",
      "fields": [
        { "name": "year", "type": "int" },
        { "name": "month", "type": "int" },
        { "name": "dayofmonth", "type": "int" },
        { "name": "dayofweek", "type": "int" },
        { "name": "uniquecarrier", "type": "string" },
        { "name": "tailnum", "type": ["null","string"] },
        { "name": "flightnum", "type": ["null","int"] },
        { "name": "origin", "type": "string" },
        { "name": "dest", "type": "string" },
        { "name": "crsdeptime", "type": ["null","int"] },
        { "name": "deptime", "type": ["null","int"] },
        { "name": "depdelay", "type": ["null","double"] },
        { "name": "taxiout", "type": ["null","double"] },
        { "name": "taxiin", "type": ["null","double"] },
        { "name": "crsarrtime", "type": ["null","int"] },
        { "name": "arrtime", "type": ["null","int"] },
        { "name": "arrdelay", "type": ["null","double"] },
        { "name": "cancelled", "type": "double" },
        { "name": "cancellationcode", "type": ["null","string"] },
        { "name": "diverted", "type": "string" },
        { "name": "crselapsedtime", "type": ["null","double"] },
        { "name": "actualelapsedtime", "type": ["null","double"] },
        { "name": "airtime", "type": ["null","double"] },
        { "name": "distance", "type": ["null","double"] },
        { "name": "carrierdelay", "type": ["null","double"] },
        { "name": "weatherdelay", "type": ["null","double"] },
        { "name": "nasdelay", "type": ["null","double"] },
        { "name": "securitydelay", "type": ["null","double"] },
        { "name": "lateaircraftdelay", "type": ["null","double"] }
      ]
    }
```

- Record Writer - Avro Record Set Writer Controller Service

![configure_avro_recordset_writer_controller_service.png](../../images/configure_avro_recordset_writer_controller_service.png)

- Set “Schema Access Strategy” to “Use ‘Schema Text’ Property”

- In “Schema Text” use this AVRO Schema for new flights data going into Iceberg table:

```
    {
      "type": "record",
      "namespace": "com.cloudera",
      "name": "flights_new_data",
      "fields": [
        { "name": "month", "type": "int" },
        { "name": "dayofmonth", "type": "int" },
        { "name": "dayofweek", "type": "int" },
        { "name": "deptime", "type": ["null","int"] },
        { "name": "crsdeptime", "type": ["null","int"] },
        { "name": "arrtime", "type": ["null","int"] },
        { "name": "crsarrtime", "type": ["null","int"] },
        { "name": "uniquecarrier", "type": "string" },
        { "name": "flightnum", "type": ["null","int"] },
        { "name": "tailnum", "type": ["null","string"] },
        { "name": "actualelapsedtime", "type": ["null","int"] },
        { "name": "crselapsedtime", "type": ["null","int"] },
        { "name": "airtime", "type": ["null","int"] },
        { "name": "arrdelay", "type": ["null","int"] },
        { "name": "depdelay", "type": ["null","int"] },
        { "name": "origin", "type": "string" },
        { "name": "dest", "type": "string" },
        { "name": "distance", "type": ["null","int"] },
        { "name": "taxiin", "type": ["null","int"] },
        { "name": "taxiout", "type": ["null","int"] },
        { "name": "cancelled", "type": "int" },
        { "name": "cancellationcode", "type": ["null","string"] },
        { "name": "diverted", "type": "string" },
        { "name": "carrierdelay", "type": ["null","int"] },
        { "name": "weatherdelay", "type": ["null","int"] },
        { "name": "nasdelay", "type": ["null","int"] },
        { "name": "securitydelay", "type": ["null","int"] },
        { "name": "lateaircraftdelay", "type": ["null","int"] },
        { "name": "year", "type": "int" }
      ]
    }
```

**Detailed Information on Flow - PutIceberg Processor**

- PutIceberg processor configuration

![configure_puticeberg_processor.png](../../images/configure_puticeberg_processor.png)

- The PutIceberg Processor is an INSERT only processor that inserts records into an existing Iceberg table.  The records are read using the Record Reader.

- File Format describes the file format for the Iceberg table, by default this processor uses PARQUET, but you could also use ORC or AVRO.

- The Iceberg table that will have records inserted into will be identified by the “Catalog Namespace” and “Table Name” properties

  1. The “Catalog Namespace” is equivalent to the Database Name in the Data Lakehouse

  2. The “Table Name” is obviously the name of the Iceberg table

  3. These properties are Parameterized to allow for changes to these properties

- There are 3 other Properties that are required to be defined

1. Record Reader

   - The record has already been converted to an AVRO format by the ConvertRecord Processor and has an embedded schema.

![configure_avro_reader_controller_service.png](../../images/configure_avro_reader_controller_service.png)

- Properties to set

  - Schema Access Strategy - “Use Embedded Avro Schema”

  - The embedded schema matches the schema of the Iceberg table

2. Catalog Service - **HiveCatalogService**

   - To configure the Catalog Service you need to provide:

     - The Hive Metastore URI(s) - acquired in the Prerequisite Steps from the hive-site.xml file

     - The Hadoop Configuration Resources - is the location of the hive-site.xml, core-site.xml, and hdfs-site.xml files on each NiFi Worker Node.  In these instructions we use the /tmp/\<user-id> directory

![configure_hivecatalog_controller_service.png](../../images/configure_hivecatalog_controller_service.png)

- These Properties are Parameterized to allow for varying Environments to be configured, as well as specifying alternate directories from the /tmp directory where the \*-site.xml files are stored

3. Kerberos User Service

   - This Service will identify the Principal User and Password used to connect to the Hive Metastore Service

![configure_kerberos_pw_user_controller_service.png](../../images/configure_kerberos_pw_user_controller_service.png)

- These Properties are Parameterized to allow any user to run the flow (as long as they have access to write to the Iceberg Table)



# Appendix

**Formatted (pretty print) AVRO Schema for incoming CSV Flights data:**

```
    {
      "type": "record",
      "namespace": "com.cloudera",
      "name": "flights_new_data",
      "fields": [
        {
          "name": "year",
          "type": "int"
        },
        {
          "name": "month",
          "type": "int"
        },
        {
          "name": "dayofmonth",
          "type": "int"
        },
        {
          "name": "dayofweek",
          "type": "int"
        },
        {
          "name": "uniquecarrier",
          "type": "string"
        },
        {
          "name": "tailnum",
          "type": ["null","string"]
        },
        {
          "name": "flightnum",
          "type": ["null","int"]
        },
        {
          "name": "origin",
          "type": "string"
        },
        {
          "name": "dest",
          "type": "string"
        },
        {
          "name": "crsdeptime",
          "type": ["null","int"]
        },
        {
          "name": "deptime",
          "type": ["null","int"]
        },
        {
          "name": "depdelay",
          "type": ["null","double"]
        },
        {
          "name": "taxiout",
          "type": ["null","double"]
        },
        {
          "name": "taxiin",
          "type": ["null","double"]
        },
        {
          "name": "crsarrtime",
          "type": ["null","int"]
        },
        {
          "name": "arrtime",
          "type": ["null","int"]
        },
        {
          "name": "arrdelay",
          "type": ["null","double"]
        },
        {
          "name": "cancelled",
          "type": "double"
        },
        {
          "name": "cancellationcode",
          "type": ["null","string"]
        },
        {
          "name": "diverted",
          "type": "string"
        },
        {
          "name": "crselapsedtime",
          "type": ["null","double"]
        },
        {
          "name": "actualelapsedtime",
          "type": ["null","double"]
        },
        {
          "name": "airtime",
          "type": ["null","double"]
        },
        {
          "name": "distance",
          "type": ["null","double"]
        },
        {
          "name": "carrierdelay",
          "type": ["null","double"]
        },
        {
          "name": "weatherdelay",
          "type": ["null","double"]
        },
        {
          "name": "nasdelay",
          "type": ["null","double"]
        },
        {
          "name": "securitydelay",
          "type": ["null","double"]
        },
        {
          "name": "lateaircraftdelay",
          "type": ["null","double"]
        }
      ]
    }
```

**Formatted (pretty print) AVRO Schema to match Iceberg table:**

```
    {
      "type": "record",
      "namespace": "com.cloudera",
      "name": "flights_new_data",
      "fields": [
        {
          "name": "month",
          "type": "int"
        },
        {
          "name": "dayofmonth",
          "type": "int"
        },
        {
          "name": "dayofweek",
          "type": "int"
        },
        {
          "name": "deptime",
          "type": ["null","int"]
        },
        {
          "name": "crsdeptime",
          "type": ["null","int"]
        },
        {
          "name": "arrtime",
          "type": ["null","int"]
        },
        {
          "name": "crsarrtime",
          "type": ["null","int"]
        },
        {
          "name": "uniquecarrier",
          "type": "string"
        },
        {
          "name": "flightnum",
          "type": ["null","int"]
        },
        {
          "name": "tailnum",
          "type": ["null","string"]
        },
        {
          "name": "actualelapsedtime",
          "type": ["null","int"]
        },
        {
          "name": "crselapsedtime",
          "type": ["null","int"]
        },
        {
          "name": "airtime",
          "type": ["null","int"]
        },
        {
          "name": "arrdelay",
          "type": ["null","int"]
        },
        {
          "name": "depdelay",
          "type": ["null","int"]
        },
        {
          "name": "origin",
          "type": "string"
        },
        {
          "name": "dest",
          "type": "string"
        },
        {
          "name": "distance",
          "type": ["null","int"]
        },
        {
          "name": "taxiin",
          "type": ["null","int"]
        },
        {
          "name": "taxiout",
          "type": ["null","int"]
        },
        {
          "name": "cancelled",
          "type": "int"
        },
        {
          "name": "cancellationcode",
          "type": ["null","string"]
        },
        {
          "name": "diverted",
          "type": "string"
        },
        {
          "name": "carrierdelay",
          "type": ["null","int"]
        },
        {
          "name": "weatherdelay",
          "type": ["null","int"]
        },
        {
          "name": "nasdelay",
          "type": ["null","int"]
        },
        {
          "name": "securitydelay",
          "type": ["null","int"]
        },
        {
          "name": "lateaircraftdelay",
          "type": ["null","int"]
        },
        {
          "name": "year",
          "type": "int"
        }
      ]
    }
```
