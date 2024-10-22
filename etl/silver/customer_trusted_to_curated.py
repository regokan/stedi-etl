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

# Read customer data from the bronze layer in S3
customer_bronze_df = spark.read.json("s3://stedi-etl/bronze/customer/")

# Read accelerometer data from the bronze layer in S3
accelerometer_bronze_df = spark.read.json("s3://stedi-etl/bronze/accelerometer/")

# Perform an inner join on email columns and retain only customer columns
customers_trusted_df = customer_bronze_df.join(
    accelerometer_bronze_df,
    customer_bronze_df.email == accelerometer_bronze_df.user,
    "inner",
).select(customer_bronze_df["*"])

# Write the trusted customer data to the silver zone (trusted layer)
customers_trusted_df.write.mode("overwrite").json("s3://stedi-etl/silver/customer/")

job.commit()
