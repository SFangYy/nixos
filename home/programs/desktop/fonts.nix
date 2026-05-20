{ pkgs, lib, ... }:
{
  home.packages = [
    pkgs.hugmetight-font
    pkgs.material-symbols
    pkgs.jetbrains-mono

    # Microsoft fonts for WPS Office (Symbol, Wingdings, Webdings, MT Extra, etc.)
    pkgs.corefonts
    pkgs.ttf-wps-fonts
  ];
}
