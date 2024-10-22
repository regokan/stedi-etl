output "stedi_etl_bronze_role_arn" {
  value = aws_iam_role.etl_bronze_role.arn
}

output "stedi_etl_silver_role_arn" {
  value = aws_iam_role.etl_silver_role.arn
}

output "stedi_etl_gold_role_arn" {
  value = aws_iam_role.etl_gold_role.arn
}

output "stedi_glue_crawler_role_arn" {
  value = aws_iam_role.glue_crawler_role.arn
}
