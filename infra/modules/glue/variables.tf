variable "stedi_etl_bronze_role_arn" {
  description = "AWS Role ARN for Glue Bronze Job"
  type        = string
}

variable "stedi_etl_bucket" {
  description = "Stedi ETL S3 bucket name"
  type        = string
}
