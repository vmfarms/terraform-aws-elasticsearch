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
    enabled = true
  }
  node_to_node_encryption {
    enabled = var.node_to_node_encryption
  }
  vpc_options {
    subnet_ids         = [var.private_subnets[0]]
    security_group_ids = [aws_security_group.es.id]
  }
  cluster_config {
    instance_type  = var.instance_type
    instance_count = var.instance_count
  }
  snapshot_options {
    automated_snapshot_start_hour = 23
  }
  ebs_options {
    ebs_enabled = "true"
    volume_type = "gp2"
    volume_size = var.volume_size
  }
  tags = merge({ Domain = var.domain }, var.tags)

  depends_on = [
    "aws_iam_service_linked_role.es",
  ]
}

