import {
  to = aws_s3_bucket.credible
  id = "denbeigh-secrets"
}

import {
  to = aws_iam_user.device_lucifer
  id = "denbeigh-secrets"
}

resource "aws_iam_user" "device_lucifer" {
  name = "device-lucifer"
}

module "credible-prod" {
  source = "./modules/credible"

  env       = "prod"
  s3_bucket = "denbeigh-secrets"

  read_devices = []

  write_devices = [
    { name = "lucifer", key_id = "" },
    // "bruce",
  ]
}

module "credible-stg" {
  source = "./modules/credible"

  env       = "stg"
  s3_bucket = "denbeigh-secrets-validation"
  devices = [
    "lucifer",
  ]
}
