resource "aws_glue_catalog_database" "customer_trusted" {
  name = "customer_trusted"

  tags = {
    Name        = "customer_trusted"
    Project     = "stedi_etl"
    Owner       = "DataEngg"
    Stage       = "ETL"
    Environment = "Production"
  }
}

resource "aws_glue_catalog_database" "accelerometer_trusted" {
  name = "accelerometer_trusted"

  tags = {
    Name        = "accelerometer_trusted"
    Project     = "stedi_etl"
    Owner       = "DataEngg"
    Stage       = "ETL"
    Environment = "Production"
  }
}

resource "aws_glue_catalog_database" "step_trainer_trusted" {
  name = "step_trainer_trusted"

  tags = {
    Name        = "step_trainer_trusted"
    Project     = "stedi_etl"
    Owner       = "DataEngg"
    Stage       = "ETL"
    Environment = "Production"
  }
}
