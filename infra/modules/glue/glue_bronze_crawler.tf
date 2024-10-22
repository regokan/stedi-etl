resource "aws_glue_crawler" "customer_landing_crawler" {
  name          = "customer_landing_crawler"
  role          = var.stedi_glue_crawler_role_arn
  database_name = aws_glue_catalog_database.customer_landing.name
  table_prefix = "landing_"

  s3_target {
    path = "s3://stedi-etl/ingestion/customer/"
  }

  schema_change_policy {
    delete_behavior = "LOG"
    update_behavior = "UPDATE_IN_DATABASE"
  }

  tags = {
    Name        = "customer_landing_crawler"
    Project     = "stedi_etl"
    Owner       = "DataEngg"
    Stage       = "ETL"
    Environment = "Production"
  }
}

resource "aws_glue_crawler" "accelerometer_landing_crawler" {
  name          = "accelerometer_landing_crawler"
  role          = var.stedi_glue_crawler_role_arn
  database_name = aws_glue_catalog_database.accelerometer_landing.name
  table_prefix = "landing_"

  s3_target {
    path = "s3://stedi-etl/ingestion/accelerometer/"
  }

  schema_change_policy {
    delete_behavior = "LOG"
    update_behavior = "UPDATE_IN_DATABASE"
  }

  tags = {
    Name        = "accelerometer_landing_crawler"
    Project     = "stedi_etl"
    Owner       = "DataEngg"
    Stage       = "ETL"
    Environment = "Production"
  }
}

resource "aws_glue_crawler" "step_trainer_landing_crawler" {
  name          = "step_trainer_landing_crawler"
  role          = var.stedi_glue_crawler_role_arn
  database_name = aws_glue_catalog_database.step_trainer_landing.name
  table_prefix = "landing_"

  s3_target {
    path = "s3://stedi-etl/ingestion/step_trainer/"
  }

  schema_change_policy {
    delete_behavior = "LOG"
    update_behavior = "UPDATE_IN_DATABASE"
  }

  tags = {
    Name        = "step_trainer_landing_crawler"
    Project     = "stedi_etl"
    Owner       = "DataEngg"
    Stage       = "ETL"
    Environment = "Production"
  }
}
