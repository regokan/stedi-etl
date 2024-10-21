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

# Read step trainer data from the bronze layer in S3
step_trainer_bronze_df = spark.read.json("s3://stedi-etl/bronze/step_trainer/")

customer_bronze_df = spark.read.json("s3://stedi-etl/bronze/customer/")

# Read accelerometer data from the silver layer in S3
step_trainer_curated_df = spark.read.json("s3://stedi-etl/silver/step_trainer/")

# Join step trainer data with customer data based on serial number
customers_curated_df = customer_bronze_df.join(
    step_trainer_curated_df,
    customer_bronze_df.serialNumber == step_trainer_curated_df.serialNumber,
    "inner",
).select(customer_bronze_df["*"])

# Write the curated customer data to the silver zone
customers_curated_df.write.mode("overwrite").json("s3://stedi-etl/silver/customer/")

job.commit()
