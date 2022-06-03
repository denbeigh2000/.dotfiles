{ configuration ? "single" }:

let
  extra_configs = {
    "single" = "";
    "triple_monitor" = (builtins.readFile ./triple_monitor);
  };

  config = extra_configs."${configuration}";
  text = ''
    ${builtins.readFile ./base}
    ${config}
  '';
in
{
  target = ".config/i3/config";
  inherit text;
}
