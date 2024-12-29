{
  mkConfig =
    { system
    , work ? false
    , modules ? [ ]
    , extraSpecialArgs ? { }
    }:
    (self:
    let
      pkgs = import self.inputs.nixpkgs {
        inherit system;
        overlays = [
          self.inputs.nixgl.overlays.default
        ];
      };

      # Ensure we avoid conflicting with any work-provided packages
      priority = if work then 10 else 5;

      inherit (pkgs.lib) setPrio;
      inherit (self.inputs.home-manager.lib) homeManagerConfiguration;

      config = homeManagerConfiguration {
        inherit pkgs;
        modules = [{ denbeigh.isNixOS = false; }] ++ modules;
        extraSpecialArgs = { inherit self; } // extraSpecialArgs;
      };
    in
    setPrio priority config);
}
