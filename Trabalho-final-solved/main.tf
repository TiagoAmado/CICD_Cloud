terraform {
  backend "s3" {
    bucket         = "fiap-cicd-tfstate-${terraform.workspace}"
    key            = "nginx-lb/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "tfstate-lock-${terraform.workspace}"
  }
}

provider "aws" {
  region = var.aws_region
}

module "nginx_lb" {
  source            = "./modules/nginx-lb"
  instance_count    = var.instance_count
  aws_region        = var.aws_region
  aws_amis          = var.aws_amis
  key_name          = var.key_name
  path_to_key       = var.path_to_key
  instance_username = var.instance_username
  project           = var.project
  workspace         = terraform.workspace
}

output "instance_addresses" {
  value = module.nginx_lb.address
}

output "elb_dns" {
  value = module.nginx_lb.elb_public
} 