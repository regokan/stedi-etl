resource "aws_glue_job" "stedi_gold" {
  name     = "stedi_gold"
  role_arn = var.stedi_etl_gold_role_arn

  command {
    script_location = "s3://${var.stedi_etl_bucket}/glue/gold/scripts/main.py"
    python_version  = "3"
  }

  default_arguments = {
    "--TempDir"                          = "s3://${var.stedi_etl_bucket}/glue/gold/temp/redshift/"
    "--output-dir"                       = "s3://${var.stedi_etl_bucket}/glue/gold/output/redshift/"
    "--job-bookmark-option"              = "job-bookmark-enable"
    "--continuous-log-logGroup"          = "/aws-glue/jobs/logs"
    "--continuous-log-logStreamPrefix"   = "stedi_gold"
    "--enable-continuous-cloudwatch-log" = "true"
    "--enable-continuous-log-filter"     = "true"
  }

  max_retries       = 0
  timeout           = 480
  worker_type       = "G.1X"
  number_of_workers = 2

  tags = {
    Name        = "stedi_gold"
    Project     = "stedi_etl"
    Owner       = "DataEngg"
    Stage       = "ETL"
    Environment = "Production"
  }
}
