{ pkgs, ... }:
{
  home.packages = with pkgs; [
    element-desktop
    telegram-desktop
  ];
}
