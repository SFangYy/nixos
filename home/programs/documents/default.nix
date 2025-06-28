{ pkgs, ... }:
{
  imports = [
    ./zathura.nix
  ];
  home.packages = with pkgs; [
    libreoffice
    onlyoffice-desktopeditors
  ];
}
