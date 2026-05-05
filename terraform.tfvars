vpc_cidr              = "10.0.0.0/16"
public_subnet_cidr    = "10.0.1.0/24"
public_subnet_b_cidr  = "10.0.2.0/24"
private_subnet_cidr   = "10.0.10.0/24"
private_subnet_b_cidr = "10.0.11.0/24"

master_instance_type = "t3.small"
worker_instance_type = "t3.micro"
worker_count         = 1
worker_max_count     = 2
