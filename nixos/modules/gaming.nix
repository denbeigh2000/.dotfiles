{ pkgs, ... }:

{
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };
  environment = {
    systemPackages = [ pkgs.steam-run ];
    # https://nixos.wiki/wiki/Steam#GE-Proton_.28GloriousEggroll.29
    sessionVariables = {
      STEAM_EXTRA_COMPAT_TOOLS_PATHS = "\${HOME}/.steam/root/compatibilitytools.d";
    };
  };
}
