{ pkgs, config, ... }:
with config.lib.stylix.colors.withHashtag;
let
  extraConfig =
    # kdl
    ''
      recent-windows {
          // off
          open-delay-ms 150

          highlight {
              active-color "${base0E}aa"
              urgent-color "${base08}aa"
              padding 30
              corner-radius 20
          }

          previews {
              max-height 480
              max-scale 0.5
          }

          binds {
              Alt+Tab         { next-window; }
              Alt+Shift+Tab   { previous-window; }
              Alt+grave       { next-window     filter="app-id"; }
              Alt+Shift+grave { previous-window filter="app-id"; }

              Mod+Tab         { next-window; }
              Mod+Shift+Tab   { previous-window; }
              Mod+grave       { next-window     filter="app-id"; }
              Mod+Shift+grave { previous-window filter="app-id"; }
          }
      }
    '';
  finalNiriConfig =
    builtins.replaceStrings
      [
        # "layout {"
      ]
      [
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
