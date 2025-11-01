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
# IAM Role e Policy (read-only em Athena/S3)
# ============================
resource "aws_iam_role" "grafana_role" {
  name = "${var.project_name}-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_policy" "grafana_policy" {
  name        = "${var.project_name}-policy"
  description = "Permite leitura no Athena e S3"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "S3Read"
        Effect = "Allow"
        Action = ["s3:GetObject", "s3:ListBucket"]
        Resource = [
          data.terraform_remote_state.bypass_transformer.outputs.raw_bucket_arn,
          data.terraform_remote_state.bypass_transformer.outputs.trusted_bucket_arn,
          data.terraform_remote_state.bypass_transformer.outputs.client_bucket_arn
        ]
      },
      {
        Sid    = "AthenaRead"
        Effect = "Allow"
        Action = [
          "athena:StartQueryExecution",
          "athena:GetQueryExecution",
          "athena:GetQueryResults",
          "athena:ListWorkGroups"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_policy" {
  role       = aws_iam_role.grafana_role.name
  policy_arn = aws_iam_policy.grafana_policy.arn
}

resource "aws_iam_instance_profile" "grafana_instance_profile" {
  name = "${var.project_name}-instance-profile"
  role = aws_iam_role.grafana_role.name
}

# ============================
# EC2 (onde o Grafana rodará via Docker)
# ============================
resource "aws_instance" "grafana" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.grafana_sg.id]
  iam_instance_profile   = aws_iam_instance_profile.grafana_instance_profile.name

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
