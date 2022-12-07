resource "aws_s3_bucket" "tf_state" {
    
    bucket = "martin-lvlup-terraform-state"
    lifecycle {
        prevent_destroy = true
    }
}