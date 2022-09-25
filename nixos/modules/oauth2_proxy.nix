{ ... }:

{
  services.oauth2proxy = {
    enable = true;
    validateUrl = "https://auth.bruce.denb.ee/oauth/validate";
  };
}
