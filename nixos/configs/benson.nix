let
  mod = location: ../modules/${location};
in
{
  config = {
    system = "x86_64-linux";
    modules = [
      (mod "secrets.nix")
      (mod "standard.nix")
      (mod "development.nix")
      {
        denbeigh = {
          machine = {
            hostname = "benson";
            graphical = true;
            location = {
              timezone = "America/Los_Angeles";
              coordinates = {
                latitude = 37.7749;
                longitude = -122.4194;
              };
            };
          };

          user.keys = [ "id_rsa" ];
        };

        age.identityPaths = [ "/home/denbeigh/.ssh/id_rsa" ];
      }
    ];
  };
}
