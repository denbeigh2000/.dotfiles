variable "digitalocean_api_key" {
    type = string
    sensitive = true
    nullable = false
}

variable "aws_access_key_id" {
    type = string
    sensitive = true
    nullable = false
}

variable "aws_secret_access_key" {
    type = string
    sensitive = true
    nullable = false
}

variable "tailscale_api_key" {
    type = string
    sensitive = true
    nullable = false
}
