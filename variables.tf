variable "region" {
    type        = string
    description = "AWS region"
}

variable "vpn_cidrs" {
    type        = list(string)
    description = "List of personal VPN CIDRs."
}

variable "ami" {
    type        = string
    description = "AMI ID for Wordpress."
}

variable "key_name" {
    type        = string
    description = "Key pair for personal Wordpress Blog."
}

variable "vpc_id" {
    type        = string
    description = "VPC ID."
}

variable "instance_size" {
    type        = string
    description = "Size of AWS EC2 instance."
}

variable "az_map" {
    type        = map(string)
    description = "A map of availability zones indexed by subnets."
}

variable "subnet_id" {
    type        = string
    description = "ID of subnet."
}