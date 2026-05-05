resource "aws_ssm_parameter" "db_password" {
  name  = "/${local.env}/database/password"
  type  = "SecureString"
  value = var.db_password
  tags  = local.common_tags
}

# Preenchidos pelo user_data do master durante bootstrap
resource "aws_ssm_parameter" "k3s_token" {
  name  = "/${local.env}/k3s/token"
  type  = "SecureString"
  value = "bootstrap-placeholder"

  lifecycle {
    ignore_changes = [value]
  }
  tags = local.common_tags
}

resource "aws_ssm_parameter" "k3s_kubeconfig" {
  name  = "/${local.env}/k3s/kubeconfig"
  type  = "SecureString"
  value = "bootstrap-placeholder"

  lifecycle {
    ignore_changes = [value]
  }
  tags = local.common_tags
}
