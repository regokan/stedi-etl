resource "aws_iam_role" "etl_gold_role" {
  name = "etl_gold_role"

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
    Name        = "etl_gold_role"
    Project     = "stedi_etl"
    Owner       = "DataEngg"
    Stage       = "ETL"
    Environment = "Production"
  }
}

resource "aws_iam_policy" "etl_gold_policy" {
  name = "etl_gold_policy"
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
      },
      {
        Effect = "Allow"
        Action = [
          "redshift:GetClusterCredentials",
          "redshift:DescribeClusters"
        ]
        Resource = ["*"]
      },
      {
        Effect   = "Allow"
        Action   = "redshift:ExecuteStatement",
        Resource = ["*"]
      },
      {
        Effect = "Allow"
        Action = [
          "redshift-data:GetStatementResult",
          "redshift-data:ListDatabases",
          "redshift-data:ListSchemas",
          "redshift-data:ListTables",
          "redshift-data:DescribeTable",
          "redshift-data:ExecuteStatement",
          "redshift-data:DescribeStatement",
          "redshift-data:CancelStatement",
        ]
        Resource = "*"
      },
      {
        Effect   = "Allow",
        Action   = "iam:PassRole",
        Resource = aws_iam_role.etl_gold_role.arn,
        Condition = {
          StringEquals = {
            "iam:PassedToService" : [
              "glue.amazonaws.com",
              "redshift.amazonaws.com",
            ],
          },
        },
      },
      {
        Effect = "Allow",
        Action = [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret"
        ],
        Resource = [
          "arn:aws:secretsmanager:${var.aws_region}:${var.aws_account_id}:secret:*"
        ]
      },
      {
        Effect = "Allow",
        Action = [
          "ec2:DescribeSubnets",
          "ec2:DescribeVpcs",
          "ec2:DescribeSecurityGroups"
        ],
        Resource = ["*"]
      },
    ]
  })

  tags = {
    Name        = "etl_gold_policy"
    Project     = "stedi_etl"
    Owner       = "DataEngg"
    Stage       = "ETL"
    Environment = "Production"
  }
}

resource "aws_iam_role_policy_attachment" "etl_gold_role_policy_attach" {
  role       = aws_iam_role.etl_gold_role.name
  policy_arn = aws_iam_policy.etl_gold_policy.arn
}
