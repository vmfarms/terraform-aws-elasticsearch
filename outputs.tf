output "endpoint" {
  description = "Domain-specific HTTPS endpoint used to submit index, search, and data upload requests."
  value       = aws_elasticsearch_domain.es_domain.endpoint
}
