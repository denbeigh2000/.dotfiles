{ pkgs, config, ... }:

let
  packages = with pkgs; [ stdenv jre8 git config.programs.ssh.package nix ];
in
{
  imports = [ ./nginx/gocd.nix ];

  services = {
    gocd-server = {
      enable = true;
      inherit packages;
    };
    gocd-agent = {
      enable = true;
      inherit packages;
    };

    oauth2_proxy.nginx.virtualHosts = [ "ci.denbeigh.cloud" ];
  };
}
