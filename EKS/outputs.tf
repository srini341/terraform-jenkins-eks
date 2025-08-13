output "eks_cluster_name" {
  value       = module.eks.cluster_id
  description = "EKS cluster name"
}

output "eks_cluster_endpoint" {
  value       = module.eks.cluster_endpoint
  description = "EKS cluster endpoint"
}

output "eks_cluster_ca" {
  value       = module.eks.cluster_certificate_authority_data
  description = "EKS cluster CA certificate"
}

output "node_group_role_arn" {
  value       = module.eks.eks_managed_node_groups["default"].iam_role_arn
  description = "IAM role ARN for the default node group"
}
output "eks_debug" {
  value = module.eks
}
