module "credible-prod" {
  source = "./modules/credible"

  env       = "prod"
  s3_bucket = "denbeigh-secrets"

  read_devices = []

  write_devices = [
    { name = "lucifer", key_id = "AKIA5BNI3OVQUCQPPT45" },
  ]
}

// NOTE: When adding new devices
// - first create with empty key_id
// - create credentials using script
// - impoct credentials using temporary statement like below
// import {
//   to = module.credible-<ENV>.module.iam_read_write.aws_iam_access_key.access_key["<NAME>"]
//   id = "AKIA................"
// }

module "credible-stg" {
  source = "./modules/credible"

  env          = "stg"
  s3_bucket    = "denbeigh-secrets-validation"
  read_devices = []

  write_devices = [
    { name = "lucifer", key_id = "AKIA5BNI3OVQVUA2M26X" },
  ]
}
