variable "stedi_etl_bronze_role_arn" {
  description = "AWS Role ARN for Glue Bronze Job"
  type        = string
}

variable "stedi_etl_silver_role_arn" {
  description = "AWS Role ARN for Glue Silver Job"
  type        = string
}

variable "stedi_etl_gold_role_arn" {
  description = "AWS Role ARN for Glue Gold Job"
  type        = string
}

variable "stedi_etl_bucket" {
  description = "Stedi ETL S3 bucket name"
  type        = string
}

variable "stedi_glue_crawler_role_arn" {
  description = "AWS Role ARN for Glue Crawler"
  type        = string
}
