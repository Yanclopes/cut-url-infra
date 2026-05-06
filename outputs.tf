output "url_api" {
  value = "https://${local.api_domain}"
}

output "url_frontend" {
  value = "https://${local.front_domain}"
}

output "k3s_master_public_ip" {
  value       = aws_eip.k3s_master.public_ip
  description = "IP público do K3s master"
}

output "k3s_master_private_ip" {
  value = aws_instance.k3s_master.private_ip
}

output "alb_backend_dns" {
  value = aws_lb.backend.dns_name
}

output "rds_endpoint" {
  value     = aws_db_instance.postgres.address
  sensitive = true
}

output "s3_frontend_bucket" {
  value       = aws_s3_bucket.frontend.bucket
  description = "Nome do bucket S3 — adicionar como secret S3_BUCKET no repo cut-url"
}

output "cloudfront_distribution_id" {
  value       = aws_cloudfront_distribution.frontend.id
  description = "ID do CloudFront — adicionar como secret CLOUDFRONT_DISTRIBUTION_ID no repo cut-url"
}

output "github_role_backend_arn" {
  value       = aws_iam_role.github_backend.arn
  description = "ARN da role — secret AWS_ROLE_ARN no repo cut-url-api"
}

output "github_role_frontend_arn" {
  value       = aws_iam_role.github_frontend.arn
  description = "ARN da role — secret AWS_ROLE_ARN no repo cut-url"
}

output "github_role_infra_arn" {
  value       = aws_iam_role.github_infra.arn
  description = "ARN da role — secret AWS_ROLE_ARN_INFRA no repo cut-url-infra"
}

output "ssm_kubeconfig_path" {
  value = aws_ssm_parameter.k3s_kubeconfig.name
}
