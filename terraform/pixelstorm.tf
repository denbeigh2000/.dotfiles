module "pixelstorm" {
  source = "./modules/pixelstorm"

  regions = [
    {
      region     = "us-west-2"
      public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFuFiijYIa09nYmSajRGSCyzGbSi4LkcIM/joL+DLCo7"
    },
    {
      region     = "us-east-2"
      public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOtsmwB3itL6uN2KHA69dCbxEP1G+yw7F2XSIhBO7I3P"
    }
  ]

  env = "prod"
}
