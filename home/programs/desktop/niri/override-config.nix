{ config, ... }:
let
  #   tabIndicatorConfig = # kdl
  #     ''
  #       tab-indicator {
  #         hide-when-single-tab
  #         gap 5
  #         width 6
  #         length total-proportion=0.5
  #         position "right"
  #         gaps-between-tabs 2
  #       }
  #     '';
  #   shadowConfig =
  #     # kdl
  #     ''
  #       shadow {
  #         on
  #         spread 0
  #         softness 10
  #         color "#000000dd"
  #       }
  #     '';
  #   tabBinds = # kdl
  #     ''
  #       Mod+T { toggle-column-tabbed-display; }
  #     '';
  extraConfig =
    # kdl
    '''';
  finalNiriConfig =
    # builtins.replaceStrings
    #   [ "layout {" ]
    #   [
    #     ("layout {\n" + shadowConfig + "\n" + tabIndicatorConfig)
    #   ]
    # (config.programs.niri.finalConfig + "\n" + extraConfig)
    # |>
    #   builtins.replaceStrings
    #     [ "binds {" ]
    #     [
    #       ("binds {\n" + tabBinds)
    #     ];
    config.programs.niri.finalConfig + "\n" + extraConfig;
in
{
  home.file.".config/niri/config-override.kdl".text = finalNiriConfig;
}
