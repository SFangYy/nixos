{
  pkgs,
  config,
  ...
}:
let
  inherit (config.lib.colorScheme) recolorScript;
in
{
  stylix = {
    autoEnable = false;
    targets.gtk.enable = true;
    targets.gtk.flatpakSupport.enable = true;
    cursor = {
      package = pkgs.graphite-cursors;
      name = "graphite-dark";
      size = 32;
    };
    fonts = {
      monospace.name = "Comic Mono";
      monospace.package = pkgs.comic-mono;
      sansSerif.name = "LXGW WenKai";
      sansSerif.package = pkgs.lxgw-wenkai;
      serif.name = "LXGW WenKai";
      serif.package = pkgs.lxgw-wenkai;
      emoji.name = "Noto Color Emoji";
      emoji.package = pkgs.noto-fonts-color-emoji;
    };
    iconTheme = {
      enable = true;
      package = pkgs.zafiro-icons.overrideAttrs (oldAttrs: {
        postInstall = recolorScript + (oldAttrs.postInstall or "");
      });
      dark = "Zafiro-icons-Dark";
      light = "Zafiro-icons-Light";
    };
  };
}
