terraform {
  required_version = "1.1.7"
  backend "s3" {
    bucket = ""
    key    = "terraform.tfstate"
    region = "us-east-1"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.22.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
  assume_role {
    role_arn = module.env_info.envs.global.provider_env_roles[terraform.workspace]
  }
}
