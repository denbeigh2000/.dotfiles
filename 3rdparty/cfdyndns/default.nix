{ cfdyndns-src, lib, rustPlatform, pkg-config, openssl_1_1 }:

# Adapted from https://github.com/NixOS/nixpkgs/blob/dac57a4eccf1442e8bf4030df6fcbb55883cb682/pkgs/applications/networking/dyndns/cfdyndns/default.nix

let
  inherit (rustPlatform) buildRustPackage;
in
buildRustPackage {
  pname = "cfdyndns";
  version = "0.0.3+patch";
  src = cfdyndns-src;

  cargoSha256 = "sha256-giq/cM/taDqTcJD2hTK0rU6cr0+XT0X4CIf9OU5DgLo=";
  nativeBuildInputs = [ pkg-config  ];
  buildInputs = [ openssl_1_1 ];
}
