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

# Read accelerometer data from S3 (jsonl format)
accelerometer_df = spark.read.json("s3://stedi-etl/ingestion/accelerometer/*.json")

# Read customer data to get research consent information
customer_df = spark.read.json("s3://stedi-etl/ingestion/customer/*.json")

# Filter out customers who haven't consented to research
consented_customers_df = customer_df.filter(
    col("shareWithResearchAsOfDate").isNotNull()
)
consented_users = (
    consented_customers_df.select("email").rdd.flatMap(lambda x: x).collect()
)

# Filter accelerometer data for consented users
filtered_accelerometer_df = accelerometer_df.filter(col("user").isin(consented_users))

# Write the filtered data back to S3 bronze/ folder
filtered_accelerometer_df.write.mode("overwrite").json(
    "s3://stedi-etl/bronze/accelerometer/"
)

job.commit()
