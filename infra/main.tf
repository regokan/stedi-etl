terraform {
  backend "s3" {
    bucket = "stedi-etl-tf-state"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}
