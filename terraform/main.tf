provider "aws" {
  region = var.aws_region
}

terraform {
  backend "s3" {
    bucket         = "bypass-terraform-backup"   # mesmo bucket do projeto principal
    key            = "grafana/terraform.tfstate" # state isolado
    region         = "us-east-1"
  }
}

# ============================
# Importa os outputs do projeto principal
# ============================
data "terraform_remote_state" "bypass_transformer" {
  backend = "s3"
  config = {
    bucket = "bypass-terraform-backup"
    key    = "terraform/state.tfstate"
    region = "us-east-1"
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
  ami                    = "ami-0341d95f75f311023"
  instance_type          = "t2.medium"
  key_name               = "bypass-key"
  vpc_security_group_ids      = [aws_security_group.grafana_sg.id]
  associate_public_ip_address = true

  tags = {
    Name = "bypass-grafana-ec2"
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
