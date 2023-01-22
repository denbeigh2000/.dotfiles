{ pkgs-unstable }:

final: prev: {
  # These are very far apart, and have large feature gaps
  inherit (pkgs-unstable) radarr sonarr prowlarr;

  # This isn't backported as frequently as I'd like
  inherit (pkgs-unstable) tailscale;
}
