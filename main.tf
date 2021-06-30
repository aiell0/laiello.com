terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
  backend "s3" {
    bucket = "laiello-terraform-tfstate"
    region = "us-east-1"
    key    = "laiello.com"
    acl    = "bucket-owner-full-control"
  }
  required_version = ">= 0.15"
}

provider "aws" {
  region = var.region
  assume_role {
    role_arn = "arn:aws:iam::385445628596:role/atlantis"
  }
}

data "aws_caller_identity" "current" {}

locals {
  tags = {
    environment           = var.environment
    terraform_deployed_by = data.aws_caller_identity.current.arn
  }
}
