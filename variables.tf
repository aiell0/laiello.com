variable "region" {
  type        = string
  description = "AWS region"
  default     = "us-east-1"
}

variable "instance_size" {
  type        = string
  description = "Size of AWS EC2 instance."
  default     = "t3a.small"
}
