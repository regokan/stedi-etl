import sys
from awsglue.transforms import *
from awsglue.utils import getResolvedOptions
from pyspark.context import SparkContext
from awsglue.context import GlueContext
from awsglue.job import Job

# Initialize Glue Context
args = getResolvedOptions(sys.argv, ["JOB_NAME"])
sc = SparkContext()
glueContext = GlueContext(sc)
spark = glueContext.spark_session
job = Job(glueContext)
job.init(args["JOB_NAME"], args)

# Read step trainer data from the bronze layer in S3
step_trainer_bronze_df = spark.read.json("s3://stedi-etl/bronze/step_trainer/")

# Read customer curated data from the silver layer in S3
customer_silver_df = spark.read.json("s3://stedi-etl/silver/customer/")

# Perform an inner join on serialNumber and retain only step trainer columns
step_trainer_trusted_df = step_trainer_bronze_df.join(
    customer_silver_df,
    step_trainer_bronze_df.serialNumber == customer_silver_df.serialNumber,
    "inner",
).select(step_trainer_bronze_df["*"])

# Write the trusted step trainer data to the silver zone
step_trainer_trusted_df.write.mode("overwrite").json(
    "s3://stedi-etl/silver/step_trainer/"
)

job.commit()
