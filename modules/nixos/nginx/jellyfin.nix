let
  backend = "http://localhost:8096";
in
import ./service.nix {
  name = "jellyfin";
  inherit backend;
  tailscale = true;

  extraConfig = {
    locations = {
      "= /web/".proxyPass = "${backend}/web/index.html";
      "= /".return = "302 http://$host/web/";

      " = socket".proxyWebsockets = true;

      "/" = {
        extraConfig = ''
          client_max_body_size 20M;
          proxy_buffering off;

          proxy_set_header Host $host;
          proxy_set_header X-Real-IP $remote_addr;
          proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
          proxy_set_header X-Forwarded-Proto $scheme;
          proxy_set_header X-Forwarded-Protocol $scheme;
          proxy_set_header X-Forwarded-Host $http_host;
        '';
      };
    };

  };
}
