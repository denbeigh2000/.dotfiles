{ nixpkgs-unstable
# , goi3bar-src
, noisetorch-src
, ...
}:

final: prev:
let
  pkgs-unstable = import nixpkgs-unstable {
    inherit (prev.stdenvNoCC.hostPlatform) system;
  };
in
{
  # These are very far apart, and have large feature gaps
  inherit (pkgs-unstable) radarr sonarr prowlarr;

  # This isn't backported as frequently as I'd like
  inherit (pkgs-unstable) tailscale;

  # Various 3rdparty packages
  # goi3bar = final.callPackage ./3rdparty/goi3bar { inherit goi3bar-src; };
  noisetorch = final.callPackage ./3rdparty/noisetorch { inherit noisetorch-src; };
}
