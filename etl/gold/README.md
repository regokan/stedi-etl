# Gold ETL Pipeline

> Redshift (L3 Normalization for Machine Learning)

## Overview

In this **Gold ETL pipeline**, we are moving **curated data** from the Silver layer to **Amazon Redshift** for advanced querying, reporting, and machine learning purposes. While L2 normalization is typically favored for balancing performance and redundancy, we have intentionally implemented **L3 normalization** to support our machine learning objectives. This approach involves denormalization to consolidate related data and make it more accessible for complex algorithms, which require easy access to diverse features.

## Why L2 Normalization? (And Why We Deviate)

L2 normalization offers several benefits:

- **Minimizes Redundancy**: L2 reduces data duplication while ensuring necessary fields, like serial numbers, are properly maintained.
- **Improves Query Performance**: By reducing the number of required joins, L2 allows queries to run faster than highly normalized L1 structures.
- **Eases Query Complexity**: Analysts can easily run queries without dealing with excessive joins or handling multiple tables.

However, **L3 normalization** becomes a better choice for scenarios that involve **machine learning** because it enables faster and easier access to a broader range of data features. This denormalization reduces the need for complex joins when preparing data for algorithms, ensuring faster model training and inference.

## Why L3 for Machine Learning?

Although L3 denormalization increases data redundancy, it is an intentional trade-off in our pipeline to simplify access to features needed for machine learning models. With denormalized tables:

- **Reduced Joins for Feature Access**: Machine learning models often require multiple features from different tables. L3 allows us to avoid costly joins during model training by providing all the necessary fields in fewer tables.
- **Improved Feature Engineering**: By consolidating data, we make it easier to extract, create, and manipulate features without worrying about complicated table relationships.
- **Increased Efficiency for Large-Scale Data**: In a machine learning context, the focus shifts to throughput and fast data access. L3 helps us maintain high performance even as the dataset grows.

## Table Schema (L3 Normalization)

In this L3-denormalized schema, we've consolidated the key data points that are essential for machine learning purposes. The schema simplifies access to diverse features without the need for complex joins:

- **Machine Learning Data Table (machine_learning_l3)**:

  - `serialNumber` (VARCHAR): Serial number of the device, linking to the customer or device data.
  - `sensorReadingTime` (BIGINT): Timestamp of when the sensor reading was recorded.
  - `distanceFromObject` (INT): The measured distance from the object, captured by the sensor.
  - `user` (VARCHAR): The user associated with the sensor reading or device.
  - `x`, `y`, `z` (FLOAT): Accelerometer readings in the X, Y, and Z directions, capturing the 3D movement or position of the device.

### Explanation:

This schema is focused on providing **denormalized** data to support efficient machine learning operations. Each row contains all the key information necessary for feature engineering, model training, and inference without requiring complex joins between multiple tables. The chosen fields (`serialNumber`, `sensorReadingTime`, `distanceFromObject`, `user`, and accelerometer readings) are critical for analyzing user behavior and device performance, making this L3 structure ideal for our machine learning tasks.
