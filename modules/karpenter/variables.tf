variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "cluster_endpoint" {
  description = "EKS cluster endpoint"
  type        = string
}

variable "karpenter_version" {
  description = "Version of the Karpenter Helm chart"
  type        = string
  default     = "v1.1.1"
}
