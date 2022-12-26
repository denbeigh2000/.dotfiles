let
  mod = location: ../modules/${location};
in
{
  config = {
    system = "x86_64-linux";
    modules = [
      (mod "standard.nix")
      (mod "development.nix")
      (mod "gaming.nix")
      {
        boot.loader.grub = {
          enable = true;
          version = 2;
          device = "/dev/sda";
        };

        denbeigh = {
          machine = {
            hostname = "feliccia";
            graphical = true;
            location = {
              timezone = "America/Los_Angeles";
              coordinates = {
                latitude = 37.7749;
                longitude = -122.4194;
              };
            };
          };
        };
      }
    ];
  };
}
