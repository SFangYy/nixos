{ config, ... }:
let
  extraConfig =
    # kdl
    '''';
  finalNiriConfig =
    builtins.replaceStrings
      [ "output \"${config.lib.monitors.mainMonitorName}\" {" ]
      [ "output \"${config.lib.monitors.mainMonitorName}\" {\nfocus-at-startup" ]
      config.programs.niri.finalConfig
    + "\n"
    + extraConfig;
in
{
  home.file.".config/niri/config-override.kdl".text = finalNiriConfig;
}
