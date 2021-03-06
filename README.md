# Terraform Redshift module

This module creates all resurces for the AWS Redshift service.

#### Table of Contents
1. [Usage](#usage)
2. [Requirements](#requirements)
3. [Providers](#providers)
4. [Modules](#modules)
5. [Resources](#resources)
6. [Inputs](#inputs)
7. [Outputs](#outputs)

## Usage


```
module "redshift" {
  source = "../../"

  vpc_id                 = module.vpc.vpc_id
  vpc_cidr_block         = [module.vpc.vpc_cidr_block]
  vpc_subnets            = module.vpc.redshift_subnets
  cluster_name           = var.cluster_name
  db_name                = var.db_name

  environment = var.environment
  tags        = var.tags
}
```

Please have a look at the in the examples folder for examples.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.12.31 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.57.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 3.57.0 |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_redshift"></a> [redshift](#module\_redshift) | terraform-aws-modules/redshift/aws | ~> 3.0 |
| <a name="module_redshift_s3_logs"></a> [redshift\_s3\_logs](#module\_redshift\_s3\_logs) | terraform-aws-modules/s3-bucket/aws | ~> 2.0 |
| <a name="module_redshift_sg"></a> [redshift\_sg](#module\_redshift\_sg) | terraform-aws-modules/security-group/aws//modules/redshift | ~> 4.0 |

## Resources

| Name | Type |
|------|------|
| [aws_kms_key.redshift](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [random_string.root_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [random_string.root_username](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [aws_iam_policy_document.s3_redshift](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_redshift_service_account.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/redshift_service_account) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allow_version_upgrade"></a> [allow\_version\_upgrade](#input\_allow\_version\_upgrade) | (Optional) If true, major version upgrades can be applied during the maintenance window to the Amazon Redshift engine that is running on the cluster. | `bool` | `true` | no |
| <a name="input_automated_snapshot_retention_period"></a> [automated\_snapshot\_retention\_period](#input\_automated\_snapshot\_retention\_period) | How long will we retain backups | `number` | `0` | no |
| <a name="input_cluster_iam_roles"></a> [cluster\_iam\_roles](#input\_cluster\_iam\_roles) | A list of IAM Role ARNs to associate with the cluster. A Maximum of 10 can be associated to the cluster at any time. | `list(string)` | `[]` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Custom name of the cluster | `string` | n/a | yes |
| <a name="input_cluster_nodes"></a> [cluster\_nodes](#input\_cluster\_nodes) | Number of nodes in the cluster (values greater than 1 will trigger 'cluster\_type' of 'multi-node') | `number` | `1` | no |
| <a name="input_db_name"></a> [db\_name](#input\_db\_name) | The name of the database to create | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | A name that identifies the enviroment you are deploying into | `string` | n/a | yes |
| <a name="input_final_snapshot_identifier"></a> [final\_snapshot\_identifier](#input\_final\_snapshot\_identifier) | (Optional) The identifier of the final snapshot that is to be created immediately before deleting the cluster. If this parameter is provided, 'skip\_final\_snapshot' must be false. | `string` | `""` | no |
| <a name="input_max_concurrency_scaling_clusters"></a> [max\_concurrency\_scaling\_clusters](#input\_max\_concurrency\_scaling\_clusters) | (Optional) Max concurrency scaling clusters parameter (0 to 10) | `string` | `"1"` | no |
| <a name="input_node_type"></a> [node\_type](#input\_node\_type) | Node Type of Redshift cluster | `string` | `"dc2.large"` | no |
| <a name="input_owner_account"></a> [owner\_account](#input\_owner\_account) | (Optional) The AWS customer account used to create or copy the snapshot. Required if you are restoring a snapshot you do not own, optional if you own the snapshot. | `string` | `null` | no |
| <a name="input_preferred_maintenance_window"></a> [preferred\_maintenance\_window](#input\_preferred\_maintenance\_window) | When AWS can run snapshot, can't overlap with maintenance window | `string` | `"sat:10:00-sat:10:30"` | no |
| <a name="input_skip_final_snapshot"></a> [skip\_final\_snapshot](#input\_skip\_final\_snapshot) | If true (default), no snapshot will be made before deleting DB | `bool` | `true` | no |
| <a name="input_snapshot_cluster_identifier"></a> [snapshot\_cluster\_identifier](#input\_snapshot\_cluster\_identifier) | (Optional) The name of the cluster the source snapshot was created from. | `string` | `null` | no |
| <a name="input_snapshot_copy_destination_region"></a> [snapshot\_copy\_destination\_region](#input\_snapshot\_copy\_destination\_region) | (Optional) The name of the region where the snapshot will be copied. | `string` | `null` | no |
| <a name="input_snapshot_copy_grant_name"></a> [snapshot\_copy\_grant\_name](#input\_snapshot\_copy\_grant\_name) | (Optional) The name of the grant in the destination region. Required if you have a KMS encrypted cluster. | `string` | `null` | no |
| <a name="input_snapshot_identifier"></a> [snapshot\_identifier](#input\_snapshot\_identifier) | (Optional) The name of the snapshot from which to create the new cluster. | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A mapping of tags to assign to all resources | `map(string)` | `{}` | no |
| <a name="input_vpc_cidr_block"></a> [vpc\_cidr\_block](#input\_vpc\_cidr\_block) | VPC ID CIDR block | `list(string)` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC ID | `string` | n/a | yes |
| <a name="input_vpc_subnets"></a> [vpc\_subnets](#input\_vpc\_subnets) | VPC subnets | `list(string)` | n/a | yes |
| <a name="input_wlm_json_configuration"></a> [wlm\_json\_configuration](#input\_wlm\_json\_configuration) | Configuration bits for WLM json. see https://docs.aws.amazon.com/redshift/latest/mgmt/workload-mgmt-config.html | `string` | `"[{\"query_concurrency\": 5}]"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_redshift_cluster_endpoint"></a> [redshift\_cluster\_endpoint](#output\_redshift\_cluster\_endpoint) | Redshift endpoint |
| <a name="output_redshift_cluster_hostname"></a> [redshift\_cluster\_hostname](#output\_redshift\_cluster\_hostname) | Redshift hostname |
| <a name="output_redshift_cluster_id"></a> [redshift\_cluster\_id](#output\_redshift\_cluster\_id) | The availability zone of the RDS instance |
| <a name="output_redshift_cluster_port"></a> [redshift\_cluster\_port](#output\_redshift\_cluster\_port) | Redshift port |
| <a name="output_security_group_id"></a> [security\_group\_id](#output\_security\_group\_id) | The ID of the security group |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
