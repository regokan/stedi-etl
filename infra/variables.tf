# AWS Access Key
variable "aws_access_key" {
  description = "AWS Access Key"
  type        = string
}

# AWS Secret Key
variable "aws_secret_key" {
  description = "AWS Secret Key"
  type        = string
}

# AWS Region
variable "region" {
  description = "AWS Region"
  default     = "us-east-1"
  type        = string
}

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
