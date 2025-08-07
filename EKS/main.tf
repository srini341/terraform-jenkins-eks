# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

# --- VPC Module ---
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.1.0"

  name = "eks-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["us-east-1a", "us-east-1b", "us-east-1c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = true
  enable_dns_hostnames = true

  tags = {
    "kubernetes.io/cluster/eks-cluster" = "shared"
  }
}

# --- EKS Cluster Module ---
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "18.31.0"

  cluster_name    = "eks-cluster"
  cluster_version = "1.23"
  vpc_id          = module.vpc.vpc_id
  subnet_ids      = module.vpc.private_subnets

  # --- EKS Managed Node Group ---
  eks_managed_node_groups = {
    default = {
      instance_types = ["t3.medium"]

      min_size     = 1
      max_size     = 3
      desired_size = 2

      # The managed node group security group needs a tag for the cluster to find it
      tags = {
        "Name" = "eks-node-group"
      }
    }
  }

  tags = {
    Project = "EKS Deployment"
  }
}