{ config, ... }:

{
  imports = [ ./nginx/oauth2_proxy.nix ];

  age.secrets.oauth2Proxy.file = ../../secrets/oauth2Proxy.age;

  services.oauth2_proxy = {
    enable = true;

    clientID = "d4a974e408abc94fa590";
    keyFile = config.age.secrets.oauth2Proxy.path;
    provider = "github";
    redirectURL = "http://auth.bruce.denbeigh.cloud/oauth/redirect";
    validateURL = "http://auth.bruce.denbeigh.cloud/oauth/validate";
    email.domains = [ "denbeighstevens.com" ];
    reverseProxy = true;
    extraConfig = {
      # Only users who can push to this public repo can access services.
      github-repo = "denbeigh2000/.dotfiles";
    };
  };
}
