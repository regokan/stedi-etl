# STEDI ETL

## Overview

This project implements an ETL pipeline for the **STEDI Human Balance Analytics** project using AWS Glue, Redshift, and Spark. The pipeline processes sensor data from the STEDI Step Trainer, mobile app accelerometer, and customer data, transforming the raw data into a format suitable for machine learning models. The pipeline consists of three main stages: **Bronze**, **Silver**, and **Gold**, each serving a specific purpose in cleaning, filtering, and curating the data for downstream analytics and machine learning tasks.

## Pipeline Structure

The pipeline is organized into the following three stages:

1. **Bronze**: Ingests raw data from the S3 ingestion layer and filters it based on customer consent for research.
2. **Silver**: Addresses key data quality issues and curates the data, ensuring that only customers with valid and matched sensor data are included.
3. **Gold**: Loads the curated data into **Amazon Redshift** using an L2 normalized schema for efficient querying and reporting.

The project uses **AWS Glue** for ETL orchestration and **Amazon Redshift** for structured data storage and reporting.

### Technologies Used

- **AWS Glue**: To handle the data extraction, transformation, and loading (ETL) process.
- **Amazon S3**: For raw data ingestion and intermediate storage.
- **Amazon Redshift**: To store the curated data in a structured format for querying.
- **Terraform**: For provisioning AWS resources including Glue jobs, Redshift clusters, and S3 buckets.

## Project Structure

```
.
├── README.md                   # Main README file providing an overview of the project.
├── etl                         # Contains all ETL scripts for processing data through different stages.
│   ├── bronze                  # ETL scripts for the Bronze layer (raw to filtered data).
│   │   ├── Makefile            # Makefile to push code for bronze ETL jobs.
│   │   ├── README.md           # Documentation specific to the Bronze ETL layer.
│   │   ├── accelerometer.py    # Script to process raw accelerometer data, filter, and move to the bronze layer.
│   │   ├── customer.py         # Script to process raw customer data, filter by consent, and move to the bronze layer.
│   │   └── step_trainer.py     # Script to process raw step trainer data and move it to the bronze layer.
│   ├── silver                  # ETL scripts for the Silver layer (curated and cleaned data).
│   │   ├── Makefile            # Makefile to push code for silver ETL jobs.
│   │   ├── README.md           # Documentation specific to the Silver ETL layer.
│   │   ├── customer.py         # Script to clean and curate customer data, solving quality issues.
│   │   └── step_trainer.py     # Script to match curated customer data with step trainer events.
│   ├── gold                    # ETL scripts for the Gold layer (loading data into Redshift).
│   │   ├── Makefile            # Makefile to push code for gold ETL jobs.
│   │   ├── README.md           # Documentation specific to the Gold ETL layer.
│   │   └── main.py             # Main script to load the curated data from the Silver layer into Redshift.
├── infra                       # Infrastructure as code for deploying AWS resources using Terraform.
│   ├── apply.local             # Script for applying Terraform configurations locally.
│   ├── config.tf               # Main configuration for Terraform.
│   ├── data.tf                 # Terraform configuration for fetching existing resources.
│   ├── main.tf                 # Main infrastructure setup for Glue, S3, Redshift, etc.
│   ├── modules                 # Contains Terraform modules for different AWS resources.
│   │   ├── glue                # AWS Glue-related configurations and jobs for each layer of the pipeline.
│   │   │   ├── bronze_accelerometer.tf
│   │   │   ├── bronze_customer.tf
│   │   │   ├── bronze_step_trainer.tf
│   │   │   ├── gold.tf
│   │   │   ├── silver_customer.tf
│   │   │   ├── silver_step_trainer.tf
│   │   │   └── variables.tf
│   │   ├── iam                 # IAM roles and policies for the ETL jobs.
│   │   │   ├── bronze_etl.tf
│   │   │   ├── gold_etl.tf
│   │   │   ├── output.tf
│   │   │   ├── silver_etl.tf
│   │   │   └── variables.tf
│   │   ├── redshift            # Redshift cluster provisioning and configuration.
│   │   │   ├── Makefile
│   │   │   ├── stedi_redshift_cluster.tf
│   │   │   └── variables.tf
│   │   ├── s3                  # S3 bucket provisioning and configuration.
│   │   │   ├── output.tf
│   │   │   └── stedi_etl.tf
│   │   └── stepfunction        # (Reserved for future Step Function integration).
│   ├── networking.tf           # Terraform configuration for VPC and networking.
│   ├── output.tf               # Outputs for the overall infrastructure setup.
│   ├── plan.local              # Script for planning Terraform changes locally.
│   ├── terraform.tfvars        # Terraform variables for customizing the infrastructure.
│   └── variables.tf            # Global variables used throughout the Terraform setup.
└── trainer_data                # Sample data used for testing and validating the pipeline.
    ├── README.md               # Documentation for the sample data.
    ├── accelerometer           # Directory for sample accelerometer data.
    │   └── landing
    │       └── accelerometer-1691348231445.jsonl
    ├── customer                # Directory for sample customer data.
    │   └── landing
    │       └── customer-1691348231425.jsonl
    └── step_trainer            # Directory for sample step trainer data.
        └── landing
            └── step_trainer-1691348232038.jsonl
```

- **`etl/`**: Contains the Glue scripts for processing the data across the Bronze, Silver, and Gold layers.
- **`infra/`**: Contains Terraform scripts for provisioning AWS infrastructure required for the pipeline, including Glue, Redshift, and S3 resources.
- **`trainer_data/`**: Sample data for testing the ETL pipeline.

## Detailed Pipeline Documentation

Each stage of the ETL pipeline has its own detailed documentation. You can refer to the following links for more information:

1. **[Bronze ETL Pipeline](./etl/bronze/README.md)**: Handles the ingestion of raw data from S3, filtering it based on customer consent.
2. **[Silver ETL Pipeline](./etl/silver/README.md)**: Addresses data quality issues and curates data to ensure correctness.
3. **[Gold ETL Pipeline](./etl/gold/README.md)**: Loads the curated data into Amazon Redshift using an L2 normalization schema for efficient querying.

## Data Flow

1. **Bronze Layer**:

   - Extracts raw data from S3.
   - Filters it based on customer consent for research.
   - Stores filtered data back to S3 in the Bronze folder.

2. **Silver Layer**:

   - Resolves data quality issues (such as mismatched serial numbers).
   - Curates the data so that only customers with valid sensor readings are included.

3. **Gold Layer**:
   - Loads the curated data into **Amazon Redshift** with an L2 normalized schema for efficient querying.
   - This layer ensures that the data is optimized for reporting and downstream analytics.

## Deployment and Provisioning

The infrastructure, including the Glue jobs, Redshift cluster, and S3 storage, is provisioned using **Terraform**. To deploy the infrastructure, navigate to the `infra/` directory and follow the steps outlined in the Terraform setup.

## Getting Started

1. **Ingest Data**: Place raw JSON data files in the corresponding `S3 ingestion` folder.
2. **Run ETL Jobs**:
   - Execute the **Bronze**, **Silver**, and **Gold** Glue jobs in sequence to process and load data.
3. **Query Data**: Use Amazon Redshift to run queries on the curated data.

For more details, refer to the individual README files for each stage of the pipeline.
