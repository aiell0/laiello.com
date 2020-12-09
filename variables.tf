variable "region" {
  type        = string
  description = "AWS region"
}

variable "key_name" {
  type        = string
  description = "Key pair for personal Wordpress Blog."
}

variable "instance_size" {
  type        = string
  description = "Size of AWS EC2 instance."
}

variable "environment" {
  type        = string
  description = "Environment or stage that the server is in."
}