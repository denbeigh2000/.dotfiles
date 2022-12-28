{ config, pkgs, cfdyndns-src, ... }:

let
  overlay = final: prev:
    {
      cfdyndns = prev.callPackage ../../../3rdparty/cfdyndns {
        inherit cfdyndns-src;
      };
    };
in
{
  nixpkgs.overlays = [ overlay ];

  age.secrets.cloudflareAPIKey = {
    file = ../../../secrets/cloudflareAPIToken.age;
    owner = "cfdyndns";
    group = "cfdyndns";
    mode = "440";
  };

  # NOTE: We don't use the in-built cfdyndns because it's an old version that
  # doesn't support api tokens.
  services.cfdyndns = {
    enable = true;
    email = "denbeigh+cloudflare@denbeighstevens.com";
    apikeyFile = config.age.cloudflareAPIKey.path;
    records = [ "ddns.denb.ee" ];
  };
}
