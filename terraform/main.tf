provider "aws" {
  region = var.aws_region
}

terraform {
  backend "s3" {
    bucket         = "bypass-terraform-backup"   # mesmo bucket do projeto principal
    key            = "grafana/terraform.tfstate" # state isolado
    region         = "us-east-1"
    dynamodb_table = "bypass-terraform-lock"
  }
}

# ============================
# Security Group
# ============================
resource "aws_security_group" "grafana_sg" {
  name        = "grafana-sg"
  description = "Permite acesso HTTP e SSH ao Grafana"

  ingress {
    description = "HTTP Grafana"
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "${var.project_name}-sg"
    Project = var.project_name
  }
}

# ============================
# EC2 (onde o Grafana rodará via Docker)
# ============================
resource "aws_instance" "grafana" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.grafana_sg.id]

  tags = {
    Name    = "${var.project_name}-ec2"
    Project = var.project_name
  }
}

# ============================
# (Opcional) Bucket para backups de dashboards
# ============================
resource "aws_s3_bucket" "grafana_backup" {
  bucket        = "${var.project_name}-backup"
  force_destroy = true
}

resource "aws_s3_bucket_versioning" "grafana_backup_versioning" {
  bucket = aws_s3_bucket.grafana_backup.id
  versioning_configuration {
    status = "Enabled"
  }
}

# ============================
# Outputs
# ============================
output "grafana_ec2_public_ip" {
  value = aws_instance.grafana.public_ip
}

output "grafana_backup_bucket" {
  value = aws_s3_bucket.grafana_backup.bucket
}
