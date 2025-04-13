{ config, ... }:
let
  extraConfig =
    # kdl
    '''';
  finalNiriConfig =
    with config.lib.stylix.colors.withHashtag;
    builtins.replaceStrings
      [
        "output \"${config.lib.monitors.mainMonitorName}\" {"
        # "background-color \"${base01}\""
      ]
      [
        "output \"${config.lib.monitors.mainMonitorName}\" {\nfocus-at-startup"
        # "background-color \"${base01}\"\n    backdrop-color \"${base02}\""
      ]
      config.programs.niri.finalConfig
    + "\n"
    + extraConfig;
in
{
  home.file.".config/niri/config-override.kdl".text = finalNiriConfig;
}
