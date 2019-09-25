variable "vpc_id" {
  type        = string
  description = "VPC ID to create Elasticsearch domain within."
}

variable "domain" {
  type        = string
  description = "Name of Elasticsearch domain to create"
}

variable "volume_size" {
  type        = string
  description = "Size of disk provisioned for Elasticsearch instances in GB."
}

variable "instance_type" {
  type        = string
  description = "AWS instance type to use for Elasticsearch nodes."
}

variable "region" {
  type        = string
  description = "AWS region to create resources within"
}

variable "instance_count" {
  type        = string
  description = "Number of Elasticsearch nodes to create"
}

variable "private_subnets_cidrs" {
  type        = list(string)
  description = "The CIDR of IPs that should be able to access Elasticsearch. Typically the CIDR of worker nodes created by the EKS module."
}

variable "private_subnets" {
  type        = list(string)
  description = "Subnet IDs that can access Elasticsearch (once created). Typically the worker security group ID created by the EKS module."
}

variable "elasticsearch_version" {
  type        = string
  description = "Version of Elasticsearch to use"
}

variable "create_iam_service_linked_role" {
  type        = string
  default     = true
  description = "Create an AWS Service-Linked Role for use by Elasticsearch. The service linked role is used to provide the Elasticsearch cluster with the appropriate permissions to run. This should be 'true' for the first Elasticsearch cluster you create, and 'false' thereafter. (Only one service-linked role can be created per AWS account and it is shared by all ES domains.) More info at https://docs.aws.amazon.com/IAM/latest/UserGuide/using-service-linked-roles.html"
}

variable "node_to_node_encryption" {
  type        = string
  default     = false
  description = "Whether or not to use node-node encryption for the newly created ES domain. Requires `elasticsearch_version` version >= 6"
}

