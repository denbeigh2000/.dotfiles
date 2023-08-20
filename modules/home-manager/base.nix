{ denbeigh-devtools, ... }:

{
  nixpkgs.overlays = [ denbeigh-devtools.overlays.default ];
}
