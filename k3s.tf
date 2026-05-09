data "aws_ami" "al2023" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# --- Elastic IP para o Master ---
resource "aws_eip" "k3s_master" {
  domain = "vpc"
  tags   = merge(local.common_tags, { Name = "eip-k3s-master-${local.env}" })
}

# --- K3s Master ---
resource "aws_instance" "k3s_master" {
  ami                    = data.aws_ami.al2023.id
  instance_type          = var.master_instance_type
  subnet_id              = aws_subnet.public_a.id
  vpc_security_group_ids = [aws_security_group.k3s.id]
  key_name               = var.ec2_key_name != "" ? var.ec2_key_name : null
  iam_instance_profile   = aws_iam_instance_profile.k3s.name

  user_data = base64encode(templatefile("${path.module}/scripts/k3s-master.sh.tpl", {
    workspace = local.env
    region    = "us-east-1"
  }))

  tags = merge(local.common_tags, {
    Name = "k3s-master-${local.env}"
    Role = "master"
  })
}

resource "aws_eip_association" "k3s_master" {
  instance_id   = aws_instance.k3s_master.id
  allocation_id = aws_eip.k3s_master.id
}

# --- K3s Workers (ASG) ---
resource "aws_launch_template" "k3s_worker" {
  name_prefix   = "k3s-worker-${local.env}-"
  image_id      = data.aws_ami.al2023.id
  instance_type = var.worker_instance_type
  key_name      = var.ec2_key_name != "" ? var.ec2_key_name : null

  vpc_security_group_ids = [aws_security_group.k3s.id]

  iam_instance_profile {
    name = aws_iam_instance_profile.k3s.name
  }

  user_data = base64encode(templatefile("${path.module}/scripts/k3s-worker.sh.tpl", {
    workspace         = local.env
    region            = "us-east-1"
    master_private_ip = aws_instance.k3s_master.private_ip
  }))

  tag_specifications {
    resource_type = "instance"
    tags = merge(local.common_tags, {
      Name = "k3s-worker-${local.env}"
      Role = "worker"
    })
  }
}

resource "aws_autoscaling_group" "k3s_workers" {
  name                = "k3s-workers-${local.env}"
  desired_capacity    = var.worker_count
  min_size            = 1
  max_size            = var.worker_max_count
  vpc_zone_identifier = [aws_subnet.public_a.id, aws_subnet.public_b.id]

  target_group_arns = [
    aws_lb_target_group.backend.arn,
  ]

  launch_template {
    id      = aws_launch_template.k3s_worker.id
    version = "$Latest"
  }

  instance_refresh {
    strategy = "Rolling"
    preferences { min_healthy_percentage = 50 }
  }

  tag {
    key                 = "Name"
    value               = "k3s-worker-${local.env}"
    propagate_at_launch = true
  }
}
