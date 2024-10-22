# Silver ETL Pipeline

This directory contains the scripts for the **Silver** layer of the STEDI ETL pipeline. The Silver layer processes and curates data from the **Bronze** layer, addressing key data quality issues discovered by the Data Science team. The curated data in the Silver zone is crucial for ensuring accurate downstream processing and machine learning models.

## Data Quality Issue

### Customer Data Serial Number Issue

Data Scientists discovered a significant data quality issue with the **Customer Data**:

- The serial number, which should uniquely identify a customer's STEDI Step Trainer device, has been repeated across multiple customer records due to a defect in the fulfillment website.
- Instead of each customer receiving a unique serial number for their device, the same **30 serial numbers** were reused for millions of customers.
- **Most customers** haven't received their devices yet, but some customers have been submitting Step Trainer data over the IoT network.

### Impact on Data Processing

- The **Step Trainer Records** have the correct serial numbers coming from the IoT network, which creates a mismatch between the customer records and the step trainer data.
- This discrepancy makes it difficult to associate the correct customer with their step trainer data using the serial number alone.

## Silver Pipeline Solution

The scripts in the **Silver** layer focus on solving this issue by ensuring that **only customers with both accelerometer and step trainer data** are included in the curated data. This allows us to work around the serial number defect by focusing on customers who are actively submitting both types of data.

### Steps Taken:

1. **Customer Data Curation (`customer_trusted_to_curated.py`)**:

   - This script reads the **bronze layer** of customer data and filters it to include only customers who have **accelerometer data**.
   - By focusing on customers with accelerometer data, we can create a more accurate customer dataset in the **silver layer**.

2. **Step Trainer Data Curation (`step_trainer_trusted.py`)**:

   - This script reads the **bronze layer** of step trainer data and matches it with the **curated customer data** by serial numbers.

3. **Machine Learning Data Curation (`machine_learning_curated.py`)**:

   - This script reads the **silver layer** of both step trainer and accelerometer data and joins them on **sensor reading time** and **timestamps**.
   - The curated data is then written to the **curated (gold) layer**, ensuring that only customers with both accelerometer and step trainer data are included for machine learning analysis.

### Outcome

- The Silver layer focuses on **correctly matching step trainer data with customers** based on their activity timestamps (via accelerometer readings), which effectively bypasses the serial number defect.
- This curated dataset is now ready for further processing in the **Gold** layer, ensuring that only customers with correct and reliable data are passed forward.

By addressing this data quality issue in the Silver layer, we ensure that the downstream machine learning models receive accurate and high-quality data, free from the issues caused by the serial number defect.
