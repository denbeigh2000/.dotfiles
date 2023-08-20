{
  security.sudo.extraRules = [
    {
      users = [ "denbeigh" ];
      commands = [{
        command = "ALL";
        options = [ "NOPASSWD" ];
      }];
    }
  ];

  denbeigh.nix-cache.enable = false;
}
