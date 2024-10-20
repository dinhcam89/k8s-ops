terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 4.0"
    }
    
    ansible = {                       ### ansible provider ###
      source = "ansible/ansible"
      version = "1.3.0"
    }

  }
  backend "s3" {                                  ### backend ###
    bucket = "terraform-ops-s3-backend"
    key = "state-path"
    region = "us-east-1"
    encrypt = true
    dynamodb_table = "terraform-ops-s3-backend"
 } 
}

provider "aws" {
  region = "us-east-1"
  
}
