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
    polarity = "dark";
    cursor = {
      package = pkgs.graphite-cursors;
      name = "graphite-dark";
      size = 32;
    };
    fonts = {
      monospace.name = "JetBrains Mono";
      monospace.package = pkgs.jetbrains-mono;
      sansSerif.name = "JetBrains Mono";
      sansSerif.package = pkgs.jetbrains-mono;
      serif.name = "JetBrains Mono";
      serif.package = pkgs.jetbrains-mono;
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
