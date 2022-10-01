{ pkgs, tf-providers, ... }:

let
  tailscale-provider = tf-providers.mkTerraformProvider {
    owner = "tailscale";
    repo = "tailscale";
    version = "0.13.5";
    archSrc = {
      x86_64-linux = {
        sha256 = "9c3d98ac0dfa20fffa9e0f2f19263590e779595689d2e0133de50dd543a86ab4";
        url = "https://github.com/tailscale/terraform-provider-tailscale/releases/download/v0.13.5/terraform-provider-tailscale_0.13.5_linux_amd64.zip";
      };
    };
  };

  terraform = pkgs.terraform.withPlugins(p: [
    p.random
    p.null

    tf-providers.providers.cloudflare.cloudflare
    tf-providers.providers.digitalocean.digitalocean
    tf-providers.providers.hashicorp.aws
    tailscale-provider
  ]);

  terraform-config = pkgs.stdenv.mkDerivation {
    name = "terraform-config";
    dontFixup = true;
    dontBuild = true;

    src = ./.;

    checkPhase = ''
      ${pkgs.terraform}/bin/terraform fmt -check .
    '';

    installPhase = ''
      set -euo pipefail

      mkdir $out
      ${pkgs.findutils}/bin/find -mindepth 1 -maxdepth 1 \
        | ${pkgs.findutils}/bin/xargs -I{} cp -r {} $out/
    '';
  };
in

{
  devShell = pkgs.mkShell {
    name = "terraform-shell";
    packages = [ terraform pkgs.tflint ];
  };
  packages = { inherit terraform terraform-config; };
}
