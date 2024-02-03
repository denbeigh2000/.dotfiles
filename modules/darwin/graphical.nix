{ lib, ... }:

{
  imports = [ ../common/graphical.nix ];
  config = {
    denbeigh.machine.graphical = lib.mkDefault true;

    services = {
      yabai = {
        enable = true;
        enableScriptingAddition = true;
        config = {
          layout = "bsp";
        };
      };

      skhd = {
        enable = true;
        skhdConfig = ''
          shift + cmd - h : yabai -m window --focus west
          shift + cmd - j : yabai -m window --focus south
          shift + cmd - k : yabai -m window --focus north
          shift + cmd - l : yabai -m window --focus east

          shift + ctrl + cmd - h : yabai -m window --warp west
          shift + ctrl + cmd - j : yabai -m window --warp south
          shift + ctrl + cmd - k : yabai -m window --warp north
          shift + ctrl + cmd - l : yabai -m window --warp east

          ctrl + cmd - 1 : yabai -m space --focus 1
          ctrl + cmd - 2 : yabai -m space --focus 2
          ctrl + cmd - 3 : yabai -m space --focus 3
          ctrl + cmd - 4 : yabai -m space --focus 4
          ctrl + cmd - 5 : yabai -m space --focus 5
          ctrl + cmd - 6 : yabai -m space --focus 6
          ctrl + cmd - 7 : yabai -m space --focus 7
          ctrl + cmd - 8 : yabai -m space --focus 8
          ctrl + cmd - 9 : yabai -m space --focus 9
          ctrl + cmd - 0 : yabai -m space --focus 10

          ctrl + cmd - l: yabai -m space --focus next
          ctrl + cmd - h: yabai -m space --focus prev
          ctrl + alt + cmd - l: yabai -m window --space next
          ctrl + alt + cmd - h: yabai -m window --space prev

          # increase window size
          shift + alt - l : yabai -m window --resize left:-20:0
          shift + alt - k : yabai -m window --resize top:0:-20

          # decrease window size
          shift + alt - h : yabai -m window --resize left:0:-20
          shift + alt - j : yabai -m window --resize top:0:20

          ctrl + cmd - return: /Applications/Nix\ Apps/Alacritty.app/Contents/MacOS/alacritty
        '';
      };
    };
  };
}
