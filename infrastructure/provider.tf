terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {}
}

provider "aws" {
  alias  = "security_log"
  region = var.aws_region
  
  assume_role {
    role_arn     = "arn:aws:iam::${var.security_log_account_id}:role/OrganizationAccountAccessRole"
    session_name = "Terraform-SecurityLog-Session"
  }
}

provider "aws" {
  alias  = "security_tooling"
  region = var.aws_region

  assume_role {
    role_arn     = "arn:aws:iam::${var.security_tooling_account_id}:role/OrganizationAccountAccessRole"
    session_name = "Terraform-SecurityTooling-Session"
  }
}
