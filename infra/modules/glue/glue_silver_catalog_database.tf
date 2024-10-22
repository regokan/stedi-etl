resource "aws_glue_catalog_database" "customer_curated" {
  name = "customer_curated"

  tags = {
    Name        = "customer_curated"
    Project     = "stedi_etl"
    Owner       = "DataEngg"
    Stage       = "ETL"
    Environment = "Production"
  }
}

resource "aws_glue_catalog_database" "machine_learning_curated" {
  name = "machine_learning_curated"

  tags = {
    Name        = "machine_learning_curated"
    Project     = "stedi_etl"
    Owner       = "DataEngg"
    Stage       = "ETL"
    Environment = "Production"
  }
}

resource "aws_glue_catalog_database" "step_trainer_curated" {
  name = "step_trainer_curated"

  tags = {
    Name        = "step_trainer_curated"
    Project     = "stedi_etl"
    Owner       = "DataEngg"
    Stage       = "ETL"
    Environment = "Production"
  }
}
