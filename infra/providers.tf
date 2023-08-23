terraform {
  backend "s3" {}

}

provider "aws" {
  region = "eu-north-1"
}