import sys
from awsglue.transforms import *
from awsglue.utils import getResolvedOptions
from pyspark.context import SparkContext
from awsglue.context import GlueContext
from awsglue.job import Job
from awsglue.dynamicframe import DynamicFrame
import boto3
import pandas as pd


# Wait for query execution to complete and retrieve the result
def fetch_query_results(query_id):
    status = redshift_data_client.describe_statement(Id=query_id)
    while status["Status"] in ["SUBMITTED", "PICKED", "STARTED", "RUNNING"]:
        status = redshift_data_client.describe_statement(Id=query_id)
    if status["Status"] == "FAILED":
        raise Exception(f"Query failed: {status['Error']}")
    return redshift_data_client.get_statement_result(Id=query_id)


# Initialize Glue Context
args = getResolvedOptions(sys.argv, ["JOB_NAME"])
sc = SparkContext()
glueContext = GlueContext(sc)
spark = glueContext.spark_session
job = Job(glueContext)
job.init(args["JOB_NAME"], args)

# Define Redshift connection details
redshift_tmp_dir = "s3://stedi-etl/glue/gold/temp/redshift/"
redshift_connection = "stedi-redshift-connection"
cluster_id = "stedi-redshift-cluster"
database_name = "stedi_db"
db_user = "redshiftuser"

# Read customer data from Silver S3 bucket
customer_silver_df = glueContext.create_dynamic_frame.from_options(
    connection_type="s3",
    connection_options={"paths": ["s3://stedi-etl/silver/customer/"]},
    format="json",
)

# Convert customer DynamicFrame to DataFrame
customer_df = customer_silver_df.toDF()

# Remove duplicates based on email
customer_df = customer_df.dropDuplicates(["email"])

# Write customer data to Redshift (this will generate customer_id automatically)
glueContext.write_dynamic_frame.from_jdbc_conf(
    frame=DynamicFrame.fromDF(customer_df, glueContext, "customer_dynamic_df"),
    catalog_connection=redshift_connection,
    connection_options={"dbtable": "customer", "database": database_name},
    redshift_tmp_dir=redshift_tmp_dir,
)

# Initialize Redshift Data API client
redshift_data_client = boto3.client("redshift-data", region_name="us-east-1")

# Query Redshift to retrieve customer data with customer_id
query = """
SELECT customer_id, email, serialNumber FROM customer;
"""

response = redshift_data_client.execute_statement(
    ClusterIdentifier=cluster_id,
    Database=database_name,
    DbUser=db_user,
    Sql=query,
)

# Fetch the query result
query_id = response["Id"]

result = fetch_query_results(query_id)

# Convert Redshift results to DataFrame
columns = [col["name"] for col in result["ColumnMetadata"]]
data = result["Records"]
customer_with_id_df = spark.createDataFrame(pd.DataFrame(data, columns=columns))

# Read step trainer data from Silver S3 bucket
step_trainer_silver_df = glueContext.create_dynamic_frame.from_options(
    connection_type="s3",
    connection_options={"paths": ["s3://stedi-etl/silver/step_trainer/"]},
    format="json",
)

# Convert step trainer DynamicFrame to DataFrame
step_trainer_df = step_trainer_silver_df.toDF()

# Remove duplicates based on sensorReadingTime and serialNumber
step_trainer_df = step_trainer_df.dropDuplicates(["sensorReadingTime", "serialNumber"])

# Join step_trainer data with customer data from Redshift on serialNumber
step_trainer_df = step_trainer_df.join(
    customer_with_id_df, on="serialNumber", how="inner"
).select(step_trainer_df["*"], customer_with_id_df["customer_id"])

# Write step trainer data to Redshift
glueContext.write_dynamic_frame.from_jdbc_conf(
    frame=DynamicFrame.fromDF(step_trainer_df, glueContext, "step_trainer_dynamic_df"),
    catalog_connection=redshift_connection,
    connection_options={"dbtable": "step_trainer", "database": database_name},
    redshift_tmp_dir=redshift_tmp_dir,
)

# Read accelerometer data from Bronze S3 bucket
accelerometer_silver_df = glueContext.create_dynamic_frame.from_options(
    connection_type="s3",
    connection_options={"paths": ["s3://stedi-etl/bronze/accelerometer/"]},
    format="json",
)

# Convert accelerometer DynamicFrame to DataFrame
accelerometer_df = accelerometer_silver_df.toDF()

# Remove duplicates based on timestamp and user
accelerometer_df = accelerometer_df.dropDuplicates(["timestamp", "user"])

# Join accelerometer data with customer data from Redshift on user (email)
accelerometer_df = accelerometer_df.join(
    customer_with_id_df,
    accelerometer_df["user"] == customer_with_id_df["email"],
    "inner",
).select(accelerometer_df["*"], customer_with_id_df["customer_id"])

# Write accelerometer data to Redshift
glueContext.write_dynamic_frame.from_jdbc_conf(
    frame=DynamicFrame.fromDF(
        accelerometer_df, glueContext, "accelerometer_dynamic_df"
    ),
    catalog_connection=redshift_connection,
    connection_options={"dbtable": "accelerometer", "database": database_name},
    redshift_tmp_dir=redshift_tmp_dir,
)

job.commit()
