terraform {
  backend "s3" {
    bucket = "infra-bootcamp-2-group-1"
    key    = "eks.tfstate"
    region = "ap-southeast-1"
  }
}