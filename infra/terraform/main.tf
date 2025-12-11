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
# VPC Module
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
# EKS Module (Free-Tier Compatible)
# --------------------------------------------------
module "eks" {
  # Force Terraform to pull correct version directly from GitHub
  source  = "github.com/terraform-aws-modules/terraform-aws-eks?ref=v21.10.1"

  name               = "${var.project}-eks"
  kubernetes_version = "1.29"

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  enable_cluster_creator_admin_permissions = true

  # Core EKS Add-ons
  cluster_addons = {
    coredns   = { most_recent = true }
    kube-proxy = { most_recent = true }
    vpc-cni   = { most_recent = true }
  }

  # Default settings for managed node groups
  eks_managed_node_group_defaults = {
    ami_type  = "AL2_x86_64"
    disk_size = 20

    # Attach required IAM policies for node roles
    iam_role_additional_policies = {
      AmazonEKSWorkerNodePolicy          = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
      AmazonEKS_CNI_Policy               = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
      AmazonEC2ContainerRegistryReadOnly = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
    }
  }

  # Free-tier compatible node group
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
# Jenkins EC2 Instance
# --------------------------------------------------
resource "aws_instance" "jenkins" {
  ami                         = var.jenkins_ami_id
  instance_type               = "t3.micro"  # ✅ Free tier eligible
  subnet_id                   = module.vpc.public_subnets[0]
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.jenkins_sg.id]
  key_name                    = var.key_pair_name

  tags = {
    Name = "${var.project}-jenkins"
  }
}

# --------------------------------------------------
# Jenkins Security Group
# --------------------------------------------------
resource "aws_security_group" "jenkins_sg" {
  name        = "${var.project}-jenkins-sg"
  description = "Security group for Jenkins EC2"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "Allow Jenkins Web Access"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow SSH Access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
