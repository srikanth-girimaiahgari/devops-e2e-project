variable "region" {
  description = "AWS region"
  type        = string
  default     = "ap-south-2"
}

variable "project" {
  description = "Project name prefix"
  type        = string
  default     = "devops-demo"
}

variable "jenkins_ami_id" {
  description = "AMI for Jenkins EC2"
  type        = string
  default     = "ami-0e7938ad51d883574"
}

variable "key_pair_name" {
  description = "Existing AWS key pair name"
  type        = string
  default     = "devops-demo-key"
}
