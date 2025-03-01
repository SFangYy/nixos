{ pkgs, ... }:
{
  home.packages = with pkgs; [
    pspp
  ];
}
