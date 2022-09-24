{ ... }@inputs:

let
  system = "x86_64-linux";
  host = {
    inherit system;
    work = false;
    hostname = "bruce";
    username = "denbeigh";
    graphical = false;
  };

  specialArgs = inputs // { inherit host; };

  mod = location: ../${location};
in
{
  inherit system specialArgs;
  modules = [
    (mod "nginx.nix")
    (mod "oauth2_proxy.nix")
    (mod "standard.nix")
  ];
}
