terraform {
  backend "s3" {
    bucket = "cicd-terraform-eks1234"
    key    = "eks/terraform.tfstate"
    region = "us-east-1"
  }
}