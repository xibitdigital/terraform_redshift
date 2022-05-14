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

variable "cluster_iam_roles" {
  description = "A list of IAM Role ARNs to associate with the cluster. A Maximum of 10 can be associated to the cluster at any time."
  type        = list(string)
  default     = []
}

variable "final_snapshot_identifier" {
  description = "(Optional) The identifier of the final snapshot that is to be created immediately before deleting the cluster. If this parameter is provided, 'skip_final_snapshot' must be false."
  type        = string
  default     = ""
}

variable "skip_final_snapshot" {
  description = "If true (default), no snapshot will be made before deleting DB"
  type        = bool
  default     = true
}

variable "automated_snapshot_retention_period" {
  description = "How long will we retain backups"
  type        = number
  default     = 0
}

variable "snapshot_identifier" {
  description = "(Optional) The name of the snapshot from which to create the new cluster."
  type        = string
  default     = null
}

variable "snapshot_cluster_identifier" {
  description = "(Optional) The name of the cluster the source snapshot was created from."
  type        = string
  default     = null
}

variable "snapshot_copy_destination_region" {
  description = "(Optional) The name of the region where the snapshot will be copied."
  type        = string
  default     = null
}

variable "snapshot_copy_grant_name" {
  description = "(Optional) The name of the grant in the destination region. Required if you have a KMS encrypted cluster."
  type        = string
  default     = null
}

variable "owner_account" {
  description = "(Optional) The AWS customer account used to create or copy the snapshot. Required if you are restoring a snapshot you do not own, optional if you own the snapshot."
  type        = string
  default     = null
}

variable "allow_version_upgrade" {
  description = "(Optional) If true, major version upgrades can be applied during the maintenance window to the Amazon Redshift engine that is running on the cluster."
  type        = bool
  default     = true
}

variable "preferred_maintenance_window" {
  description = "When AWS can run snapshot, can't overlap with maintenance window"
  type        = string
  default     = "sat:10:00-sat:10:30"
}

variable "max_concurrency_scaling_clusters" {
  description = "(Optional) Max concurrency scaling clusters parameter (0 to 10)"
  type        = string
  default     = "1"
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
