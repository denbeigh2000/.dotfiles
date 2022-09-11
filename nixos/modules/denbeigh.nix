{ lib
, pkgs
, home-manager
, hostname
, ...
}@inputs:

with lib;
let
  # inherit (config) hmConfig;
  hmConfig = "coder";
  system =  "x86_64-linux";
  hostArgs = {
    inherit system;
    host = {
      inherit system;
      work = false;
      hostname = "dev";
      username = "denbeigh";
      graphical = false;
      keys = null;
    };
  };
in
{
  options = {
    hmConfig = mkOption {
      type = types.str;
      default = null;
    };
  };

  config = {
    users.users.denbeigh = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
      shell = pkgs.zsh;
    };

    environment.systemPackages = with pkgs; [ git neovim ];

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;

      extraSpecialArgs = hostArgs;
      users.denbeigh = import ../../home.nix (inputs // hostArgs);
    };
  };
}
