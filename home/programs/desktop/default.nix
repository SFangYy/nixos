{ inputs, pkgs, ... }:
{
  imports = [
    ./tofi.nix
    ./fonts.nix
    ./mako.nix
    ./niri
    ./swhkd.nix
    ./dms.nix
    ./caelestia.nix
    ./noctalia.nix
  ];
  home.packages = with pkgs; [
    swww
    swaybg
    kanshi
    wlsunset
    wayneko
    xwayland-satellite
    wmname
    inputs.hexecute.packages.${pkgs.stdenv.hostPlatform.system}.default
    inputs.quickshell.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
  home.file."scripts" = {
    source = ./scripts;
    recursive = true;
  };
  home.sessionVariables.QT_QPA_PLATFORMTHEME = "gtk3";
  services.wl-clip-persist.enable = true;
}
