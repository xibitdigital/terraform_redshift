locals {
  sg_name_prefix = "redshift-sg"
  s3_name_prefix = "redshift-s3-access-logs"
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

######
# S3 bucket
######
data "aws_iam_policy_document" "s3_redshift" {
  statement {
    sid       = "RedshiftAcl"
    actions   = ["s3:GetBucketAcl"]
    resources = [module.s3_logs.s3_bucket_arn]

    principals {
      type        = "AWS"
      identifiers = [data.aws_redshift_service_account.this.arn]
    }
  }

  statement {
    sid       = "RedshiftWrite"
    actions   = ["s3:PutObject"]
    resources = ["${module.s3_logs.s3_bucket_arn}/*"]
    condition {
      test     = "StringEquals"
      values   = ["bucket-owner-full-control"]
      variable = "s3:x-amz-acl"
    }

    principals {
      type        = "AWS"
      identifiers = [data.aws_redshift_service_account.this.arn]
    }
  }
}


resource "aws_kms_key" "redshift" {
  description             = "Customer managed key for encrypting Redshift cluster"
  deletion_window_in_days = 7
  enable_key_rotation     = true

  tags = local.default_tags
}

# resource "aws_kms_key" "redshift_snapshots" {
#   provider = aws.us_east_1

#   description             = "Customer managed key for encrypting Redshift snapshot cross-region"
#   deletion_window_in_days = 7
#   enable_key_rotation     = true

#   tags = local.tags
# }


module "s3_logs" {
  source = "terraform-aws-modules/s3-bucket/aws"
  # version = "~> 2.0"

  bucket = local.s3_name_prefix
  acl    = "log-delivery-write"

  attach_policy = true
  policy        = data.aws_iam_policy_document.s3_redshift.json

  attach_deny_insecure_transport_policy = true
  force_destroy                         = true

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  tags = local.default_tags
}
###########################
# Security group
###########################
module "sg" {
  source  = "terraform-aws-modules/security-group/aws//modules/redshift"
  version = "~> 4.0"

  name   = local.sg_name_prefix
  vpc_id = var.vpc_id

  # Allow ingress rules to be accessed only within current VPC
  ingress_cidr_blocks = var.vpc_cidr_block

  # Allow all rules for all protocols
  egress_rules = ["all-all"]

  tags = merge(local.default_tags, tomap({
    "Name" = format("%s", "${local.sg_name_prefix}-${var.cluster_name}")
  }))
}

###########
# Redshift
###########
data "aws_redshift_service_account" "this" {}

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
  enable_logging      = true
  logging_bucket_name = module.s3_logs.s3_bucket_id
  kms_key_id          = aws_kms_key.redshift.arn

  # enanched routing https://github.com/terraform-aws-modules/terraform-aws-redshift/blob/master/variables.tf#L207
  enhanced_vpc_routing = true

  enable_case_sensitive_identifier = true # eanbled as best practice

  elastic_ip = null # redshift as database should always stay behind a VPC private subnet 

  wlm_json_configuration = var.wlm_json_configuration
  subnets                = var.vpc_subnets
  vpc_security_group_ids = [module.sg.security_group_id]

  tags = merge(local.default_tags, tomap({
    "Name" = format("%s", var.cluster_name)
  }))
}
