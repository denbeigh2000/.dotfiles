variable "env" {
  type     = string
  nullable = false
}

variable "regions" {
  type     = list(object({ region = string, public_key = string }))
  nullable = false
}

