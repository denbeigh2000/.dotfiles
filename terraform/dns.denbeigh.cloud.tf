locals {
  tailscale_aliases = ["jackett", "radarr", "sonarr", "jellyfin", "transmission"]
}

data "tailscale_devices" "bruce" {
  name_prefix = "bruce"
  # wait_for = "5s"
}

data "digitalocean_domain" "denbeigh_cloud" {
  name = "denbeigh.cloud"
}

resource "digitalocean_record" "denbeigh_cloud_ns_1" {
  domain = data.digitalocean_domain.denbeigh_cloud.id
  type   = "NS"
  name   = "@"
  value  = "ns1.digitalocean.com."
}

resource "digitalocean_record" "denbeigh_cloud_ns_2" {
  domain = data.digitalocean_domain.denbeigh_cloud.id
  type   = "NS"
  name   = "@"
  value  = "ns2.digitalocean.com."
}

resource "digitalocean_record" "denbeigh_cloud_ns_3" {
  domain = data.digitalocean_domain.denbeigh_cloud.id
  type   = "NS"
  name   = "@"
  value  = "ns3.digitalocean.com."
}

resource "digitalocean_record" "bruce_denbeigh_cloud" {
  domain = data.digitalocean_domain.denbeigh_cloud.id
  type   = "A"
  name   = "bruce"
  value  = "23.145.80.211"
}

resource "digitalocean_record" "bruce_tailscale_denbeigh_cloud" {
  domain = data.digitalocean_domain.denbeigh_cloud.id
  type   = "A"
  name   = "bruce.tailscale"
  value  = data.tailscale_devices.bruce.devices[0].addresses[0]
}

resource "digitalocean_record" "tailscale_denbeigh_cloud" {
  for_each = toset(local.tailscale_aliases)

  domain = data.digitalocean_domain.denbeigh_cloud.id
  type   = "CNAME"
  name   = each.key
  value  = "bruce.tailscale.denbeigh.cloud."
}
