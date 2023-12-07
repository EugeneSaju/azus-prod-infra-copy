terraform {
  backend "s3" {
    bucket = "terraform.azus-prod.project"
    key    = "terraform.tfstate"
    region = "ap-south-1"
  }
}

