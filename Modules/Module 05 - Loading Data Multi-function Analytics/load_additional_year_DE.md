# CDE - Multi-function Analytics

Since Iceberg is Engine Agnostic, we are not locked into using only one engine to interact with Iceberg, in this part of the demo we will use Spark in CDE to add additional data to the Flights table we created in the previous demo steps using CDW (HUE Hive).

**CDE Insert data into Iceberg Table feature**

- Open a Text Editor or IDE (I used VS Code from Microsoft).  Copy and paste the following code replacing \<user-id> with your user id.

```
#****************************************************************************
# 
#  ICEBERG (Multi-function Analytics) - LOAD DATA  into table created in CDW
#
#***************************************************************************/
from pyspark.sql import SparkSession
from pyspark.sql.functions import *
import pyspark.sql.functions as F

#---------------------------------------------------
#               CREATE SPARK SESSION
#---------------------------------------------------
spark = SparkSession.builder.appName('Ingest').getOrCreate()

#-----------------------------------------------------------------------------------
# LOAD DATA 1 YEAR (2008) FROM RAW DATA CSV FILES ON AWS S3 CLOUD STORAGE
#          A  TABLE IS ALREADY CREATED ON TOP OF THE CSV FILE
#          RUN INSERT INTO ICEBERG TABLE FROM THE RAW CSV TABLE
#
#-----------------------------------------------------------------------------------
print("JOB STARTED...")
spark.sql("INSERT INTO <user-id>_airlines.flights SELECT * FROM <user-id>_airlines_csv.flights_csv WHERE year = 2008 ")

print("JOB COMPLETED.\n\n")
```

- Save file as “IcebergAdd2008.py”, in a location that you remember

- In CDE, click on View Jobs for the Virtual Cluster named **\<user-id>-iceberg-vc**, replacing \<user-id> with your user id

- Create a new Job in CDE, using the following, replacing \<user-id> with your user id.  Once completed click on “Create and Run” button

   - Job Type: Spark 3.2.0
   - Name: **\<user-id>**-IcebergAdd2008 
   - Application File: File
   - Upload File: IcebergAdd2008.py (click on upload file, and browse to find your file)
   - Select a Resource: (select) Create a Resource

   - Resource Name: **\<user-id>**-IcebergAdd2008

Configurations - 

   - spark.kerberos.access.hadoopFileSystems = s3a://**\<cdp-bucket>**

Select Spark 3.2.0

Leave Advanced Options and Scheduling alone (default settings)

![62.png](../../images/62.png)            ![63.png](../../images/63.png)

                                                                                                                 Upload File (Python)

- In CDE, go to Job Runs, click on the ID for the row of the Job that you just ran.  Explore the Logs, the run history, etc. if you’d like to see more details.  As long as the Job runs successfully, you can continue on.

**Query the updated data (in CDW HUE)**

- Execute the following in HUE for Impala VW

```
    SELECT year, count(*) 
    FROM ${user_id}_airlines.flights
    GROUP BY year
    ORDER BY year desc;
```

- In the Results, you should see Year 2008 and a number of records along with the data for our previous years that have been loaded

![64.png](../../images/64.png)
