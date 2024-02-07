terraform {
  backend "s3" {
    bucket         = "my-terraform-state-bucket"
    key            = "state/key/path/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "my-lock-table"
    encrypt        = true
  }
}