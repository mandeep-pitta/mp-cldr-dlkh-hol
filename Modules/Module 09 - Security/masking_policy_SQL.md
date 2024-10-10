# SDX Integration (Fine Grained Access Control)

In this section you will create a Ranger policy to apply a Masking Policy for the Planes Iceberg table for your user id.

**Query the Planes Table (in CDW HUE)**

- Execute the following in HUE for Impala VW

```
    SELECT * FROM ${user_id}_airlines.planes;
```

- In results you see that the Tailnum column is in plain readable text, as shown


**Enable Ranger Policy on Planes Table**

- Open Ranger UI for the Environment you are using.

- Open Hadoop SQL

- Edit the Policy **\<user-id>**-iceberg-fgac (replace \<user-id> with your user id)

  - On the Policy details click on Disabled to Enable the policy

![39.png](../../images/39.png)

- Click on Save button

**Query the Planes Table (in CDW HUE)**

- Execute the following in HUE for Impala VW

```
    SELECT * FROM ${user_id}_airlines.planes;
```

- In results you see that the Tailnum column is now been HASHed

![41.png](../../images/41.png)

