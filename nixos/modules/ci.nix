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
      };
    })
  (pkgs.lib.range 1 12));
}
