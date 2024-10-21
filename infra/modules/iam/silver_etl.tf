resource "aws_iam_role" "etl_silver_role" {
  name = "etl_silver_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "glue.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    Name        = "etl_silver_role"
    Project     = "stedi_etl"
    Owner       = "DataEngg"
    Stage       = "ETL"
    Environment = "Production"
  }
}

resource "aws_iam_policy" "etl_silver_policy" {
  name = "etl_silver_policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "glue:*",
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:ListBucket",
        ]
        Resource = [
          "arn:aws:s3:::${var.stedi_etl_bucket}",
          "arn:aws:s3:::${var.stedi_etl_bucket}/*"
        ]
      }
    ]
  })

  tags = {
    Name        = "etl_silver_policy"
    Project     = "stedi_etl"
    Owner       = "DataEngg"
    Stage       = "ETL"
    Environment = "Production"
  }
}

resource "aws_iam_role_policy_attachment" "etl_silver_role_policy_attach" {
  role       = aws_iam_role.etl_silver_role.name
  policy_arn = aws_iam_policy.etl_silver_policy.arn
}
