resource "aws_s3_bucket" "credible" {
  bucket = "denbeigh-secrets"
  region = "us-east-1"

  tags = {
    Use = "credible"
    Env = var.env
  }
}

module "iam_read_only" {
  source = "./iam"

  env          = var.env
  devices      = var.read_devices
  allow_writes = false
}

module "iam_read_write" {
  source = "./iam"

  env          = var.env
  devices      = var.write_devices
  allow_writes = true
}

resource "aws_iam_group" "read-only" {
  name = "read-only"
  path = "/credible/${var.env}/"

  tags = {
    Use = "credible"
    Env = var.env
  }
}

resource "aws_iam_group" "read-write" {
  name = "read-write"
  path = "/credible/${var.env}/"

  tags = {
    Use = "credible"
    Env = var.env
  }
}
