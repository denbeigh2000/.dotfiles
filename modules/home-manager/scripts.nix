{ self, pkgs, ... }:

{
  home.packages =
    with self.packages.${pkgs.targetPlatform.system}; [ gitignore roulette grid ];
}
