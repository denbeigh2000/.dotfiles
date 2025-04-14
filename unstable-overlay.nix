{ nixpkgs-unstable
  # , goi3bar-src
, noisetorch-src
, ...
}:

final: prev:
let
  pkgs-unstable = import nixpkgs-unstable {
    inherit (prev.stdenvNoCC.hostPlatform) system;

    # Sonarr currently depends on insecure versions of dotnet runtime.
    # https://github.com/NixOS/nixpkgs/issues/360592
    # https://github.com/NixOS/nixpkgs/issues/360592#issuecomment-2513490613
    config.permittedInsecurePackages = [
      "aspnetcore-runtime-6.0.36"
      "aspnetcore-runtime-wrapped-6.0.36"
      "dotnet-sdk-6.0.428"
      "dotnet-sdk-wrapped-6.0.428"
    ];
  };
in
{
  # These are very far apart, and have large feature gaps
  inherit (pkgs-unstable) radarr sonarr prowlarr;

  # Broken on 23.11?
  inherit (pkgs-unstable) jackett;

  # These aren't backported as frequently as I'd like
  inherit (pkgs-unstable) tailscale cfdyndns;

  # This segfaults on 24.11
  inherit (pkgs-unstable) uxplay;

  # Various 3rdparty packages
  # goi3bar = final.callPackage ./3rdparty/goi3bar { inherit goi3bar-src; };
  noisetorch = final.callPackage ./3rdparty/noisetorch { inherit noisetorch-src; };
}
