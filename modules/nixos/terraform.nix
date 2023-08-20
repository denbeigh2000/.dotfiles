{ self, config, pkgs, ... }:

let
  tf-providers = import self.inputs.terraform-providers-bin {
    inherit (pkgs.stdenv) system;
  };
  tf = (import ../../terraform {
    inherit pkgs tf-providers;
  }).packages;

  applyTerraform = pkgs.writeShellScriptBin "apply-terraform" ''
    set -euo pipefail

    TF_DIR="$(mktemp -d)"
    cd $TF_DIR
    MOD_SRC="$(${pkgs.coreutils}/bin/realpath --relative-to . ${tf.terraform-config})"

    source <(sudo cat ${config.age.secrets.terraform.path})
    ${tf.terraform}/bin/terraform init -from-module=$MOD_SRC

    ${tf.terraform}/bin/terraform apply
  '';
in

{
  age.secrets.terraform = {
    file = ../../secrets/terraform.age;
  };

  environment.systemPackages = [ applyTerraform ];
}
