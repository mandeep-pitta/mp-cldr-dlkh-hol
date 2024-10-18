## CDE Setup

- Enable a New CDE Service, replace \<prefix> with your user id

  - Name: **\<prefix>**-iceberg-de

  - Workload Type: General - Small

  - Enable Public Load balancer: checked

![](../images/35.png)

- Add a New Virtual Cluster, replace \<prefix> with your user id

  - Name: **\<prefix>**-iceberg-vc

  - Spark Version: Spark 3.2.0 \[required for Iceberg]

  - Enable Iceberg analytic tables: checked \[required]

  - Other settings can remain default

![](../images/36.png)

