# STEDI ETL

## Overview

This project implements an ETL pipeline for the **STEDI Human Balance Analytics** project using AWS Glue, Redshift, and Spark. The pipeline processes sensor data from the STEDI Step Trainer, mobile app accelerometer, and customer data, transforming the raw data into a format suitable for machine learning models. The pipeline consists of three main stages: **Bronze**, **Silver**, and **Gold**, each serving a specific purpose in cleaning, filtering, and curating the data for downstream analytics and machine learning tasks.

## Pipeline Structure

The pipeline is organized into the following three stages:

1. **Bronze**: Ingests raw data from the S3 ingestion layer and filters it based on customer consent for research.
2. **Silver**: Addresses key data quality issues and curates the data, ensuring that only customers with valid and matched sensor data are included.
3. **Gold**: Loads the curated data into **Amazon Redshift** using an L3 normalized schema for efficient querying and reporting.

The project uses **AWS Glue** for ETL orchestration and **Amazon Redshift** for structured data storage and reporting.

### Technologies Used

- **AWS Glue**: To handle the data extraction, transformation, and loading (ETL) process.
- **Amazon S3**: For raw data ingestion and intermediate storage.
- **Amazon Redshift**: To store the curated data in a structured format for querying.
- **Terraform**: For provisioning AWS resources including Glue jobs, Redshift clusters, and S3 buckets.

## Project Structure

- **`etl/`**: Contains the Glue scripts for processing the data across the Bronze, Silver, and Gold layers.
- **`infra/`**: Contains Terraform scripts for provisioning AWS infrastructure required for the pipeline, including Glue, Redshift, and S3 resources.
- **`trainer_data/`**: Sample data for testing the ETL pipeline.

## Detailed Pipeline Documentation

Each stage of the ETL pipeline has its own detailed documentation. You can refer to the following links for more information:

1. **[Bronze ETL Pipeline](./etl/bronze/README.md)**: Handles the ingestion of raw data from S3, filtering it based on customer consent.
2. **[Silver ETL Pipeline](./etl/silver/README.md)**: Addresses data quality issues and curates data to ensure correctness.
3. **[Gold ETL Pipeline](./etl/gold/README.md)**: Loads the curated data into Amazon Redshift using an L3 normalization schema for efficient querying.

## Deployment and Provisioning

The infrastructure, including the Glue jobs, Redshift cluster, and S3 storage, is provisioned using **Terraform**. To deploy the infrastructure, navigate to the `infra/` directory and follow the steps outlined in the Terraform setup.

## Getting Started

1. **Ingest Data**: Place raw JSON data files in the corresponding `S3 ingestion` folder.
2. **Run ETL Jobs**:
   - Execute the **Bronze**, **Silver**, and **Gold** Glue jobs in sequence to process and load data.
3. **Query Data**: Use Amazon Redshift to run queries on the curated data.

For more details, refer to the individual README files for each stage of the pipeline.
