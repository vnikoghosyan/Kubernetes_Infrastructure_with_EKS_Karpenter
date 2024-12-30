# VPC Configuration
cidr_block           = "10.0.0.0/16"
public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnet_cidrs = ["10.0.3.0/24", "10.0.4.0/24"]
availability_zones   = ["us-west-2a", "us-west-2b"]

# EKS Configuration
cluster_name    = "my-cluster"
cluster_version = "1.31"

# AWS Region
aws_region = "us-west-2"
