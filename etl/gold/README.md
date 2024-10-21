# Gold ETL Pipeline

> Redshift (L2 Normalization)

## Overview

In this **Gold ETL pipeline**, we're moving **curated data** from the Silver layer to **Amazon Redshift** for efficient querying and reporting. After processing and refining the data in the earlier stages, our focus is on creating a schema that balances performance, storage, and simplicity.

## Why L2 Normalization?

I have chosen **L2 Normalization** for the following reasons:

- **Minimizes Redundancy**: L2 reduces duplication while maintaining critical fields (e.g., serial numbers) in the appropriate tables.
- **Optimizes Performance**: Fewer joins are needed compared to L1, speeding up common queries without excessive redundancy.
- **Simplifies Queries**: Analysts and data scientists can easily query without handling overly complex joins or risking inconsistencies.

## Why Not L3?

L3 (denormalized) structures would increase **data redundancy** and **maintenance complexity**, leading to scalability challenges as data grows. L2 offers the best balance of performance and efficiency.

## Table Schema (L2 Normalization)

- **Customer Table (customer_l2)**:

  - `customer_id` (Primary Key, INT): Unique identifier for each customer.
  - `customerName` (VARCHAR): Full name of the customer.
  - `email` (VARCHAR): Email address of the customer (unique).
  - `phone` (VARCHAR): Phone number.
  - `birthDay` (DATE): Date of birth.
  - `registrationDate` (BIGINT): Timestamp when the customer registered.
  - `lastUpdateDate` (BIGINT): Timestamp of the last update.
  - `shareWithResearchAsOfDate` (BIGINT): Consent date for research data sharing.
  - `shareWithPublicAsOfDate` (BIGINT): Consent date for public data sharing.
  - `shareWithFriendsAsOfDate` (BIGINT): Consent date for sharing with friends.
  - `serialNumber` (VARCHAR): Serial number of the Step Trainer device.

- **Step Trainer Table (step_trainer_l2)**:

  - `step_trainer_id` (Primary Key, INT): Unique identifier for each step trainer record.
  - `sensorReadingTime` (BIGINT): Timestamp when the sensor reading was taken.
  - `distanceFromObject` (INT): Distance measured by the sensor.
  - `serialNumber` (VARCHAR): Serial number of the Step Trainer device.
  - `customer_id` (Foreign Key, INT): Links to the customer owning the device.

- **Accelerometer Table (accelerometer_l2)**:
  - `accelerometer_id` (Primary Key, INT): Unique identifier for each accelerometer reading.
  - `timestamp` (BIGINT): Timestamp when the accelerometer reading was captured.
  - `x`, `y`, `z` (FLOAT): Acceleration values in the X, Y, and Z directions.
  - `customer_id` (Foreign Key, INT): Links to the customer who generated the accelerometer data.
