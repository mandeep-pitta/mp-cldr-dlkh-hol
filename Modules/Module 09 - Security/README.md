# Module 09 - Security

## Security with Ranger Policies

This module demonstrates using Ranger policies for fine-grained access control with Iceberg tables on the Cloudera Data Platform (CDP). Ranger provides authorization capabilities for various data sources within CDP.

**Ranger Policy for Data Masking:**

The example focuses on creating a Ranger policy to mask a specific column (Tailnum) in the `planes` Iceberg table. Masking replaces sensitive data with unreadable values (e.g., hashing).

**Verifying Unmasked Data:**

The guide instructs you to execute a query in CDW/Hue (Impala) to view the `planes` table. This initial query reveals the Tailnum data in plain text.

**Enabling Ranger Policy and Masking:**

The steps involve navigating to the Ranger UI and enabling a predefined Ranger policy (`${user_id}`\-iceberg-fgac) for the `Hadoop SQL` service. This policy is designed to mask the Tailnum column.

**Verifying Masked Data:**

After enabling the Ranger policy, running the same query on the `planes` table again shows the Tailnum data being masked (e.g., hashed), demonstrating the effectiveness of the Ranger policy.

**Note:** Refer to the specific steps and screenshots in the full documentation for detailed Ranger UI navigation.

Remember to replace `${user_id}` with your actual user ID throughout the process.

To begin, select the sub-module below:

## Submodules

`01` [SQL Masking Policy](masking_policy_SQL.md)