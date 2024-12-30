resource "helm_release" "karpenter" {
  name       = "karpenter"
  repository = "oci://public.ecr.aws/karpenter/karpenter"
  chart      = "karpenter"
  namespace  = "karpenter"
  version    = var.karpenter_version

  create_namespace = true

  values = [
    <<EOF
controller:
  clusterName: ${var.cluster_name}
  clusterEndpoint: ${var.cluster_endpoint}
  aws:
    defaultInstanceProfile: ${aws_iam_instance_profile.karpenter_instance_profile.name}
EOF
  ]
}

resource "aws_iam_instance_profile" "karpenter_instance_profile" {
  name = "karpenter-instance-profile"
  role = aws_iam_role.karpenter_role.name
}

resource "aws_iam_role" "karpenter_role" {
  name = "karpenter-role"

  assume_role_policy = data.aws_iam_policy_document.karpenter_assume_role_policy.json
}

data "aws_iam_policy_document" "karpenter_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["karpenter.sh"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "karpenter_role_policy_eks_worker" {
  role       = aws_iam_role.karpenter_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "karpenter_role_policy_ec2_container_registry" {
  role       = aws_iam_role.karpenter_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_iam_role_policy_attachment" "karpenter_role_policy_eks_cni" {
  role       = aws_iam_role.karpenter_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}
