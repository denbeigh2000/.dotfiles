{ lib }:

rec {
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

  locations = rec {
    sf = {
      coordinates = {
        latitude = 37.773972;
        longitude = -122.431297;
      };
      timezone = "America/Los_Angeles";
    };
    sydney = {
      coordinates = {
        latitude = -33.865143;
        longitude = 151.209900;
      };
      timezone = "Australia/Sydney";
    };
    utc = {
      coordinates = {
        latitude = 0.0;
        longitude = 0.0;
      };
      timezone = "UTC";
    };

    # travelling
    milwaukee = {
      coordinates = {
        latitude = 43.0389025;
        longitude = -87.9064736;
      };
      timezone = "America/Central";
    };

    default = utc;
  };

  options =
    let
      inherit (lib) mkOption;
      inherit (lib.types) float str;

      mkCoord = title: mkOption {
        type = float;
        description = ''
          ${title} of the machine.
        '';
      };
    in
    {
      location = mkOption {
        type = types.location;
        default = locations.default;
        description = ''
          Coordinates and timezone of the machine.
          Used for redshift (on graphical machines) and setting timezone.
        '';
      };

      coordinates = mkOption {
        type = types.coordinates;
        default = locations.default.coordinates;
        description = ''
          Coordinates of the machine.
          Currently only used for redshift.
        '';
      };

      timezone = mkOption {
        type = str;
        default = locations.default.timezone;
        description = ''
          Time zone of the machine.
          Used for setting system time.
        '';
      };

      latitude = mkCoord "Latitude";
      longitude = mkCoord "Longitude";
    };

  types =
    let
      inherit (lib.types) submodule float str;
    in
    rec {

      location = submodule {
        options = {
          inherit (options) coordinates timezone;
        };
      };

      coordinates = submodule {
        options = {
          inherit (options) latitude longitude;
        };
      };
    };

}
