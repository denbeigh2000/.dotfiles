{ host, ... }:

let
  hostName = host.hostname;
  domain = host.domain or "denbeigh.cloud";

  locations = import ../../locations.nix;

  timezone = if host ? location
  then locations.${host.location}.tz
  else "UTC";

  graphicalModules =
    if host.graphical
    then [ ./graphical.nix ]
    else [ ];
in

{
  imports = [
    ./denbeigh.nix
    ./flakes.nix
    ./utils.nix
  ] ++ graphicalModules;

  networking = { inherit hostName domain; };

  time.timeZone = timezone;
  services.chrony.enable = true;
}
