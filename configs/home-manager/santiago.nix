{
  system = "x86_64-linux";
  config.denbeigh = {
    work = true;
    hostname = "santiago";
    graphical = true;
    keys = [ "id_ed25519" ];
    # TODO: Make these normal modules
    location = {
      coordinates = {
        latitude = 37.7749;
        longitude = -122.4194;
      };
      timeZone = "America/Los_Angeles";
    };
  };
}
