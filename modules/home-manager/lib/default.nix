{ writeShellScriptBin
, nixgl
}:

{
  glWrap = pkg: name:
    writeShellScriptBin name ''
      ${nixgl.auto.nixGLDefault}/bin/nixGL ${pkg}/bin/${name} "$@"
    '';
}
