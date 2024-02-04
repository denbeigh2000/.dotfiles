{ pkgs, config, ... }:

let
  inherit (builtins) listToAttrs;

  inherit (config.denbeigh.machine) hostname;
in

{
  age.secrets.buildkiteToken = {
    file = ../../secrets/buildkiteToken.age;
    mode = "640";
    group = "keys";
  };

  age.secrets.buildkiteAPIToken = {
    file = ../../secrets/buildkiteAPIToken.age;
    mode = "640";
    group = "keys";
  };

  services.buildkite-agents = listToAttrs (map
    (n: rec {
      name = "${hostname}-${builtins.toString n}";
      value = {
        inherit name;
        tokenPath = config.age.secrets.buildkiteToken.path;
        privateSshKeyPath = "/var/lib/denbeigh/host_key";
        runtimePackages = with pkgs; [ buildkite-agent bash gnutar gzip git nix ];
        hooks.pre-checkout = ''
          set -euo pipefail

          mkdir -p "$HOME/.ssh"
          cp -rf /var/lib/denbeigh/host_key "$HOME/.ssh/id_ed25519"
          chmod -R go-rwx "$HOME/.ssh"

          BUILDKITE_API_TOKEN="$(cat ${config.age.secrets.buildkiteAPIToken.path})"
          export BUILDKITE_API_TOKEN
        '';
      };
    })
    (pkgs.lib.range 1 12));
}
