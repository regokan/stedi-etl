resource "aws_glue_catalog_database" "customer_landing" {
  name = "customer_landing"

  tags = {
    Name        = "customer_landing"
    Project     = "stedi_etl"
    Owner       = "DataEngg"
    Stage       = "ETL"
    Environment = "Production"
  }
}

resource "aws_glue_catalog_database" "accelerometer_landing" {
  name = "accelerometer_landing"

  tags = {
    Name        = "accelerometer_landing"
    Project     = "stedi_etl"
    Owner       = "DataEngg"
    Stage       = "ETL"
    Environment = "Production"
  }
}

resource "aws_glue_catalog_database" "step_trainer_landing" {
  name = "step_trainer_landing"

  tags = {
    Name        = "step_trainer_landing"
    Project     = "stedi_etl"
    Owner       = "DataEngg"
    Stage       = "ETL"
    Environment = "Production"
  }
}
