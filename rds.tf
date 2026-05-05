resource "aws_db_subnet_group" "main" {
  name       = "db-subnet-group-${local.env}"
  subnet_ids = [aws_subnet.private_a.id, aws_subnet.private_b.id]
  tags       = merge(local.common_tags, { Name = "db-subnet-group-${local.env}" })
}

resource "aws_db_instance" "postgres" {
  identifier             = "postgres-${local.env}"
  allocated_storage      = 20
  db_name                = "nestdb"
  engine                 = "postgres"
  engine_version         = "15"
  instance_class         = "db.t3.micro"
  username               = "postgres"
  password               = var.db_password
  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.rds.id]
  skip_final_snapshot    = true
  publicly_accessible    = false
  tags                   = merge(local.common_tags, { Name = "postgres-${local.env}" })
}
