output "karpenter_instance_profile_arn" {
  description = "IAM Instance Profile ARN for Karpenter nodes"
  value       = aws_iam_instance_profile.karpenter_instance_profile.arn
}
