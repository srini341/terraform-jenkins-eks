terraform {
  required_providers {
    aws = {
      source                = "hashicorp/aws"
      version               = "~> 5.29.0"
      configuration_aliases = [aws.aws_v3, aws.aws_v6]
    }
    tls = {
      source  = "hashicorp/tls"
      version = ">= 3.0.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.10.0"
    }
    cloudinit = {
      source  = "hashicorp/cloudinit"
      version = ">= 2.0.0"
    }
  }
}

provider "aws" {
  alias  = "aws_v3"
  region = var.region
}

provider "aws" {
  alias  = "aws_v6"
  region = var.region
}
provider "aws" {
  region = var.region
}


module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.1.2"
  providers = {
    aws = aws.aws_v6
  }

  name = "eks-vpc"
  cidr = "10.0.0.0/16"

  azs             = slice(data.aws_availability_zones.available.names, 0, 3)
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = true

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

data "aws_availability_zones" "available" {}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "18.30.2"
  providers = {
    aws = aws.aws_v3
  }

  cluster_name                   = "my-eks-cluster"
  cluster_version                = "1.30"
  vpc_id                         = module.vpc.vpc_id
  subnet_ids                     = module.vpc.private_subnets
  enable_irsa                    = true
  cluster_endpoint_public_access = true
  cluster_enabled_log_types      = ["api", "audit", "authenticator"]

  eks_managed_node_groups = {
    default = {
      desired_capacity = 2
      max_capacity     = 3
      min_capacity     = 1
      instance_types   = ["t3.medium"]
    }
  }
manage_aws_auth = true
  aws_auth_roles = [
    {
      rolearn  = "arn:aws:iam::123456789012:role/my-eks-admin-role"
      username = "admin"
      groups   = ["system:masters"]
    }
  ]
  cluster_addons = {
  coredns = {
    resolve_conflicts_on_create = "OVERWRITE"
    resolve_conflicts_on_update = "OVERWRITE"
  }
  kube-proxy = {
    resolve_conflicts_on_create = "OVERWRITE"
    resolve_conflicts_on_update = "OVERWRITE"
  }
  vpc-cni = {
    resolve_conflicts_on_create = "OVERWRITE"
    resolve_conflicts_on_update = "OVERWRITE"
  }
}

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}

