# DevOps Demo Platform

End-to-end DevOps setup using:
- AWS, Terraform, Ansible
- Jenkins, GitHub, GitHub Actions
- SonarQube, Nexus/JFrog
- Docker, Kubernetes (EKS)

## High-Level Flow

1. Terraform creates AWS infra (VPC, EKS, EC2 for Jenkins & tools).
2. Ansible installs Jenkins, SonarQube, Nexus on EC2.
3. Code lives in this repo (`app/`).
4. Jenkins pipeline (`cicd/Jenkinsfile`) builds, analyzes, builds Docker image, pushes to Nexus/JFrog, and deploys to EKS using `k8s/` manifests.
5. GitHub Actions does lightweight CI (build & test).

## Getting Started

- `cd infra/terraform && terraform init && terraform apply`
- Update Ansible inventory with Terraform outputs.
- Run Ansible playbooks.
- Configure Jenkins credentials + SonarQube + Nexus URLs.
- Push code to GitHub and run the pipeline.
