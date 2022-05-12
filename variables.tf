variable "cluster_name" {
  description = "Custom name of the cluster"
  type        = string
}
variable "node_type" {
  description = "Node Type of Redshift cluster"
  type        = string
  default     = "dc2.large" # default to the smallest instance if not defined
  # Valid Values: dc1.large | dc1.8xlarge | dc2.large | dc2.8xlarge | ds2.xlarge | ds2.8xlarge | ra3.xlplus | ra3.4xlarge | ra3.16xlarge.
  # http://docs.aws.amazon.com/cli/latest/reference/redshift/create-cluster.html
}

variable "cluster_nodes" {
  description = "Number of nodes in the cluster (values greater than 1 will trigger 'cluster_type' of 'multi-node')"
  type        = number
  default     = 1
}

variable "db_name" {
  description = "The name of the database to create"
  type        = string
}

variable "vpc_id" {
  type        = string
  description = "VPC ID"
}

variable "vpc_cidr_block" {
  type        = list(string)
  description = "VPC ID CIDR block"
}

variable "vpc_subnets" {
  description = "VPC subnets"
  type        = list(string)
}

variable "wlm_json_configuration" {
  description = "Configuration bits for WLM json. see https://docs.aws.amazon.com/redshift/latest/mgmt/workload-mgmt-config.html"
  type        = string
  default     = "[{\"query_concurrency\": 5}]"
}

variable "eip_enabled" {
  type        = bool
  description = "Whether to provision and attach an Elastic IP to be used as the SFTP endpoint, an EIP will be provisioned per subnet"
  default     = false
}

variable "environment" {
  description = "A name that identifies the enviroment you are deploying into"
  type        = string
}

variable "tags" {
  description = "A mapping of tags to assign to all resources"
  type        = map(string)
  default     = {}
}
