{ pkgs, ... }:
{
  imports = [
    ./tofi.nix
    ./fonts.nx
    ./mako.nix
    ./niri
  ];
  home.packages = with pkgs; [
    swww
    kanshi
    wlsunset
    wayneko
  ];
  home.file."scripts" = {
    source = ./scripts;
    recursive = true;
  };
}
