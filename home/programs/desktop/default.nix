{ pkgs, ... }:
{
  imports = [
    ./tofi.nix
    ./fonts.nix
    ./mako.nix
    ./niri
    ./swhkd.nix
    ./maomaowm
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
