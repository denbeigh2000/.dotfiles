locals {
  nfs_ipv4 = "208.94.117.103"
  nfs_ipv6 = "2607:ff18:80::3bb4"
}

data "cloudflare_zone" "denb_ee" {
  account_id = "bffbaac6f5b99e31a25b02b0b94ccd6e"
  name       = "denb.ee"
}

resource "cloudflare_record" "www_denb_ee" {
  zone_id = data.cloudflare_zone.denb_ee.id
  name    = "www"
  value   = "denb.ee"
  type    = "CNAME"
  ttl     = 3600
}

resource "cloudflare_record" "casino_denb_ee" {
  zone_id = data.cloudflare_zone.denb_ee.id
  name    = "casino"
  value   = "bruce.denbeigh.cloud"
  type    = "CNAME"
  ttl     = 3600
}

resource "cloudflare_record" "wikirace_denb_ee" {
  zone_id = data.cloudflare_zone.denb_ee.id
  name    = "wikirace"
  value   = local.nfs_ipv4
  type    = "A"
  ttl     = 3600
}

resource "cloudflare_record" "pre_wikirace_denb_ee" {
  zone_id = data.cloudflare_zone.denb_ee.id
  name    = "pre.wikirace"
  value   = local.nfs_ipv4
  type    = "A"
  ttl     = 3600
}

resource "cloudflare_record" "wikirace_ipv6_denb_ee" {
  zone_id = data.cloudflare_zone.denb_ee.id
  name    = "wikirace"
  value   = local.nfs_ipv6
  type    = "AAAA"
  ttl     = 3600
}

resource "cloudflare_record" "pre_wikirace_ipv6_denb_ee" {
  zone_id = data.cloudflare_zone.denb_ee.id
  name    = "pre.wikirace"
  value   = local.nfs_ipv6
  type    = "AAAA"
  ttl     = 3600
}

resource "cloudflare_record" "autodiscover_denb_ee" {
  zone_id         = data.cloudflare_zone.denb_ee.id
  name            = "autodiscover"
  value           = "autodiscover.outlook.com"
  type            = "CNAME"
  ttl             = 3600
  allow_overwrite = true
}

resource "cloudflare_record" "mail_denb_ee" {
  zone_id  = data.cloudflare_zone.denb_ee.id
  name     = "@"
  value    = "denb-ee.mail.protection.outlook.com."
  type     = "MX"
  priority = 30
  ttl      = 3600
}

resource "cloudflare_record" "mail_denb_ee_txt1" {
  zone_id = data.cloudflare_zone.denb_ee.id
  name    = "@"
  value   = "v=spf1 include:spf.protection.outlook.com -all"
  type    = "TXT"
  ttl     = 3600
}

resource "cloudflare_record" "mail_denb_ee_txt2" {
  zone_id = data.cloudflare_zone.denb_ee.id
  name    = "@"
  value   = "MS=ms46764552"
  type    = "TXT"
  ttl     = 3600
}
