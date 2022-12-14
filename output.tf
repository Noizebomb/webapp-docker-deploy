output "ec2instance" {
  value = aws_instance.terraform-project.*.public_ip
}