## Ranger Policy Setup

- Open Ranger UI for the Environment you are using.

- Open Hadoop SQL

![](../images/38.png)

- On the Masking tab, Add a New Policy as follows, replacing \<user-id> with your user id and then clicking on the Add button.

  - Policy Name:  **\<user-id>**-iceberg-fgac

  - Hive Database:  **\<user-id>**\_airlines

  - HIve Table: planes

  - Hive Column: tailnum

  - Mask Conditions:

    - Select User:  **\<user-id>**

    - Select Access Types: select

    - Select Masking Option: Hash

![](../images/39.png)      ![](../images/39.png)

- To test the Policy works properly.  Execute the following in CDW, by opening HUE for the Impala VW named **\<user-id>-iceberg-impala-vw**

  - Execute the following SQL, enter your user id in the parameter box

```
SELECT * FROM ${user_id}_airlines.planes;
```
- In results you see that the Tailnum column has now been HASHed

![](../images/41.png)

- Disable the Ranger Policy (during the demo all you’ll have to do is enable the policy)

  - Return to Ranger and disable the masking policy you just created, and click Save button

![](../images/42.png)
