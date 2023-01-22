{
  system = "aarch64-darwin";
  config.denbeigh = {
    work = true;
    hostname = "mutant";
    username = "denbeighstevens";
    graphical = true;
    keys = [ "id_ed25519" ];
    location = {
      latitude = 37.7749;
      longitude = -122.4194;
    };
    alacritty.fontSize = 11.0;
  };
}
