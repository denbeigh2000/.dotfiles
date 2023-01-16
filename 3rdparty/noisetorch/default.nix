{ noisetorch-src, buildGoModule }:

buildGoModule rec {
  pname = "NoiseTorch";
  version = "0.12.2-patch";

  src = noisetorch-src;

  vendorHash = null;

  doCheck = false;

  ldflags = [ "-s" "-w" "-X main.version=${version}" "-X main.distribution=nix" ];

  subPackages = [ "." ];

  preBuild = ''
    make -C c/ladspa/
    go generate
    rm  ./scripts/*
  '';

  postInstall = ''
    install -D ./assets/icon/noisetorch.png $out/share/icons/hicolor/256x256/apps/noisetorch.png
    install -Dm444 ./assets/noisetorch.desktop $out/share/applications/noisetorch.desktop
  '';
}
