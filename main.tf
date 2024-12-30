provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source                 = "./modules/vpc"
  cidr_block             = var.cidr_block
  public_subnet_cidrs    = var.public_subnet_cidrs
  private_subnet_cidrs   = var.private_subnet_cidrs
  availability_zones     = var.availability_zones
  name                   = var.cluster_name
}

module "eks" {
  source          = "./modules/eks"
  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version
  vpc_id          = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnets
}

module "karpenter" {
  source          = "./modules/karpenter"
  cluster_name    = module.eks.cluster_id
  cluster_endpoint = module.eks.cluster_endpoint
}
