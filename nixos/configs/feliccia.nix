let
  mod = location: ../modules/${location};
in
{
  host = {
    system = "x86_64-linux";
    work = false;
    hostname = "feliccia";
    username = "denbeigh";
    graphical = true;
    domain = "sfo.denbeigh.cloud";
    location = "sf";
  };
  config = {
    modules = [
      {
        boot.loader.grub.enable = true;
        boot.loader.grub.version = 2;
        boot.loader.grub.device = "/dev/sda";
      }
      (mod "standard.nix")
      (mod "development.nix")
      (mod "gaming.nix")
    ];
  };
}
