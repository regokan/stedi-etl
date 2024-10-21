resource "aws_glue_job" "stedi_etl_bronze_customer" {
  name     = "stedi_etl_bronze_customer"
  role_arn = var.stedi_etl_bronze_role_arn

  command {
    script_location = "s3://${var.stedi_etl_bucket}/glue/bronze/scripts/customer.py"
    python_version  = "3"
  }

  default_arguments = {
    "--TempDir"                          = "s3://${var.stedi_etl_bucket}/glue/bronze/temp/customer/"
    "--output-dir"                       = "s3://${var.stedi_etl_bucket}/glue/bronze/output/customer/"
    "--job-bookmark-option"              = "job-bookmark-enable"
    "--continuous-log-logGroup"          = "/aws-glue/jobs/logs"
    "--continuous-log-logStreamPrefix"   = "stedi_etl_bronze_customer"
    "--enable-continuous-cloudwatch-log" = "true"
    "--enable-continuous-log-filter"     = "true"
  }

  max_retries       = 0
  timeout           = 480
  worker_type       = "G.1X"
  number_of_workers = 2

  tags = {
    Name        = "stedi_etl_bronze_customer"
    Project     = "stedi_etl"
    Owner       = "DataEngg"
    Stage       = "ETL"
    Environment = "Production"
  }
}
