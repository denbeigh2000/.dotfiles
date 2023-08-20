{ standard
, development
, gaming
, ...
}:
let
  mod = location: ../../modules/nixos/${location};
in
{
  config = {
    system = "x86_64-linux";
    modules = [
      standard
      development
      gaming
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

          webcam = {
            enable = true;
            # TODO: Confirm
            videoDevice = "/dev/video0";
          };
        };

        # TODO: Use a more DRY setup for this
        age.identityPaths = [ "/home/denbeigh/.ssh/id_rsa" ];
      }
    ];
  };
}
