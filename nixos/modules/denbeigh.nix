{ lib
, pkgs
, home-manager
, homeConfigurations
, hostname
, ...
}:

with lib;
let
  # inherit (config) hmConfig;
  hmConfig = "coder";
in
{
  options = {
    hmConfig = mkOption {
      type = types.str;
      default = null;
    };
  };

  config = {
    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      users.denbeigh = homeConfigurations.${hmConfig};
    };

    users.users.denbeigh = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
      shell = pkgs.zsh;
    };
  };
}
