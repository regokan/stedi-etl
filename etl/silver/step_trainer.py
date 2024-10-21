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

# Read accelerometer data from the bronze layer in S3 (already filtered by consent)
accelerometer_bronze_df = spark.read.json("s3://stedi-etl/bronze/accelerometer/")

# Join step trainer data with accelerometer data based on sensorReadingTime (step trainer) and timestamp (accelerometer)
step_trainer_curated_df = step_trainer_bronze_df.join(
    accelerometer_bronze_df,
    step_trainer_bronze_df.sensorReadingTime == accelerometer_bronze_df.timestamp,
    "inner",
).select(step_trainer_bronze_df["*"])

# Write the curated step trainer data to the silver zone
step_trainer_curated_df.write.mode("overwrite").json(
    "s3://stedi-etl/silver/step_trainer/"
)

job.commit()
