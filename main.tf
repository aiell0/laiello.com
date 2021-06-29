terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
  # backend "remote" {
  #   organization = "blockforgecapital"
  #   workspaces {
  #     name = "laiellocom-us-east-1"
  #   }
  # }
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
}

# data "tfe_workspace" "laiellocom" {
#   name         = "laiellocom-${var.region}"
#   organization = "blockforgecapital"
# }

# data "terraform_remote_state" "arch" {
#   backend = "remote"

#   config = {
#     organization = "blockforgecapital"
#     workspaces = {
#       name = "blockforge-arch-${var.region}"
#     }
#   }
# }

data "aws_caller_identity" "current" {}

locals {
  tags = {
    environment           = var.environment
    terraform_deployed_by = data.aws_caller_identity.current.arn
    # terraform_version      = data.tfe_workspace.laiellocom.terraform_version
    # terraform_workspace_id = data.tfe_workspace.laiellocom.id
  }
}
