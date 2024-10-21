# Specify the Redshift Cluster and Database
resource "aws_redshift_cluster" "stedi_redshift_cluster" {
  cluster_identifier = "stedi-redshift-cluster"
  database_name      = "stedi_db"
  master_username    = var.redshift_master_username
  master_password    = var.redshift_master_password
  node_type          = "dc2.large"
  cluster_type       = "single-node"

  vpc_security_group_ids    = [var.stedi_etl_security_group_id]
  cluster_subnet_group_name = var.stedi_etl_subnet_group_name
}
