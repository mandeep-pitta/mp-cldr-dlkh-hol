# 01_prereqs

## Iceberg Demo Runbook

## STEP 1: Getting Airline Data to Cloud Storage

Download files from this GitHub [link to GitHub]()
Click on the drop down next to folder, and select Download

Unzip the downloaded zip files in the `flights` directory.	

In the AWS Console for s3 
Navigate to the bucket used for creating the environment

Create a folder named - `iceberg-demo`
   * This new folder location should be something like `s3a://<cdp-bucket>/iceberg-demo`
   * `In AWS S3, Upload` With the folder you just created selected, click on Upload, on the Upload screen click `Add folder` button and browse your computer to the  airlines-csv directory (download from GitHub)

Browse each of the folder to make sure the CSV file is in the folders correctly - flights, planes, airlines, and airports

## STEP 2: Create CDW Virtual Warehouses

   * In CDW ensure that the Environment you are using is enabled for use with CDW

   * For this Runbook you can use the Default Database Catalog that is automatically created with enabling CDW for the Environment

   * Create two CDW Virtual Warehouses attached to the Default Database Catalog, replace &lt;prefix> with your user id

      1. Create a Hive VW
         Name: `<prefix>-iceberg-hive-vw`
         Type: Hive
         Database Catalog: select the Default DBC for the Environment you are using
         Size: x-small
         Concurrency Autoscaling > Executors: make sure the max is > (# Attendees * 2) Leave remaining options as default (these wcan be changed but for this Runbook there are no specific settings that are required)
   2. Create an Impala VW
      * Name: `<prefix>-iceberg-impala-vw`
      * Type: Impala
      * Database Catalog: select the Default DBC for the Environment you are using
      * Size: x-small
      * Unified Analytics: enabled
      * Executors: make sure the max is > (# Attendees * 2)
      * Leave remaining options as default (these can be changed but for this Runbook there are no specific settings that are required)


