# Redshift Master Username
variable "redshift_master_username" {
  description = "Master username for Redshift"
  type        = string
}

# Redshift Master Password
variable "redshift_master_password" {
  description = "Master password for Redshift"
  type        = string
  sensitive   = true
}

variable "stedi_etl_security_group_id" {
  description = "Security Group ID for Stedi ETL"
  type        = string
}

variable "stedi_etl_subnet_group_name" {
  description = "Subnet Group Name for Stedi ETL"
  type        = string
}

variable "stedi_redshift_subnet_id" {
  description = "Subnet ID for Stedi Redshift"
  type        = string
  default     = "us-east-1b"
}
