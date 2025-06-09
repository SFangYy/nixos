{ pkgs, config, ... }:
with config.lib.stylix.colors.withHashtag;
let
  extraConfig =
    # kdl
    ''
      layer-rule {
        match namespace="wallpaper"
        place-within-backdrop true
      }

      xwayland-satellite {
        path "${pkgs.xwayland-satellite}/bin/xwayland-satellite"
      }
    '';
  finalNiriConfig =
    builtins.replaceStrings
      [
        "output \"${config.lib.monitors.mainMonitorName}\" {"
        # "layout {"
      ]
      [
        "output \"${config.lib.monitors.mainMonitorName}\" {\nfocus-at-startup"
        # ''
        #   layout {
        #       blur {
        #           on
        #           passes 2
        #           radius 5
        #           noise 0.1
        #       }
        # ''
      ]
      config.programs.niri.finalConfig
    + "\n"
    + extraConfig;
in
{
  home.file.".config/niri/config-override.kdl".text = finalNiriConfig;
}
