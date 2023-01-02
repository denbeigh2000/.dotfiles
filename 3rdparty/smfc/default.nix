{ smfc-src, writeShellScriptBin, stdenvNoCC, python310 }:

let

  script = stdenvNoCC.mkDerivation {
  pname = "smfc-script";
  version = "v2.2.0-patch";

  src = smfc-src;

  installPhase = ''
    mkdir -p $out/bin

    cp src/smfc.py $out/bin/smfc.py
  '';
};

in
  writeShellScriptBin "smfc" ''
    ${python310}/bin/python ${script}/bin/smfc.py "$@"
  ''
