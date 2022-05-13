provider "aws" {
  region = var.region

  default_tags {
    tags = var.tags
  }
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 3.0"

  name = "redshift-vpc"
  cidr = "10.10.0.0/16"

  azs              = ["${var.region}a"]
  redshift_subnets = ["10.10.41.0/24", "10.10.42.0/24", "10.10.43.0/24"]
}

module "redshift" {
  source = "../../"

  vpc_id                 = module.vpc.vpc_id
  vpc_cidr_block         = [module.vpc.vpc_cidr_block]
  vpc_subnets            = module.vpc.redshift_subnets
  cluster_name           = var.cluster_name
  cluster_nodes          = var.cluster_nodes
  wlm_json_configuration = var.wlm_json_configuration
  node_type              = var.node_type
  db_name                = var.db_name

  environment = var.environment
  tags        = var.tags
}
