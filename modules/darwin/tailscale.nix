{ config, pkgs, lib, ... }:

let
  ts = builtins.trace (builtins.attrNames config.services.tailscale) config.services.tailscale;

  inherit (lib) mkIf;
  inherit (pkgs.stdenvNoCC.hostPlatform) isLinux;
in
{
  services.tailscale = {
    enable = true;
  };

  # TODO: Add support for automatic login with secret using launchd
  # age.secrets.tailscaleAuthKey.file = ../../secrets/tailscaleAuthKey.age;

  # Adapted from https://tailscale.com/blog/nixos-minecraft/
  # systemd.services.tailscale-login = {
  #   description = "Automatic connection to Tailscale";

  #   # make sure tailscale is running before trying to connect to tailscale
  #   after = [ "network-pre.target" "tailscale.service" ];
  #   wants = [ "network-pre.target" "tailscale.service" ];
  #   wantedBy = [ "multi-user.target" ];

  #   serviceConfig.Type = "oneshot";

  #   script = with pkgs; ''
  #     # wait for tailscaled to settle
  #     sleep 2

  #     # check if we are already authenticated to tailscale
  #     status="$(${pkgs.tailscale}/bin/tailscale status -json | ${pkgs.jq}/bin/jq -r .BackendState)"
  #     if [ $status = "Running" ]; then
  #       exit 0
  #     fi

  #     ${pkgs.tailscale}/bin/tailscale up -authkey "$(< ${config.age.secrets.tailscaleAuthKey.path})"
  #   '';

  # };
}
