variable "cluster_name" {
  description = "Custom name of the cluster"
  type        = string
}
variable "node_type" {
  description = "Node Type of Redshift cluster"
  type        = string
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

variable "region" {
  description = "AWS region"
  type        = string
}
