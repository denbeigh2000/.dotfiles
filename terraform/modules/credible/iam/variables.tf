variable "env" {
  type     = string
  nullable = false
}

variable "allow_writes" {
  type     = bool
  nullable = false
}

variable "bucket_name" {
  type     = string
  nullable = false
}

variable "devices" {
  type = list(object({
    name   = string,
    key_id = string,
  }))
  nullable = false
}
