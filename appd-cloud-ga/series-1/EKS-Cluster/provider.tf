provider "aws" {
  region  = var.region
  profile = var.profile
}

data "aws_region" "current" {
}

data "aws_availability_zones" "available" {
}

data "aws_caller_identity" "current" {
}

provider "http" {
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}