resource "aws_key_pair" "devops_key" {
  key_name   = "devops-demo-key"
  public_key = file("${path.module}/devops-demo-key.pub")
}
