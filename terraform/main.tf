terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = var.region
}

module "vpc" {
  source = "./modules/vpc"
  cidr_vpc = var.cidr_vpc
  availability_zone = var.availability_zone
  cidr_publicsubnet=var.cidr_publicsubnet
  cidr_privatesubnet=var.cidr_privatesubnet
  cluster_name=var.cluster_name

}

module "eks" {
  source = "./modules/eks"
  cluster_name=var.cluster_name
  cluster_version=var.cluster_version
  subnet_ids=module.vpc.cidr_privatesubnet
  node_groups=var.node_groups
  vpc_id=module.vpc.vpc_id
}