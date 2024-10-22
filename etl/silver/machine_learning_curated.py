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

# Read step trainer data from the silver (curated) layer in S3
step_trainer_silver_df = spark.read.json("s3://stedi-etl/silver/step_trainer/")

# Read accelerometer data from the bronze (trusted) layer in S3
accelerometer_bronze_df = spark.read.json("s3://stedi-etl/bronze/accelerometer/")

# Perform an inner join on sensorreadingtime and timestamp
joined_df = step_trainer_silver_df.join(
    accelerometer_bronze_df,
    step_trainer_silver_df.sensorReadingTime == accelerometer_bronze_df.timestamp,
    "inner",
).select(step_trainer_silver_df["*"], accelerometer_bronze_df["*"])

# Write the resulting data to the curated zone (gold layer)
joined_df.write.mode("overwrite").json("s3://stedi-etl/silver/machine_learning/")

job.commit()
