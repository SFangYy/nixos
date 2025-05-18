{ config, ... }:
with config.lib.stylix.colors.withHashtag;
let
  extraConfig =
    # kdl
    ''
      overview {
        zoom 0.36
        backdrop-color "${base02}"
      }
      layer-rule {
        match namespace="wallpaper"
        place-within-backdrop true
      }
    '';
  finalNiriConfig =
    builtins.replaceStrings
      [
        "output \"${config.lib.monitors.mainMonitorName}\" {"
      ]
      [
        "output \"${config.lib.monitors.mainMonitorName}\" {\nfocus-at-startup"
      ]
      config.programs.niri.finalConfig
    + "\n"
    + extraConfig;
in
{
  home.file.".config/niri/config-override.kdl".text = finalNiriConfig;
}
