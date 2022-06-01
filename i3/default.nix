{ configuration ? "single" }:

let
  extra_configs = {
    "single" = "";
    "triple_monitor" = (builtins.readFile ./triple_monitor);
  };

  config = extra_configs."${configuration}";
in
  ''
${builtins.readFile ./base}
${config}
  ''
