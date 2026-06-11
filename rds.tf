resource "aws_db_subnet_group" "rds_subnet" {
  name       = "tapp-rds-subnet-group"
  subnet_ids = module.vpc.private_subnets
}

resource "aws_security_group" "rds_sg" {
  name        = "tapp-rds-sg"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    cidr_blocks     = ["10.0.0.0/16"] # VPC 내부(EKS, Bastion)에서만 접근 가능
  }
}

resource "aws_db_instance" "mysql" {
  identifier           = "tapp-db"
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t3.micro"
  allocated_storage    = 20
  db_name              = "tappdb"
  username             = "admin"
  password             = var.db_password # tfvars에서 땡겨옴
  db_subnet_group_name = aws_db_subnet_group.rds_subnet.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  skip_final_snapshot  = true # 실습용이므로 삭제 시 스냅샷 안 만듦
}