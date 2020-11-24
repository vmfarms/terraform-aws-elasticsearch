resource "aws_iam_service_linked_role" "es" {
  aws_service_name = "es.amazonaws.com"
  count            = var.create_iam_service_linked_role == "true" ? 1 : 0
  description      = "Allows Amazon ES to manage AWS resources for a domain on your behalf. Specify false if this role has already been created (ie. is the second cluster for an account)."
}

resource "aws_security_group" "es" {
  name        = "elasticsearch-${var.domain}"
  description = "Managed by Terraform"
  vpc_id      = var.vpc_id
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.private_subnets_cidrs
  }
}

data "aws_caller_identity" "current" {
}

resource "aws_elasticsearch_domain" "es_domain" {
  domain_name     = var.domain
  access_policies = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "es:*",
      "Principal": {
        "AWS": "*"
      },
      "Effect": "Allow",
      "Resource": "arn:aws:es:${var.region}:${data.aws_caller_identity.current.account_id}:domain/${var.domain}/*"
    }
  ]
}
POLICY

  elasticsearch_version = var.elasticsearch_version
  encrypt_at_rest {
    enabled = var.encrypt_at_rest
  }
  node_to_node_encryption {
    enabled = "true" #var.node_to_node_encryption #Required for advanced_security_options
  }
  vpc_options {
    subnet_ids         = slice(var.private_subnets, 0, var.multiaz ? 2 : 1)
    security_group_ids = [aws_security_group.es.id]
  }
  cluster_config {
    instance_type            = var.instance_type
    instance_count           = var.instance_count
    zone_awareness_enabled   = var.multiaz
    dedicated_master_enabled = var.dedicated_master_enabled
    dedicated_master_type    = var.dedicated_master_enabled ? var.dedicated_master_type : null
    dedicated_master_count   = var.dedicated_master_enabled ? var.dedicated_master_count : null
  }
  snapshot_options {
    automated_snapshot_start_hour = 23
  }
  log_publishing_options {
    cloudwatch_log_group_arn = aws_cloudwatch_log_group.elasticsearch-advanced-logs.arn
    log_type                 = var.log_type_index_slow_logs
    enabled                  = "true"
  }
  log_publishing_options {
    cloudwatch_log_group_arn = aws_cloudwatch_log_group.elasticsearch-advanced-logs.arn
    log_type                 = var.log_type_search_slow_logs
    enabled                  = "true"
  }
  log_publishing_options {
    cloudwatch_log_group_arn = aws_cloudwatch_log_group.elasticsearch-advanced-logs.arn
    log_type                 = var.log_type_es_application_logs
    enabled                  = "true"
  }
  log_publishing_options {
    cloudwatch_log_group_arn = aws_cloudwatch_log_group.elasticsearch-advanced-logs.arn
    log_type                 = var.log_type_audit_logs
    enabled                  = "true"
  }
  advanced_security_options {
    enabled                        = "true" #Entire block required to enable advanced log publishing
    internal_user_database_enabled = "true" 
#  }
#  master_user_options  {
#    enabled                        = "true"
#    master_user_name               = "test-user"
#    master_user_password           = "password"
  }
  domain_endpoint_options {
    enforce_https            = "true" #Required for advanced_security_options
    tls_security_policy      = "Policy-Min-TLS-1-2-2019-07"
  }
#  cognito_options {
#    enabled                  = "true"
#    user_pool_id             = var.cognito_user_pool_id
#    role_arn                 = var.cognito_role_arn
#  }
  ebs_options {
    ebs_enabled = "true"
    volume_type = "gp2"
    volume_size = var.volume_size
  }
  tags = merge({ Domain = var.domain }, var.tags)

  depends_on = [
    aws_iam_service_linked_role.es,
  ]


resource "aws_cloudwatch_log_group" "elasticsearch-advanced-logs" {
  name              = "elasticsearch-advanced-logs"
  retention_in_days = "0"


#  tags = {
#    Environment = "production"
#    Application = "serviceA"
#  }
}

data "aws_iam_policy_document" "elasticsearch-log-publishing-policy" {
  statement {
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:PutLogEventsBatch",
    ]

    resources = ["arn:aws:logs:*"]

    principals {
      identifiers = ["es.amazonaws.com"]
      type        = "Service"
    }
  }
}

resource "aws_cloudwatch_log_resource_policy" "elasticsearch-log-publishing-policy" {
  policy_document = data.aws_iam_policy_document.elasticsearch-log-publishing-policy.json
  policy_name     = "elasticsearch-log-publishing-policy"
}
