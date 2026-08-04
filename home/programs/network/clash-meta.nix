{ pkgs, ... }:
{
  home.packages = with pkgs; [
    mihomo
    clash-verge-rev
  ];
}
