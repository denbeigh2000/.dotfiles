let
  inherit (builtins) attrValues;

  hosts = {
    benson = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCqXRBsU3gLjNIGBxjkkt6z/jQL/oaC4TsLssdSl+DDzjhPgdpnOT5JN9R3d2SurZZOvZIZzSD2WjX05H9vPICOcX5jX5JDhXUUbsclaNekUSRRGf4BjusrBStWWdi8LgzNoZdWNrGM0eoRuigCGTovixjmsjVRehTEqI9aRgLxtVS4mvi1HgcDeER55ZOKROQlWtLuGlhzmD7PVSjcumx2dQrVKS2vcvEsrfSYkkX56U/W075JGduY/8FA49f167lKDomvn0F2Oo1RWotoTMtmjDakZqfDwZbura0b7qo0ORH4kl3G2RB0omI70T3usUXG8dl0wuVKpOj+ch9xJp+R";
    feliccia = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDGL5WQPkkTBBKKtJ0cYIdAvjz8mm7DtweeTvUKygP3jBPHQMJ63aRYHcOPq8UFo3ZpeFzbZG0M5rYgpgqk6ouo6csBvR81OYcVUjMGJ+ymnVNtmCh5rQLBcJ4U8h8oITxZuglkTcYpB11m1Ulgh7ewoIBgHFmd3cWs76b05jF8Eofxcnnbjsa/f+ui+nVWy6kuSw7El+FZEMjspVzp1HrL+lZA2ScNqrHlm4zPjQGSraWclEEKPtogWEuGWY/kgmx9qXoDhqH/a43slWbMW+x+BpDCGg4dNj4DxLqvpCDM2jPMy0a92GS1KqQUrKt2uurn4YlpLFgKD7RToRPwNd4b";
    martha = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFlSD0R2XzARKuBVfcw1EZ0MWhJky7q4STy4XYy2YIQO";
    mutant = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN1kbs7aoRMqvQrgdoXTYUA/E/LDDTBdEXsRP2xJos1q";
    runt = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPnB5kKoXQDMIUwELNSFZO8pHZQeIqn7fxrt/pEBiIfy";
    santiago = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEhLcnb7GSelOV/3x0DYwzfIZgQ0QGaK3ma4NzXND79k";
  };

  # TODO
  servers = {
    bruce = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMo37TCbucxMhvXt9mwR6iIJId82peZ6i31mfzDYx+2O";
  };
in
{
  "secrets/digitalOceanAPIKey.age".publicKeys = (attrValues hosts) ++ [ servers.bruce ];
  "secrets/oauth2Proxy.age".publicKeys = (attrValues hosts) ++ [ servers.bruce ];
}
