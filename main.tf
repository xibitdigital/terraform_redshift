locals {
  sg_name = "redshift-sg"
}

######
# Root credentials
######
resource "random_string" "root_username" {
  length    = 8
  special   = false
  number    = false
  min_lower = 8
}

resource "random_string" "root_password" {
  length  = 16
  special = false
}

###########################
# Security group
###########################
module "sg" {
  source  = "terraform-aws-modules/security-group/aws//modules/redshift"
  version = "~> 4.0"

  name   = local.sg_name
  vpc_id = var.vpc_id

  # Allow ingress rules to be accessed only within current VPC
  ingress_cidr_blocks = var.vpc_cidr_block

  # Allow all rules for all protocols
  egress_rules = ["all-all"]

  tags = merge(local.default_tags, tomap({
    "Name" = format("%s", "${var.cluster_name}-${local.sg_name}")
  }))
}

###########
# Redshift
###########
module "redshift" {
  source  = "terraform-aws-modules/redshift/aws"
  version = "~> 3.0"

  cluster_identifier      = var.cluster_name
  cluster_node_type       = var.node_type
  cluster_number_of_nodes = var.cluster_nodes
  cluster_database_name   = var.db_name
  cluster_master_username = random_string.root_username.result
  cluster_master_password = random_string.root_password.result

  enable_user_activity_logging = "true" # default to true as best practice
  encrypted                    = true   # default to true as best practice

  # logging https://github.com/terraform-aws-modules/terraform-aws-redshift/blob/master/variables.tf#L115
  # if true create s3 bucket
  # enable also kms on the bucket https://github.com/terraform-aws-modules/terraform-aws-redshift/blob/master/variables.tf#L201

  # enanched routing https://github.com/terraform-aws-modules/terraform-aws-redshift/blob/master/variables.tf#L207

  enable_case_sensitive_identifier = true

  elastic_ip = null # redshift as database should always stay behind a private VPC

  wlm_json_configuration = var.wlm_json_configuration
  subnets                = var.vpc_subnets
  vpc_security_group_ids = [module.sg.security_group_id]

  tags = merge(local.default_tags, tomap({
    "Name" = format("%s", var.cluster_name)
  }))
}
