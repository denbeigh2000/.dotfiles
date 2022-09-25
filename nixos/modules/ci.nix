{ pkgs, host, config, ... }:

let
  inherit (builtins) listToAttrs;
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
      };
    })
  (pkgs.lib.range 1 12));
}
