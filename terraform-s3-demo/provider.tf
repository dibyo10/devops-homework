terraform {
  required_version = ">= 1.7.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
  default_tags {
    tags = { Owner = "Dibyo Chakraborty", Enrollment = "24BCS10302", Project = "devops-homework", Session = "18" }
  }
}
