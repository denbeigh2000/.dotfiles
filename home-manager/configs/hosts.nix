{
  coder = {
    system = "x86_64-linux";
    config.denbeigh = {
      username = "discord";
      hostname = "coder";
      work = true;
    };
  };
  feliccia = {
    system = "x86_64-linux";
    config.denbeigh = {
      hostname = "feliccia";
      keys = [ "id_rsa" ];
      graphical = true;
      location = {
        latitude = 37.7749;
        longitude = -122.4194;
      };
    };
  };
  martha = {
    system = "x86_64-linux";
    config.denbeigh = {
      hostname = "martha";
      graphical = true;
      keys = [ "id_ed25519" ];
      location = {
        latitude = 37.7749;
        longitude = -122.4194;
      };
    };
  };
  mutant = {
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
  };
  runt = {
    system = "x86_64-darwin";
    config.denbeigh = {
      work = true;
      hostname = "runt";
      username = "denbeighstevens";
      graphical = true;
      keys = [ "id_ed25519" ];
      location = {
        latitude = 37.7749;
        longitude = -122.4194;
      };
    };
  };
  santiago = {
    system = "x86_64-linux";
    config.denbeigh = {
      work = true;
      hostname = "santiago";
      graphical = true;
      keys = [ "id_ed25519" ];
      location = {
        latitude = 37.7749;
        longitude = -122.4194;
      };
    };
  };
}
