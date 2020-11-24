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
  default     = false
  description = "Create an AWS Service-Linked Role for use by Elasticsearch. The service linked role is used to provide the Elasticsearch cluster with the appropriate permissions to run. This should be 'true' for the first Elasticsearch cluster you create, and 'false' thereafter. (Only one service-linked role can be created per AWS account and it is shared by all ES domains.) More info at https://docs.aws.amazon.com/IAM/latest/UserGuide/using-service-linked-roles.html"
}

variable "encrypt_at_rest" {
  type        = bool
  default     = true
  description = "Whether or not to use encryption-at-rest for the newly created elasticsearch cluster. Needs to be disabled if using older instance types like t2 and m3 that do not support encryption."
}

variable "node_to_node_encryption" {
  type        = string
  default     = false
  description = "Whether or not to use node-node encryption for the newly created ES domain. Requires `elasticsearch_version` version >= 6"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "A set of AWS tags to tag the resulting Elasticsearch cluster with."
}

variable "multiaz" {
  type        = bool
  default     = false
  description = "Determines if the elasticsearch should be deployed to two AZs. (Default false)"
}

variable "dedicated_master_enabled" {
  type        = bool
  default     = false
  description = "Determines if a dedicated master insatance is needed"
}

variable "dedicated_master_count" {
  type        = number
  default     = 3
  description = "Determines how many dedicated master should be created (dedicated_master_enabled should be ture)"
}

variable "dedicated_master_type" {
  type        = string
  default     = "c5.large.elasticsearch"
  description = "Determines the type of dedicated master instances that should be created (dedicated_master_enabled should be ture)"
}

variable "log_publishing_options" {
  type        = bool
#  default     = true
  description = "Options for publishing slow and application logs to CloudWatch Logs. This block can be declared multiple times, for each log_type, within the same resource."
}

variable "log_type_index_slow_logs" {
  type        = string
  default     = "INDEX_SLOW_LOGS"
  description = "A type of Elasticsearch log. Valid values: INDEX_SLOW_LOGS"
}

variable "log_type_search_slow_logs" {
  type        = string
  default     = "SEARCH_SLOW_LOGS"
  description = "A type of Elasticsearch log. Valid values: SEARCH_SLOW_LOGS"
}
variable "log_type_es_application_logs" {
  type        = string
  default     = "ES_APPLICATION_LOGS"
  description = "A type of Elasticsearch log. Valid values: ES_APPLICATION_LOGS"
}
variable "log_type_audit_logs" {
  type        = string
  default     = "AUDIT_LOGS"
  description = "A type of Elasticsearch log. Valid values: AUDIT_LOGS"
}

variable "advanced_security_options" {
  type        = bool
#  default     = true
  description = "Whether advanced security is enabled"
}

variable "domain_endpoint_options" {
  type        = bool
#  default     = true
  description = "Whether or not to require HTTPS"
}

variable "master_user_name" {
  type        = string
  default     = "test-user"
  description = "The master user's username, which is stored in the Amazon Elasticsearch Service domain's internal database."
}
variable "master_user_password" {
  type        = string
  default     = "password"
  description = "The master user's password, which is stored in the Amazon Elasticsearch Service domain's internal database."
}

variable "master_user_options" {
  type        = bool
#  default     = true
  description = "Credentials for the master user: username and password, or ARN"
}

variable "cognito_options" {
  type        = bool
#  default     = true
  description = "Amazon Cognito Authentication for Kibana"
 }
