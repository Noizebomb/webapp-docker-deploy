terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

variable "awsprops" {
    type = map
    default = {
    region = "us-west-2"
    ami = "ami-0fd3231344475acf9"
    itype = "t2.micro"
    vpc = "vpc-02f12fd369e6941b4"
    subnet = "subnet-0c56bb13ba3a37977"
    publicip = true
    keyname = "oregon-keypair"
    secgroupname = "tf-sec-grp"
  }
}

resource "aws_security_group" "tf-sec-grp" {
  name = lookup(var.awsprops, "secgroupname")
  description = lookup(var.awsprops, "secgroupname")
  vpc_id = lookup(var.awsprops, "vpc")
  // To Allow SSH Transport
  ingress {
    from_port = 22
    protocol = "tcp"
    to_port = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  // To Allow Port 80 Transport
  ingress {
    from_port = 8080
    protocol = "tcp"
    to_port = 8080
    cidr_blocks = ["0.0.0.0/0"]
  }

  // To Allow Port 443 Transport
  ingress {
    from_port = 443
    protocol = "tcp"
    to_port = 443
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_instance" "terraform-project" {
  count = 1
  ami = lookup(var.awsprops, "ami")
  instance_type = lookup(var.awsprops, "itype")
  subnet_id = lookup(var.awsprops, "subnet")
  associate_public_ip_address = lookup(var.awsprops, "publicip")
  key_name = lookup(var.awsprops, "keyname")

  vpc_security_group_ids = [
    aws_security_group.tf-sec-grp.id
  ]
  root_block_device {
    delete_on_termination = true
    volume_size = 30
    volume_type = "gp2"
  }
  tags = {
    Name = "LVLUP-PROJECT ${count.index}"
    Environment = "DEV"
    OS = "UBUNTU"
    Managed = "IAC"
  }

  depends_on = [ aws_security_group.tf-sec-grp ]
}

output "EC2INSTANCE" {
  value = aws_instance.terraform-project.*.public_ip
}