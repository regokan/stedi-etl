resource "aws_glue_crawler" "customer_curated_crawler" {
  name          = "customer_curated_crawler"
  role          = var.stedi_glue_crawler_role_arn
  database_name = aws_glue_catalog_database.customer_curated.name
  table_prefix  = "curated_"

  s3_target {
    path = "s3://stedi-etl/silver/customer/"
  }

  schema_change_policy {
    delete_behavior = "LOG"
    update_behavior = "UPDATE_IN_DATABASE"
  }

  tags = {
    Name        = "customer_curated_crawler"
    Project     = "stedi_etl"
    Owner       = "DataEngg"
    Stage       = "ETL"
    Environment = "Production"
  }
}

resource "aws_glue_crawler" "machine_learning_curated_crawler" {
  name          = "machine_learning_curated_crawler"
  role          = var.stedi_glue_crawler_role_arn
  database_name = aws_glue_catalog_database.machine_learning_curated.name
  table_prefix  = "curated_"

  s3_target {
    path = "s3://stedi-etl/silver/machine_learning/"
  }

  schema_change_policy {
    delete_behavior = "LOG"
    update_behavior = "UPDATE_IN_DATABASE"
  }

  tags = {
    Name        = "machine_learning_curated_crawler"
    Project     = "stedi_etl"
    Owner       = "DataEngg"
    Stage       = "ETL"
    Environment = "Production"
  }
}

resource "aws_glue_crawler" "step_trainer_curated_crawler" {
  name          = "step_trainer_curated_crawler"
  role          = var.stedi_glue_crawler_role_arn
  database_name = aws_glue_catalog_database.step_trainer_curated.name
  table_prefix  = "curated_"

  s3_target {
    path = "s3://stedi-etl/silver/step_trainer/"
  }

  schema_change_policy {
    delete_behavior = "LOG"
    update_behavior = "UPDATE_IN_DATABASE"
  }

  tags = {
    Name        = "step_trainer_curated_crawler"
    Project     = "stedi_etl"
    Owner       = "DataEngg"
    Stage       = "ETL"
    Environment = "Production"
  }
}
