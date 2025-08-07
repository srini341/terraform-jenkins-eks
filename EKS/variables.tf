variable "aws_region" {
  description = "AWS region to deploy the EKS cluster"
  type        = string
  default     = "us-east-1"
}

variable "cluster_name" {
  description = "The name for the EKS cluster"
  type        = string
  default     = "eks-cluster"
}

variable "instance_type" {
  description = "The EC2 instance type for the EKS worker nodes"
  type        = string
  default     = "t3.medium"
}