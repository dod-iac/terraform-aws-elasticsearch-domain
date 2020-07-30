variable "access_policies" {
  type        = string
  description = " IAM policy document specifying the access policies for the domain."
  default     = ""
}

variable "automated_snapshot_start_hour" {
  type        = string
  description = "Hour during which the service takes an automated daily snapshot of the indices in the domain."
  default     = 23
}

variable "domain_name" {
  type        = string
  description = "Name of the domain."
}

variable "elasticsearch_version" {
  type        = string
  description = "The version of Elasticsearch to deploy."
  default     = "7.7"
}

variable "instance_count" {
  type        = number
  description = "Number of instances in the cluster."
  default     = 1
}

variable "kms_key_id" {
  type        = string
  description = "The KMS key id to encrypt the Elasticsearch domain with. If not specified then it defaults to using the aws/es service KMS key."
  default     = ""
}

variable "instance_type" {
  type        = string
  description = "Instance type of data nodes in the cluster."
  default     = "r5.large.elasticsearch"
}

variable "security_group_ids" {
  type        = list(string)
  description = "List of VPC Security Group IDs to be applied to the Elasticsearch domain endpoints. If omitted, the default Security Group for the VPC will be used."
  default     = null
}

variable "subnet_ids" {
  type        = list(string)
  description = "List of VPC Subnet IDs for the Elasticsearch domain endpoints to be created in."
  default     = []
}

variable "tags" {
  type        = map(string)
  description = "Tags applied to the KMS key."
  default     = {}
}

variable "tls_security_policy" {
  type        = string
  description = "The name of the TLS security policy that needs to be applied to the HTTPS endpoint. Valid values: Policy-Min-TLS-1-0-2019-07 and Policy-Min-TLS-1-2-2019-07. Terraform will only perform drift detection if a configuration value is provided."
  default     = "Policy-Min-TLS-1-2-2019-07"
}

variable "volume_size" {
  type        = number
  description = "The size of EBS volumes attached to data nodes (in GB). Required if ebs_enabled is set to true."
  default     = 20
}

variable "volume_type" {
  type        = string
  description = "The type of EBS volumes attached to data nodes."
  default     = "gp2"
}
