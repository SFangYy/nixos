{ pkgs, lib, ... }:
{
  home.packages = [
    pkgs.hugmetight-font
    pkgs.material-symbols
    pkgs.jetbrains-mono
  ];
}
