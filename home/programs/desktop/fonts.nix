{ pkgs, lib, ... }:
{
  home.packages = [
    pkgs.kose-font
    pkgs.hugmetight-font
    pkgs.material-symbols
    pkgs.maple-mono-variable
  ];
}
