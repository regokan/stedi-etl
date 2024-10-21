terraform {
  backend "s3" {
    bucket = "stedi-etl-tf-state"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}

module "s3" {
  source = "./modules/s3"
}

module "iam" {
  source = "./modules/iam"

  stedi_etl_bucket = module.s3.stedi_etl_bucket
}

module "glue" {
  source = "./modules/glue"

  stedi_etl_bucket          = module.s3.stedi_etl_bucket
  stedi_etl_bronze_role_arn = module.iam.stedi_etl_bronze_role_arn
}
