{ pkgs, ... }:

{
  devShell = pkgs.mkShell {
    name = "terraform-shell";
    packages = [ pkgs.terraform ];
  };
  packages = { };
}
