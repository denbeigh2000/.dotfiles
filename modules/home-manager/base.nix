{ self, ... }:

{
  nixpkgs.overlays = [ self.inputs.denbeigh-devtools.overlays.default ];
}
