{ host, ... }:

let
  hostName = host.hostname;
  domain = host.domain or "denbeigh.cloud";
in

{
  imports = [
    ./denbeigh.nix
    ./flakes.nix
    ./utils.nix
  ];

  networking = { inherit hostName domain; };
}
