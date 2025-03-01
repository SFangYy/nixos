{ pkgs, lib, ... }:
{
  xdg.dataFile."fonts" = {
    source = ./fonts;
    recursive = true;
  };
  home.packages = [
    (import ../../../../pkgs/fonts/kose.nix {
      inherit pkgs lib;
      inherit (pkgs) stdenvNoCC;
    })
    (import ../../../../pkgs/fonts/hugmetight.nix {
      inherit pkgs lib;
      inherit (pkgs) stdenvNoCC;
    })
  ];
}
