# Module 09 - Security with Ranger Policies

## Overview

This module demonstrates how to implement security using **Ranger policies** for fine-grained access control with Iceberg tables on the Cloudera Data Platform (CDP). Ranger provides robust authorization capabilities, allowing you to enforce detailed access controls, including column-level data masking, across various data sources.

### Ranger Policy for Data Masking

In this example, we’ll focus on creating and applying a **Ranger masking policy** for the `planes` Iceberg table. The policy is designed to mask sensitive data in the `Tailnum` column, replacing the original values with hashed (unreadable) data.

### Methods Covered in This Module

#### 1. Verifying Unmasked Data

You will begin by querying the `planes` Iceberg table in Cloudera Data Warehouse (CDW) using Hue/Impala to view the `Tailnum` column in its original, unmasked form.

#### 2. Enabling Ranger Masking Policy

You will then navigate to the **Ranger UI** to enable a predefined masking policy (`${prefix}-iceberg-fgac`), which applies masking to the `Tailnum` column in the `planes` table. This policy demonstrates how to enforce security controls at a granular level using Ranger.

#### 3. Verifying Masked Data

After enabling the policy, you will rerun the query on the `planes` table to verify that the `Tailnum` column has been masked (hashed), ensuring that sensitive data is protected.

### Key Takeaways

- Ranger allows you to apply **fine-grained access control** to Iceberg tables, including column-level masking.
- You can create and apply masking policies to protect sensitive information without disrupting table functionality.
- The `Tailnum` column in this example demonstrates how to use Ranger to mask sensitive data in a production environment.

> **Note:** Remember to replace `${prefix}` with your user ID throughout the process.

## Submodules

To continue, proceed to the submodule below:


- `01` [SQL Masking Policy](masking_policy_SQL.md)
