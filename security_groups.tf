# --- ALB Frontend ---
resource "aws_security_group" "alb_frontend" {
  name   = "alb-frontend-sg-${local.env}"
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = merge(local.common_tags, { Name = "alb-frontend-sg-${local.env}" })
}

# --- ALB Backend ---
resource "aws_security_group" "alb_backend" {
  name   = "alb-backend-sg-${local.env}"
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = merge(local.common_tags, { Name = "alb-backend-sg-${local.env}" })
}

# --- K3s Cluster (master + workers) ---
resource "aws_security_group" "k3s" {
  name   = "k3s-sg-${local.env}"
  vpc_id = aws_vpc.main.id

  # API server do K3s (kubectl via GitHub Actions)
  ingress {
    from_port   = 6443
    to_port     = 6443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # NodePort backend (do ALB backend)
  ingress {
    from_port       = 30080
    to_port         = 30080
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_backend.id]
  }

  # NodePort frontend (do ALB frontend)
  ingress {
    from_port       = 30090
    to_port         = 30090
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_frontend.id]
  }

  # SSH
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Comunicação intra-cluster (flannel VXLAN + kubelet + etcd)
  ingress {
    from_port = 0
    to_port   = 65535
    protocol  = "tcp"
    self      = true
  }
  ingress {
    from_port = 0
    to_port   = 65535
    protocol  = "udp"
    self      = true
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.common_tags, { Name = "k3s-sg-${local.env}" })
}

# --- RDS ---
resource "aws_security_group" "rds" {
  name   = "rds-sg-${local.env}"
  vpc_id = aws_vpc.main.id

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.k3s.id]
  }

  tags = merge(local.common_tags, { Name = "rds-sg-${local.env}" })
}
