variable "bypass_state_bucket_name" {
  default     = "bypass-state-bucket"
}

variable "aws_region" {
  default     = "us-east-1"
}

variable "instance_type" {
  default     = "t3.medium"
}

variable "key_name" {
  default     = "bypass-key"
}

variable "ami_id" {
  default     = "ami-0341d95f75f311023" # mesma do outro módulo
}

