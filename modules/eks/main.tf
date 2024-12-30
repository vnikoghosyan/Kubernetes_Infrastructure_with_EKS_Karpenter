module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "20.31.6"
  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version
  vpc_id          = var.vpc_id
  subnet_ids      = var.private_subnet_ids
}
