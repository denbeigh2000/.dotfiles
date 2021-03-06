{ work }:

let
  workEmail = "denbeigh.stevens@discordapp.com";
  personalEmail = "denbeigh@denbeighstevens.com";

  userName = "Denbeigh Stevens";
  userEmail = if work then workEmail else personalEmail;
in
{
  enable = true;
  inherit userName userEmail;
  extraConfig = {
    help.autocorrect = -1;
    merge.ff = "only";
    fetch.prune = true;
  };
}
