output "cluster_endpoint" {
  description = "The endpoint for the EKS cluster"
  value       = module.eks.cluster_endpoint
}

output "cluster_name" {
  description = "The name of the EKS cluster"
  value       = module.eks.cluster_name
}

output "config_map_aws_auth" {
  description = "Kubernetes ConfigMap for AWS IAM authentication"
  value       = module.eks.config_map_aws_auth
}