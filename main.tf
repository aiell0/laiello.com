terraform {
    required_version = ">= 0.12"
    backend "s3" {
        bucket = "blockforge-infrastructure"
        key    = "aiell0/laiello.com"
        region = "us-east-1"
    }
}

provider "aws" {
    version = "~> 2.0"
    region  = var.region
}

data "aws_caller_identity" "current" {}