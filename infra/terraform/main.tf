terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = var.region
}

# --------------------------------------------------
# VPC
# --------------------------------------------------
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.8.1"

  name = "${var.project}-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["${var.region}a", "${var.region}b"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]

  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "${var.project}-vpc"
  }
}

# --------------------------------------------------
# EKS (Free-Tier compatible)
# --------------------------------------------------
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "21.10.1"

  name               = "${var.project}-eks"
  kubernetes_version = "1.29"

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  # Give the cluster creator (you) admin access
  enable_cluster_creator_admin_permissions = true

  # Core addons managed automatically
  # cluster_addons = {
  #   coredns   = { most_recent = true }
  #   kube-proxy = { most_recent = true }
  #   vpc-cni   = { most_recent = true }
  # }

  # # Node group defaults
  # eks_managed_node_group_defaults = {
  #   ami_type  = "AL2_x86_64"
  #   disk_size = 20

  #   # IAM permissions for worker nodes
  #   iam_role_additional_policies = {
  #     AmazonEKSWorkerNodePolicy          = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  #     AmazonEKS_CNI_Policy               = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  #     AmazonEC2ContainerRegistryReadOnly = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  #   }
  # }

  # Single-node cluster for free-tier
  eks_managed_node_groups = {
    default = {
      min_size      = 1
      max_size      = 1
      desired_size  = 1
      instance_types = ["t3.micro"]
      capacity_type  = "ON_DEMAND"
    }
  }
}

# --------------------------------------------------
# Jenkins EC2
# --------------------------------------------------
resource "aws_instance" "jenkins" {
  ami                         = var.jenkins_ami_id
  instance_type               = "t3.micro" # ✅ free-tier
  subnet_id                   = module.vpc.public_subnets[0]
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.jenkins_sg.id]
  key_name                    = var.key_pair_name

  tags = {
    Name = "${var.project}-jenkins"
  }
}

resource "aws_security_group" "jenkins_sg" {
  name        = "${var.project}-jenkins-sg"
  description = "Security group for Jenkins"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # open for demo, restrict in production
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # open for demo, restrict in production
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
