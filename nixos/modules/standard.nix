{ host, ... }:

let
  hostName = host.hostname;
  domain = host.domain or "denbeigh.cloud";

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
}
