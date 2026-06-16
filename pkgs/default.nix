{ pkgs, ... }:
{
  hugmetight-font = pkgs.callPackage ./fonts/hugmetight.nix { };
  ttf-wps-fonts = pkgs.callPackage ./fonts/ttf-wps-fonts.nix { };
  custom-colorschemes = pkgs.callPackage ./customColorSchemes { };
  wallpapers = pkgs.callPackage ./wallpapers.nix { };
  wechat = pkgs.callPackage ./wechat.nix { };
  mihomo-party = pkgs.callPackage ./mihomo-party.nix { };
  etxlauncher = pkgs.callPackage ./etxlauncher.nix { };
  # maple-mono-variable = pkgs.callPackage ./maple-mono-variable.nix { };
  hachiyo-cursors = pkgs.callPackage ./hachiyo-cursors.nix { };
  halley = pkgs.callPackage ./halley.nix { };
}
