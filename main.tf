terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
  backend "s3" {
    bucket  = "laiello-terraform-tfstate"
    key     = "laiello.com"
    region  = "us-east-1"
    profile = "personal"
  }
  required_version = ">= 1.0"
}

provider "aws" {
  region = var.region
}

data "terraform_remote_state" "arch" {
  backend = "remote"

  config = {
    organization = "blockforgecapital"
    workspaces = {
      name = "blockforge-arch-${var.region}"
    }
  }
}

data "aws_caller_identity" "current" {}

locals {
  tags = {
    terraform_deployed_by = data.aws_caller_identity.current.arn
  }
}
