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
      (mod "standard.nix")
      (mod "development.nix")
    ];
  };
}
