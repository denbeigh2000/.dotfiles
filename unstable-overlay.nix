{ pkgs-unstable
# , goi3bar-src
, noisetorch-src
, harmonia-src
, ...
}:

final: prev: {
  # These are very far apart, and have large feature gaps
  inherit (pkgs-unstable) radarr sonarr prowlarr;

  # This isn't backported as frequently as I'd like
  inherit (pkgs-unstable) tailscale;

  # Various 3rdparty packages
  # goi3bar = final.callPackage ./3rdparty/goi3bar { inherit goi3bar-src; };
  noisetorch = final.callPackage ./3rdparty/noisetorch { inherit noisetorch-src; };
  harmonia = import ./3rdparty/harmonia {
    inherit harmonia-src;
    pkgs = final;
  };
}
