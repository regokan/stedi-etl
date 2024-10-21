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

  aws_account_id   = data.aws_caller_identity.current.account_id
  aws_region       = data.aws_region.current.name
  stedi_etl_bucket = module.s3.stedi_etl_bucket
}

module "glue" {
  source = "./modules/glue"

  stedi_etl_bucket               = module.s3.stedi_etl_bucket
  stedi_etl_bronze_role_arn      = module.iam.stedi_etl_bronze_role_arn
  stedi_etl_silver_role_arn      = module.iam.stedi_etl_silver_role_arn
  stedi_etl_gold_role_arn        = module.iam.stedi_etl_gold_role_arn
}

module "redshift" {
  source = "./modules/redshift"

  redshift_master_username    = var.redshift_master_username
  redshift_master_password    = var.redshift_master_password
  stedi_etl_security_group_id = aws_security_group.stedi_etl_security_group.id
  stedi_etl_subnet_group_name = aws_redshift_subnet_group.stedi_redshift_subnet_group.name
}
