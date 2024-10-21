import sys
from awsglue.transforms import *
from awsglue.utils import getResolvedOptions
from pyspark.context import SparkContext
from awsglue.context import GlueContext
from awsglue.job import Job
from pyspark.sql.functions import col

# Initialize Glue Context
args = getResolvedOptions(sys.argv, ["JOB_NAME"])
sc = SparkContext()
glueContext = GlueContext(sc)
spark = glueContext.spark_session
job = Job(glueContext)
job.init(args["JOB_NAME"], args)

# Read step_trainer data from S3 (jsonl format)
step_trainer_df = spark.read.json(
    "s3://stedi-etl/ingestion/step_trainer/*.json"
)

# Read customer data to get research consent information
customer_df = spark.read.json(
    "s3://stedi-etl/ingestion/customer/*.json"
)

# Filter out customers who haven't consented to research
consented_customers_df = customer_df.filter(
    col("shareWithResearchAsOfDate").isNotNull()
)
consented_serial_numbers = (
    consented_customers_df.select("serialNumber").rdd.flatMap(lambda x: x).collect()
)

# Filter step_trainer data for consented customers
filtered_step_trainer_df = step_trainer_df.filter(
    col("serialNumber").isin(consented_serial_numbers)
)

# Write the filtered data back to S3 bronze/ folder
filtered_step_trainer_df.write.mode("overwrite").json(
    "s3://stedi-etl/bronze/step_trainer/"
)

job.commit()
