resource "aws_glue_crawler" "customer_trusted_crawler" {
  name          = "customer_trusted_crawler"
  role          = var.stedi_glue_crawler_role_arn
  database_name = aws_glue_catalog_database.customer_trusted.name
  table_prefix  = "trusted_"

  s3_target {
    path = "s3://stedi-etl/bronze/customer/"
  }

  schema_change_policy {
    delete_behavior = "LOG"
    update_behavior = "UPDATE_IN_DATABASE"
  }

  tags = {
    Name        = "customer_trusted_crawler"
    Project     = "stedi_etl"
    Owner       = "DataEngg"
    Stage       = "ETL"
    Environment = "Production"
  }
}

resource "aws_glue_crawler" "accelerometer_trusted_crawler" {
  name          = "accelerometer_trusted_crawler"
  role          = var.stedi_glue_crawler_role_arn
  database_name = aws_glue_catalog_database.accelerometer_trusted.name
  table_prefix  = "trusted_"

  s3_target {
    path = "s3://stedi-etl/bronze/accelerometer/"
  }

  schema_change_policy {
    delete_behavior = "LOG"
    update_behavior = "UPDATE_IN_DATABASE"
  }

  tags = {
    Name        = "accelerometer_trusted_crawler"
    Project     = "stedi_etl"
    Owner       = "DataEngg"
    Stage       = "ETL"
    Environment = "Production"
  }
}

resource "aws_glue_crawler" "step_trainer_trusted_crawler" {
  name          = "step_trainer_trusted_crawler"
  role          = var.stedi_glue_crawler_role_arn
  database_name = aws_glue_catalog_database.step_trainer_trusted.name
  table_prefix  = "trusted_"

  s3_target {
    path = "s3://stedi-etl/bronze/step_trainer/"
  }

  schema_change_policy {
    delete_behavior = "LOG"
    update_behavior = "UPDATE_IN_DATABASE"
  }

  tags = {
    Name        = "step_trainer_trusted_crawler"
    Project     = "stedi_etl"
    Owner       = "DataEngg"
    Stage       = "ETL"
    Environment = "Production"
  }
}
