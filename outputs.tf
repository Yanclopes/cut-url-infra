output "url_api" {
  value = "https://${local.api_domain}"
}

output "url_frontend" {
  value = "https://${local.front_domain}"
}

output "k3s_master_public_ip" {
  value       = aws_eip.k3s_master.public_ip
  description = "IP público do K3s master (para SSH e kubectl)"
}

output "k3s_master_private_ip" {
  value = aws_instance.k3s_master.private_ip
}

output "alb_backend_dns" {
  value = aws_lb.backend.dns_name
}

output "alb_frontend_dns" {
  value = aws_lb.frontend.dns_name
}

output "rds_endpoint" {
  value     = aws_db_instance.postgres.address
  sensitive = true
}

output "github_role_backend_arn" {
  value       = aws_iam_role.github_backend.arn
  description = "ARN da role para GitHub Actions do backend — adicionar como secret AWS_ROLE_ARN no repo cut-url-api"
}

output "github_role_frontend_arn" {
  value       = aws_iam_role.github_frontend.arn
  description = "ARN da role para GitHub Actions do frontend — adicionar como secret AWS_ROLE_ARN no repo cut-url"
}

output "github_role_infra_arn" {
  value       = aws_iam_role.github_infra.arn
  description = "ARN da role para GitHub Actions de infra — adicionar como secret AWS_ROLE_ARN no repo cut-url-infra"
}

output "ssm_kubeconfig_path" {
  value = aws_ssm_parameter.k3s_kubeconfig.name
}
