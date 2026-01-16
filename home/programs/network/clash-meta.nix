{ pkgs, ... }:
{
  home.packages = with pkgs; [
    clash-meta
    mihomo
    mihomo-party
  ];
}
