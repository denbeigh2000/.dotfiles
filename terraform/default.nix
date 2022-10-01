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

    tf-providers.providers.digitalocean.digitalocean
    tf-providers.providers.hashicorp.aws
    tailscale-provider
  ]);

  # TODO: Create a derivation that packages local config, and write a wrapper
  # to apply it
in

{
  devShell = pkgs.mkShell {
    name = "terraform-shell";
    packages = [ terraform pkgs.tflint ];
  };
  packages = { };
}
