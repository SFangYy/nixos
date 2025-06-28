{ inputs, pkgs, ... }:
{
  imports = [
    ./tofi.nix
    ./fonts.nix
    ./mako.nix
    ./niri
    ./swhkd.nix
    ./scroll
    ./maomaowm
  ];
  home.packages = with pkgs; [
    swww
    swaybg
    kanshi
    wlsunset
    wayneko
    xwayland-satellite
    wmname
  ];
  home.file."scripts" = {
    source = ./scripts;
    recursive = true;
  };
}
