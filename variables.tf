variable "vpc_cidr" {
  description = "Bloco CIDR da VPC"
  type        = string
}

variable "public_subnet_cidr" {
  description = "CIDR para a Subnet Pública A (us-east-1a)"
  type        = string
}

variable "public_subnet_b_cidr" {
  description = "CIDR para a Subnet Pública B (us-east-1b)"
  type        = string
}

variable "private_subnet_cidr" {
  description = "CIDR da Subnet Privada A"
  type        = string
}

variable "private_subnet_b_cidr" {
  description = "CIDR da Subnet Privada B"
  type        = string
}

variable "master_instance_type" {
  description = "Tipo de instância do K3s master"
  type        = string
  default     = "t3.small"
}

variable "worker_instance_type" {
  description = "Tipo de instância dos K3s workers"
  type        = string
  default     = "t3.micro"
}

variable "worker_count" {
  description = "Número desejado de workers"
  type        = number
  default     = 1
}

variable "worker_max_count" {
  description = "Número máximo de workers"
  type        = number
  default     = 3
}

variable "ec2_key_name" {
  description = "Nome do Key Pair EC2 para SSH"
  type        = string
  default     = ""
}

variable "db_password" {
  description = "Senha do PostgreSQL"
  type        = string
  sensitive   = true
}

variable "base_domain" {
  description = "Domínio principal (ex: cuturl.com)"
  type        = string
}

variable "cloudflare_api_token" {
  description = "Token da API do Cloudflare"
  type        = string
  sensitive   = true
}

variable "cloudflare_zone_id" {
  description = "Zone ID do Cloudflare"
  type        = string
}

variable "github_org" {
  description = "Organização/usuário GitHub"
  type        = string
  default     = "Yanclopes"
}

variable "backend_repo_name" {
  description = "Nome do repositório do backend no GitHub"
  type        = string
  default     = "cut-url-api"
}

variable "frontend_repo_name" {
  description = "Nome do repositório do frontend no GitHub"
  type        = string
  default     = "cut-url"
}

variable "infra_repo_name" {
  description = "Nome do repositório de infra no GitHub"
  type        = string
  default     = "cut-url-infra"
}

variable "dockerhub_username" {
  description = "Usuário do Docker Hub"
  type        = string
  default     = "yanclops"
}
