output "es_arn" {
  value = aws_elasticsearch_domain.main.arn
}

output "es_endpoint" {
  value = aws_elasticsearch_domain.main.endpoint
}
