{ pkgs, config, lib, ... }:
with config.lib.stylix.colors.withHashtag;
let
  extraConfig =
    # kdl
    ''
      window-rule {
          match app-id="ai.moeru.airi"
          open-floating true
          border {
              off
          }
          shadow {
              off
          }
      }

      recent-windows {
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
        "output \"${config.lib.monitors.mainMonitorName}\" {"
      ]
      [
        ''
          output "${config.lib.monitors.mainMonitorName}" {
              hot-corners {
                  top-right
              }
        ''
      ]
      config.programs.niri.finalConfig
    + "\n"
    + extraConfig;
in
{
  xdg.configFile.niri-config.enable = lib.mkForce false;

  home.file.".config/niri/config.kdl".text = finalNiriConfig;
  home.file.".config/niri/config-override.kdl".text = finalNiriConfig;
}
