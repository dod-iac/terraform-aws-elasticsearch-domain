/**
 * ## Usage
 *
 * Creates an Amazon Elasticsearch Service domain with secure defaults.  This module always requires node-to-node encryption, encryption at rest, HTTPS endpoints, and use of a VPC.
 *
 *
 * ```hcl
 * module "elasticsearch_domain" {
 *   source = "dod-iac/elasticsearch-domain/aws"
 *
 *   domain_name = format("app-%s-%s", var.application, var.environment)
 *   kms_key_id = var.kms_key_id
 *   subnet_ids = slice(module.vpc.private_subnets, 0, 1)
 *   security_group_ids = [aws_security_group.elasticsearch.id]
 *   tags = {
 *     Application = var.application
 *     Environment = var.environment
 *     Automation  = "Terraform"
 *   }
 * }
 * ```
 *
 * The IAM service-linked role for Amazon Elasticsearch Service is required before you can create a domain.  If the role does not exist, then you can create the role with the following resource.
 *
 * ```hcl
 * resource "aws_iam_service_linked_role" "main" {
 *   aws_service_name = "es.amazonaws.com"
 * }
 * ```
 *
 * ## Terraform Version
 *
 * Terraform 0.12. Pin module version to ~> 1.0.0 . Submit pull-requests to master branch.
 *
 * Terraform 0.11 is not supported.
 *
 * ## License
 *
 * This project constitutes a work of the United States Government and is not subject to domestic copyright protection under 17 USC § 105.  However, because the project utilizes code licensed from contributors and other third parties, it therefore is licensed under the MIT License.  See LICENSE file for more information.
 */

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_partition" "current" {}

data "aws_iam_policy_document" "access_policies" {
  // statement {
  //   actions = [
  //     "es:*"
  //   ]
  //   effect = "Allow"
  //   principals {
  //     type        = "*"
  //     identifiers = ["*"]
  //   }
  //   resources = [
  //     format(
  //       "arn:%s:es:%s:%s:domain/%s/*",
  //       data.aws_partition.current.partition,
  //       data.aws_region.current.name,
  //       data.aws_caller_identity.current.account_id,
  //       var.domain_name
  //     )
  //   ]
  // }
  statement {
    effect  = "Allow"
    actions = ["es:*"]
    principals {
      type = "AWS"
      identifiers = [
        "arn:aws-us-gov:iam::${data.aws_caller_identity.current.account_id}:role/${var.kibana_cognito_role_name}",
        "arn:aws-us-gov:iam::${data.aws_caller_identity.current.account_id}:role/${var.cognito_auth_role_name}"
      ]
    }
    resources = ["arn:aws-us-gov:es:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:domain/${var.domain_name}/*"]
  }
}

resource "aws_elasticsearch_domain" "main" {

  access_policies = length(var.access_policies) > 0 ? var.access_policies : data.aws_iam_policy_document.access_policies.json

  cluster_config {
    instance_count = var.instance_count
    instance_type  = var.instance_type
  }

  domain_endpoint_options {
    enforce_https       = true
    tls_security_policy = var.tls_security_policy
  }

  domain_name = var.domain_name

  ebs_options {
    ebs_enabled = true
    volume_type = var.volume_type
    volume_size = var.volume_size
    iops        = null
  }

  elasticsearch_version = var.elasticsearch_version

  encrypt_at_rest {
    enabled    = true
    kms_key_id = var.kms_key_id
  }

  node_to_node_encryption {
    enabled = true
  }

  snapshot_options {
    automated_snapshot_start_hour = var.automated_snapshot_start_hour
  }

  tags = var.tags

  vpc_options {
    subnet_ids         = var.subnet_ids
    security_group_ids = var.security_group_ids
  }
  cognito_options {
    enabled          = var.cognito_enabled
    identity_pool_id = var.cognito_identity_pool_id
    user_pool_id     = var.cognito_user_pool_id
    role_arn         = var.cognito_role_arn

  }
}
