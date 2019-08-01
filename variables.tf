variable "vpc_id" {
  type = string
}

variable "domain" {
  type = string
}

variable "volume_size" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "region" {
  type = string
}

variable "instance_count" {
  type = string
}

variable "private_subnets_cidrs" {
  type = list(string)
}

variable "private_subnets" {
  type = list(string)
}

variable "elasticsearch_version" {
  type = string
}

variable "create_iam_service_linked_role" {
  type    = string
  default = "true"
}

variable "node_to_node_encryption" {
  type    = string
  default = "false"
}
