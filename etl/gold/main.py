import sys
from awsglue.transforms import *
from awsglue.utils import getResolvedOptions
from pyspark.context import SparkContext
from awsglue.context import GlueContext
from awsglue.job import Job
from awsglue.dynamicframe import DynamicFrame

# Initialize Glue Context and job parameters
args = getResolvedOptions(sys.argv, ["JOB_NAME"])
sc = SparkContext()
glueContext = GlueContext(sc)
spark = glueContext.spark_session
job = Job(glueContext)
job.init(args["JOB_NAME"], args)

# Define Redshift connection details for writing data
redshift_tmp_dir = "s3://stedi-etl/glue/gold/temp/redshift/"
redshift_connection = "stedi-redshift-connection"
cluster_id = "stedi-redshift-cluster"
database_name = "stedi_db"
db_user = "redshiftuser"

# Step 1: Read machine_learning data from the Silver S3 bucket
machine_learning_silver_df = glueContext.create_dynamic_frame.from_options(
    connection_type="s3",
    connection_options={"paths": ["s3://stedi-etl/silver/machine_learning/"]},
    format="json",
)

# Step 2: Convert DynamicFrame to DataFrame for data manipulation
machine_learning_silver_df = machine_learning_silver_df.toDF()

# Step 3: Remove 'timestamp' column and drop duplicates based on all remaining columns
# This will ensure we remove any duplicate rows based on the distinct combination of all columns except 'timestamp'.
columns_to_consider = [
    "distancefromobject",
    "sensorreadingtime",
    "serialnumber",
    "user",
    "x",
    "y",
    "z",
]
machine_learning_silver_df = machine_learning_silver_df.drop(
    "timestamp"
).dropDuplicates(columns_to_consider)

# Step 4: Write the cleaned data to Redshift in the 'customer' table
# Data will be loaded into the Redshift cluster and 'customer_id' will be generated automatically.
glueContext.write_dynamic_frame.from_jdbc_conf(
    frame=DynamicFrame.fromDF(
        machine_learning_silver_df, glueContext, "machine_learning_silver_df"
    ),
    catalog_connection=redshift_connection,
    connection_options={"dbtable": "customer", "database": database_name},
    redshift_tmp_dir=redshift_tmp_dir,
)

# Commit the job after all transformations and writes are completed
job.commit()
