resource "aws_s3_bucket" "stedi_etl" {
  bucket = "stedi-etl"

  tags = {
    Name        = "stedi-etl"
    Project     = "stedi_etl"
    Owner       = "DataEngg"
    Stage       = "ETL"
    Environment = "Production"
  }
}

resource "aws_s3_bucket_ownership_controls" "stedi_etl_ownership_controls" {
  bucket = aws_s3_bucket.stedi_etl.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "stedi_etl_acl" {
  depends_on = [aws_s3_bucket_ownership_controls.stedi_etl_ownership_controls]

  bucket = aws_s3_bucket.stedi_etl.id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "stedi_etl_versioning" {
  bucket = aws_s3_bucket.stedi_etl.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "stedi_etl_server_side_encryption_configuration" {
  bucket = aws_s3_bucket.stedi_etl.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "stedi_etl_lifecycle_configuration" {
  bucket = aws_s3_bucket.stedi_etl.id

  rule {
    id     = "transition-to-glacier"
    status = "Enabled"

    transition {
      days          = 30
      storage_class = "GLACIER"
    }
  }
}
