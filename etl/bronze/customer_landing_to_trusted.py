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

# Read customer data from S3 (jsonl format)
customer_df = spark.read.json("s3://stedi-etl/ingestion/customer/*.json")

# Filter out customers who haven't consented to research
filtered_customer_df = customer_df.filter(col("shareWithResearchAsOfDate").isNotNull())

# Write the filtered customer data back to S3 bronze/ folder
filtered_customer_df.write.mode("overwrite").json("s3://stedi-etl/bronze/customer/")

job.commit()
