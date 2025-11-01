variable "aws_region" {
  description = "Região AWS"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Nome base do projeto"
  type        = string
  default     = "bypass-grafana"
}

variable "instance_type" {
  description = "Tipo da instância EC2"
  type        = string
  default     = "t3.medium"
}

variable "key_name" {
  description = "Nome da chave SSH existente"
  type        = string
  default     = "bypass-key"
}

variable "ami_id" {
  description = "AMI base para a EC2"
  type        = string
  default     = "ami-0341d95f75f311023" # mesma do outro módulo
}

