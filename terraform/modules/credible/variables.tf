variable "env" {
  type     = string
  nullable = false
}

variable "s3_bucket" {
  type     = string
  nullable = false
}

variable "read_devices" {
  type = list(object({
    name   = string,
    key_id = string,
  }))
  nullable = false
}

variable "write_devices" {
  type = list(object({
    name   = string,
    key_id = string,
  }))
  nullable = false
}
