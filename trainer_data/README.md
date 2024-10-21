# STEDI ETL Data Repository

This repository contains sample data for the STEDI Human Balance Analytics project, which is aimed at developing an ETL pipeline using AWS Glue and Spark to process and curate sensor data for machine learning. The sample data represents different aspects of sensor and customer data used to train a machine learning model to detect human steps using the STEDI Step Trainer.

## Sample Data Overview

The sample data is organized in three categories:

- **Step Trainer Sensor Data**: Captures distance readings from the STEDI Step Trainer’s motion sensors.
- **Accelerometer Data**: Collects data from a mobile app's accelerometer (X, Y, Z axis) to detect movements.
- **Customer Data**: Contains customer registration and consent information.

These files are located in the following directories:

- `step_trainer/landing/`
- `accelerometer/landing/`
- `customer/landing/`

This sample data follows a `.jsonl` format (JSON Lines) for efficient line-by-line processing.

### Production Data Overview

In the production environment, data files are stored in Amazon S3 and can be found in the following locations:

- **Step Trainer Data**: `s3://stedi-etl/ingestion/step_trainer/*.json`
- **Accelerometer Data**: `s3://stedi-etl/ingestion/accelerometer/*.json`
- **Customer Data**: `s3://stedi-etl/ingestion/customer/*.json`

Unlike the sample data, production data is stored in an **`ingestion/`** folder and uses a `.json` file extension, though the structure remains the same as the `.jsonl` sample files.

## Data Attributes Overview

### Step Trainer Sensor Data (`step_trainer`):

- **sensorReadingTime**: The timestamp (in milliseconds) when the sensor reading was captured.
- **serialNumber**: The unique identifier of the STEDI Step Trainer device.
- **distanceFromObject**: The measured distance (in arbitrary units) from the Step Trainer sensor to an object, used to detect steps.

### Accelerometer Data (`accelerometer`):

- **user**: The email address of the user associated with the mobile app and Step Trainer.
- **timestamp**: The timestamp (in milliseconds) when the accelerometer reading was captured.
- **x, y, z**: The acceleration values in the X, Y, and Z directions, used to measure movement.

### Customer Data (`customer`):

- **customerName**: The full name of the customer.
- **email**: The email address of the customer.
- **phone**: The phone number of the customer.
- **birthDay**: The date of birth of the customer.
- **serialNumber**: The serial number of the Step Trainer associated with the customer.
- **registrationDate**: The timestamp (in milliseconds) when the customer registered the device.
- **lastUpdateDate**: The last time the customer's information was updated.
- **shareWithResearchAsOfDate**: The date when the customer consented to share data for research.
- **shareWithPublicAsOfDate**: The date when the customer consented to share data publicly.
- **shareWithFriendsAsOfDate**: The date when the customer consented to share data with friends.

### Note on Customer Data Sharing

The customer data includes fields that indicate whether a customer has consented to share their data for research, with the public, or with friends. However, not all customers provide such consent. For example, some customers may not have fields such as `shareWithResearchAsOfDate`, `shareWithPublicAsOfDate`, or `shareWithFriendsAsOfDate` populated, which indicates that their data should not be shared for these purposes.

It's important to respect these preferences during data processing and ensure that only customers who have explicitly consented to share their data are included in any datasets used for research or public-facing purposes.
