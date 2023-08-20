{ lib, ... }:

{
  imports = [ ../common/graphical.nix ];
  config = {
    denbeigh.machine.graphical = lib.mkDefault true;
  };
}
