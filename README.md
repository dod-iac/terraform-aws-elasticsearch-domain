<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Usage

Creates an Amazon Elasticsearch Service domain with secure defaults.  This module always requires node-to-node encryption, encryption at rest, HTTPS endpoints, and use of a VPC.

```hcl
module "elasticsearch_domain" {
  source = "dod-iac/elasticsearch-domain/aws"

  domain_name = format("app-%s-%s", var.application, var.environment)
  kms_key_id = var.kms_key_id
  subnet_ids = slice(module.vpc.private_subnets, 0, 1)
  security_group_ids = [aws_security_group.elasticsearch.id]
  tags = {
    Application = var.application
    Environment = var.environment
    Automation  = "Terraform"
  }
}
```

The IAM service-linked role for Amazon Elasticsearch Service is required before you can create a domain.  If the role does not exist, then you can create the role with the following resource.

```hcl
resource "aws_iam_service_linked_role" "main" {
  aws_service_name = "es.amazonaws.com"
}
```

## Terraform Version

Terraform 0.12. Pin module version to ~> 1.0.0 . Submit pull-requests to master branch.

Terraform 0.11 is not supported.

## License

This project constitutes a work of the United States Government and is not subject to domestic copyright protection under 17 USC § 105.  However, because the project utilizes code licensed from contributors and other third parties, it therefore is licensed under the MIT License.  See LICENSE file for more information.

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.13 |
| aws | ~> 3.0 |

## Providers

| Name | Version |
|------|---------|
| aws | ~> 3.0 |

## Modules

No Modules.

## Resources

| Name |
|------|
| [aws_caller_identity](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) |
| [aws_elasticsearch_domain](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticsearch_domain) |
| [aws_iam_policy_document](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) |
| [aws_partition](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/partition) |
| [aws_region](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| access\_policies | IAM policy document specifying the access policies for the domain. | `string` | `""` | no |
| automated\_snapshot\_start\_hour | Hour during which the service takes an automated daily snapshot of the indices in the domain. | `string` | `23` | no |
| domain\_name | Name of the domain. | `string` | n/a | yes |
| elasticsearch\_version | The version of Elasticsearch to deploy. | `string` | `"7.7"` | no |
| instance\_count | Number of instances in the cluster. | `number` | `1` | no |
| instance\_type | Instance type of data nodes in the cluster. | `string` | `"r5.large.elasticsearch"` | no |
| kms\_key\_id | The KMS key id to encrypt the Elasticsearch domain with. If not specified then it defaults to using the aws/es service KMS key. | `string` | `""` | no |
| security\_group\_ids | List of VPC Security Group IDs to be applied to the Elasticsearch domain endpoints. If omitted, the default Security Group for the VPC will be used. | `list(string)` | `null` | no |
| subnet\_ids | List of VPC Subnet IDs for the Elasticsearch domain endpoints to be created in. | `list(string)` | `[]` | no |
| tags | Tags applied to the KMS key. | `map(string)` | `{}` | no |
| tls\_security\_policy | The name of the TLS security policy that needs to be applied to the HTTPS endpoint. Valid values: Policy-Min-TLS-1-0-2019-07 and Policy-Min-TLS-1-2-2019-07. Terraform will only perform drift detection if a configuration value is provided. | `string` | `"Policy-Min-TLS-1-2-2019-07"` | no |
| volume\_size | The size of EBS volumes attached to data nodes (in GB). Required if ebs\_enabled is set to true. | `number` | `20` | no |
| volume\_type | The type of EBS volumes attached to data nodes. | `string` | `"gp2"` | no |

## Outputs

No output.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
