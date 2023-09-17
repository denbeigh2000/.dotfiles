resource "aws_s3_bucket" "bucket" {
  bucket = "denbeigh-credible-${var.env}"

  tags = {
    Use = "credible"
    Env = var.env
  }
}

module "iam_read_only" {
  source = "./iam"

  env          = var.env
  devices      = var.read_devices
  bucket_name  = aws_s3_bucket.bucket.id
  allow_writes = false
}

module "iam_read_write" {
  source = "./iam"

  env          = var.env
  devices      = var.write_devices
  bucket_name  = aws_s3_bucket.bucket.id
  allow_writes = true
}
