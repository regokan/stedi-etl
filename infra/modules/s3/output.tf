output "stedi_etl_bucket" {
  value = aws_s3_bucket.stedi_etl.bucket
}

output "stedi_etl_bucket_arn" {
  value = aws_s3_bucket.stedi_etl.arn
}

output "stedi_etl_bucket_id" {
  value = aws_s3_bucket.stedi_etl.id
}
