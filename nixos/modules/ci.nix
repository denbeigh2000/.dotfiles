{ pkgs, host, config, ... }:

let
  inherit (builtins) listToAttrs;

  ci-tool = (import ../../tools/ci { inherit pkgs; }).ci;
in

{
  age.secrets.buildkiteToken = {
    file = ../../secrets/buildkiteToken.age;
    mode = "640";
    group = "keys";
  };

  services.buildkite-agents = listToAttrs (map
    (n: rec {
      name = "${host.hostname}-${builtins.toString n}";
      value = {
        inherit name;
        tokenPath = config.age.secrets.buildkiteToken.path;
        privateSshKeyPath = "/var/lib/denbeigh/host_key";
        runtimePackages = with pkgs; [ buildkite-agent ci-tool bash gnutar gzip git nix ];
        hooks.pre-checkout = ''
          set -euo pipefail
          set -x

          mkdir -p $HOME/.ssh
          cp -rf /var/lib/denbeigh/host_key $HOME/.ssh/id_ed25519
          chmod -R go-rwx $HOME/.ssh
        '';
      };
    })
  (pkgs.lib.range 1 12));
}
