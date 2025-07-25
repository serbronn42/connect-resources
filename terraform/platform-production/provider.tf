terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.52.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
  assume_role {
    role_arn = "arn:aws:iam::900994855847:role/connect-deployment-provisioning-role"
    session_name = "connect-deployment-provisioning"
  }

  default_tags {
    tags = {
      ProjectNamespace = "github.com"
      ProjectName      = "platform/connect-resources"
    }
  }
}

data "aws_caller_identity" "current" {} 
