{ pkgs, ... }:

# Builds a wrapper around a flake's arch-specific outputs that encodes all
# contained derivations into arch-specific JSON-encoded summary files, used for
# diff detection

let
  inherit (builtins) filter listToAttrs map toJSON unsafeDiscardStringContext;
  inherit (pkgs) writeShellScriptBin writeText;
  inherit (pkgs.lib) collect getAttrs recursiveUpdate;
  inherit (pkgs.stdenvNoCC) mkDerivation;

  # buildableAttrs = [ "packages" "nixosConfigurations" "devShells" ];
  buildableAttrs = [ "packages" "devShells" ];
  filterRelevant = filter (d: d.system == pkgs.system);
  findDerivations = pkgs.lib.collect (o: o ? drvPath || o ? config.system.build.toplevel);

  mkEntry = deriv:
    let
      derivData = (
        if deriv ? drvPath
        then { isSystem = false; deriv = deriv; }
        else { isSystem = true; deriv = deriv.config.system.build.toplevel; }
      );
    in
    {
      inherit (derivData) isSystem;
      inherit (derivData.deriv.drvAttrs) name;

      # https://discourse.nixos.org/t/not-allowed-to-refer-to-a-store-path-error/5226/4
      # Due to us passing this to toJSON
      drvPath = unsafeDiscardStringContext derivData.deriv.drvPath;
      # Can't keep outPath it triggers special behaviours in nix
      outputPath = derivData.deriv.outPath;
    };
in
(outputs:
  let
    drvmap =
      let
        derivations = findDerivations (getAttrs buildableAttrs outputs);
        entries = map (d: mkEntry d) derivations;
        attrs = map (e: { name = e.drvPath; value = e; }) entries;
      in
      (writeText "drvmap.json" (toJSON (listToAttrs attrs)));

    printDrvmap =
      writeShellScriptBin "printDrvmap" ''
        cat ${drvmap}/drvmap.json
      '';

    all = {
      # packages = { inherit drvmap printDrvmap; };
      packages = { inherit drvmap printDrvmap; };
    };

  in
  recursiveUpdate outputs all)
