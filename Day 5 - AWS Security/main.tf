terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"  
    }
  }
}

provider "aws" {
  region = var.region 
}

module "vpc" {
  source             = "./modules/vpc"
  vpc_cidr           = var.vpc_cidr
  public_subnet_cidr = var.public_subnet_cidr
  private_subnet_cidr = var.private_subnet_cidr
}

module "ec2" {
  source        = "./modules/ec2"
  ami_id        = "ami-05e4ed86eaaac596f" 
  instance_type = "t2.micro"
  subnet_id     = module.vpc.public_subnet_id
}

module "iam" {
  source = "./modules/iam"
}

module "security" {
  source  = "./modules/security"
  vpc_id  = module.vpc.vpc_id
}

module "cloudtrail" {
  source = "./modules/cloudtrail"
}

module "s3_example" {
  source = "./modules/s3"
}

module "config" {
  source = "./modules/config"
}

module "cloudwatch_alarms" {
  source = "./modules/cloudwatch"
}

module "secretsmanager" {
  source = "./modules/secretsmanager"
}
