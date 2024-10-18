# Demo Table Maintenance Install/Setup

**Sandbox Tenant**

**Environment:** se-sandboxx-aws \<OR> create your own


## CDP Environment<a id="cdp-environment"></a>

- **REQUIRED:** you must have access to the S3 bucket for whatever CDP Environment you plan to use

- You have two (2) options

1. Use an existing CDP Environment in the Sandbox Tenant, such as se-sandboxx-aws

2. Create your own CDP Environment \[for screenshots in this Runbook, this is the route that was used]


## Setting up the Table Maintenance Database for the Demo<a id="setting-up-the-databases-for-the-demo"></a>

- Execute the following in HUE using the Hive VW named **\<prefix>-iceberg-hive-vw**

  - Copy & paste the SQL (`in gray`) below

    - HUE has determined that there is a parameter that needs to be entered, in the “user\_id” box enter your user id

![](../images/13.png)

```
-- CREATE DATABASES
CREATE DATABASE ${prefix}_airlines_maint;

-- [TABLE MAINTENANCE] CREATE FLIGHTS TABLE IN ICEBERG TABLE FORMAT STORED AS PARQUET
drop table if exists ${prefix}_airlines_maint.flights;

CREATE TABLE ${prefix}_airlines_maint.flights (
month int, dayofmonth int,
dayofweek int, deptime int, crsdeptime int, arrtime int,
crsarrtime int, uniquecarrier string, flightnum int, tailnum string,
actualelapsedtime int, crselapsedtime int, airtime int, arrdelay int,
depdelay int, origin string, dest string, distance int, taxiin int,
taxiout int, cancelled int, cancellationcode string, diverted string,
carrierdelay int, weatherdelay int, nasdelay int, securitydelay int,
lateaircraftdelay int
)
PARTITIONED BY (year int)
STORED BY ICEBERG
STORED AS PARQUET
;
```
