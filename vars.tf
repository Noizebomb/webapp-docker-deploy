variable "awsprops" {
    type = map
    default = {
    region = "us-west-2"
    ami = "ami-0fd3231344475acf9"
    itype = "t2.micro"
    vpc = "vpc-03710dffe73ed351b"
    subnet = "subnet-05db3f39b720c2e14"
    publicip = true
    keyname = "oregon-keypair"
    secgroupname = "tf-sec-grp"
  }
}
