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
    '';
  finalNiriConfig =
    builtins.replaceStrings
      [
        "output \"${config.lib.monitors.mainMonitorName}\" {"
        "background-color \"${base01}\""
      ]
      [
        "output \"${config.lib.monitors.mainMonitorName}\" {\nfocus-at-startup"
        "background-color \"${base01}\""
      ]
      config.programs.niri.finalConfig
    + "\n"
    + extraConfig;
in
{
  home.file.".config/niri/config-override.kdl".text = finalNiriConfig;
}
