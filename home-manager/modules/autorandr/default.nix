{ config, pkgs, lib, ... }:

let
  inherit (builtins) path readDir stringLength substring;
  inherit (lib) mapAttrs' mkIf;
  inherit (config.denbeigh) hostname;

  fileToConfig = filename: _:
    let
      name = substring 0 ((stringLength filename) - 4) filename;
    in
    { inherit name; value = import ./${filename}; };

  configFiles = readDir ./configs;
  configs = mapAttrs' fileToConfig configFiles;
  exists = configs ? hostname;
  config = if exists then configs.${hostname} else {};
in
{
  # TODO: Define these in host-level configuration directly
  programs.autorandr = mkIf exists ({
    enable = true;
  } // config);
}
