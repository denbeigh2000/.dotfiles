{
  feliccia = {
    work = false;
    hostname = "feliccia";
    system = "x86_64-linux";
    username = "denbeigh";
    graphical = true;
    keys = [ "id_rsa" ];
  };
  martha = {
    work = false;
    hostname = "martha";
    system = "x86_64-linux";
    username = "denbeigh";
    graphical = true;
    keys = [ "id_ed25519" ];
  };
  mutant = {
    work = true;
    hostname = "mutant";
    system = "aarch64-darwin";
    username = "denbeighstevens";
    graphical = true;
    keys = [ "id_ed25519" ];
  };
}
