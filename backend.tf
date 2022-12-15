terraform {
  backend "s3" {
    encrypt = true    
    bucket = "martin-lvlup-terraform-state"
    dynamodb_table = "terraform-state-lock-dynamo"
    key    = "terraform.tfstate"
    region = "us-west-2"
  }
}