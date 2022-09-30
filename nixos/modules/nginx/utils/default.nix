let
  addr = "100.110.24.108";  # Bruce IP
in
rec {
  withTailscale = {
    listen = [
      {
        inherit addr;
        port = 443;
        ssl = true;
      }
      {
        inherit addr;
        port = 80;
      }
    ];
  } // withSSL;

  withSSL = {
    enableACME = true;
    forceSSL = true;
    # Must be null to enforce using DNS challenge default
    acmeRoot = null;
  };
}
