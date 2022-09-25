{ pkgs, ... }:

{
  services.gocd-server = {
    enable = true;
  };
}
