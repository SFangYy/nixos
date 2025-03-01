{ pkgs, lib, ... }:
{
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
