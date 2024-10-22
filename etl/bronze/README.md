# Bronze ETL Scripts

This folder contains AWS Glue scripts that process the raw data from the `ingestion/` S3 folder and filter it based on customer consent for research purposes. The filtered data is then written to the `bronze/` folder in S3. Each script handles a specific type of data.

## Scripts Overview:

1. **`step_trainer_trusted.py`**: Processes the step trainer data, filters it based on customer consent, and writes the filtered data to `bronze/step_trainer/`.
2. **`accelerometer_landing_to_trusted.py`**: Processes accelerometer data, filters it based on customer consent, and writes the filtered data to `bronze/accelerometer/`.
3. **`customer_landing_to_trusted.py`**: Processes customer data, filters those who have given research consent, and writes the filtered data to `bronze/customer/`.

Each script ensures only customers who have consented to share their data for research purposes are included in the final output.
