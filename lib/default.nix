{ lib }:

{
  /*
   * Given a path to a directory, return all .nix files in said directory
   * except default.nix, and return them as an attribute set by their filename.
   */
  loadDir = rawPath:
    let
      inherit (builtins) path readDir stringLength substring;
      inherit (lib.attrsets) filterAttrs mapAttrs';
      inherit (lib.strings) hasSuffix;

      isModule = (n: v:
        n != "default.nix" && v == "regular" && (hasSuffix ".nix" n));

      modules = filterAttrs isModule (readDir rawPath);
      toConfig = filename: _:
        let
          name = substring 0 ((stringLength filename) - 4) filename;
          value = import (rawPath + "/${filename}");
        in
        { inherit name value; };
    in
    mapAttrs' toConfig modules;
}
