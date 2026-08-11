{
  config,
  pkgs,
  user,
  lib,
  ...
}:
{
  imports = [
    ./animations.nix
    ./waybar.nix
    ./autostart.nix
  ];

  programs.niri = {
    settings =
      with config.lib.stylix.colors.withHashtag;
      let
        shadowConfig = {
          enable = true;
          spread = 0;
          softness = 10;
          color = "#000000dd";
        };
      in
      {
        hotkey-overlay.skip-at-startup = true;
        prefer-no-csd = true;
        input = {
          focus-follows-mouse.enable = false;
          touchpad.natural-scroll = false;
          keyboard.xkb.options = "caps:escape,ctrl:swap_lalt_lctl";
        };
        environment = {
          XIM = "fcitx";
          GTK_IM_MODULE = "fcitx";
          QT_IM_MODULE = "fcitx";
        };
        outputs = builtins.mapAttrs (name: value: {
          inherit (value) scale mode position;
          transform.rotation = value.rotation;
          background-color = base01;
        }) config.monitors;
        binds = with config.lib.niri.actions; {
          "Super+Return".action = spawn "kitty";
          "Super+Shift+Return".action = spawn [
            "kitty"
            "--app-id"
            "floating-terminal"
            "/home/${user}/scripts/quick-note"
          ];
          "Super+D".action = spawn [
            "noctalia-shell"
            "ipc"
            "call"
            "launcher"
            "toggle"
          ];
          "Super+O".action = spawn "obsidian";
          "Super+B".action = spawn "brave";
          "Super+Shift+M".action = spawn "switch-to-macos";

          # --- Migrated from swhkd ---
          "Super+Q".action = close-window;
          "Super+W".action = close-window;
          "Super+Shift+A".action = toggle-overview;
          "Super+T".action = toggle-column-tabbed-display;

          "Super+Left".action = focus-column-left;
          "Super+Right".action = focus-column-right;
          "Super+Down".action = focus-window-down;
          "Super+Up".action = focus-window-up;
          "Super+H".action = focus-column-or-monitor-left;
          "Super+L".action = focus-column-or-monitor-right;
          "Super+J".action = focus-window-or-workspace-down;
          "Super+K".action = focus-window-or-workspace-up;

          "Super+Shift+H".action = move-column-left-or-to-monitor-left;
          "Super+Shift+L".action = move-column-right-or-to-monitor-right;
          "Super+Shift+J".action = move-window-down-or-to-workspace-down;
          "Super+Shift+K".action = move-window-up-or-to-workspace-up;

          "Super+Ctrl+Left".action = focus-monitor-left;
          "Super+Ctrl+Down".action = focus-monitor-down;
          "Super+Ctrl+Up".action = focus-monitor-up;
          "Super+Ctrl+Right".action = focus-monitor-right;
          "Super+Ctrl+H".action = focus-monitor-left;
          "Super+Ctrl+J".action = focus-monitor-down;
          "Super+Ctrl+K".action = focus-monitor-up;
          "Super+Ctrl+L".action = focus-monitor-right;

          "Super+Shift+Ctrl+Left".action = move-window-to-monitor-left;
          "Super+Shift+Ctrl+Down".action = move-window-to-monitor-down;
          "Super+Shift+Ctrl+Up".action = move-window-to-monitor-up;
          "Super+Shift+Ctrl+Right".action = move-window-to-monitor-right;
          "Super+Shift+Ctrl+H".action = move-window-to-monitor-left;
          "Super+Shift+Ctrl+J".action = move-window-to-monitor-down;
          "Super+Shift+Ctrl+K".action = move-window-to-monitor-up;
          "Super+Shift+Ctrl+L".action = move-window-to-monitor-right;

          "Super+Shift+Space".action = toggle-window-floating;
          "Super+Space".action = switch-focus-between-floating-and-tiling;

          "Super+1".action = {
            focus-workspace = "coding";
          };
          "Super+2".action = {
            focus-workspace = "browsing";
          };
          "Super+3".action = {
            focus-workspace = "terminal";
          };
          "Super+4".action = {
            focus-workspace = "reading";
          };
          "Super+5".action = {
            focus-workspace = "music";
          };
          "Super+6".action = {
            focus-workspace = "proxy";
          };
          "Super+7".action = {
            focus-workspace = "general";
          };
          "Super+8".action = {
            focus-workspace = "reference";
          };
          "Super+9".action = {
            focus-workspace = "scratch";
          };

          "Super+Shift+1".action = {
            move-column-to-workspace = "coding";
          };
          "Super+Shift+2".action = {
            move-column-to-workspace = "browsing";
          };
          "Super+Shift+3".action = {
            move-column-to-workspace = "terminal";
          };
          "Super+Shift+4".action = {
            move-column-to-workspace = "reading";
          };
          "Super+Shift+5".action = {
            move-column-to-workspace = "music";
          };
          "Super+Shift+6".action = {
            move-column-to-workspace = "proxy";
          };
          "Super+Shift+7".action = {
            move-column-to-workspace = "general";
          };
          "Super+Shift+8".action = {
            move-column-to-workspace = "reference";
          };
          "Super+Shift+9".action = {
            move-column-to-workspace = "scratch";
          };

          "Super+Comma".action = consume-window-into-column;
          "Super+Period".action = expel-window-from-column;
          "Super+R".action = switch-preset-column-width;
          "Super+F".action = maximize-column;
          "Super+Shift+F".action = fullscreen-window;
          "Super+Ctrl+F".action = toggle-windowed-fullscreen;
          "Super+C".action = center-column;

          "Super+Minus".action = {
            set-column-width = "-10%";
          };
          "Super+Equal".action = {
            set-column-width = "+10%";
          };
          "Super+Shift+Minus".action = {
            set-window-height = "-10%";
          };
          "Super+Shift+Equal".action = {
            set-window-height = "+10%";
          };

          "Super+Alt+H".action = spawn "niri" "msg" "action" "move-floating-window" "-x" "-10";
          "Super+Alt+J".action = spawn "niri" "msg" "action" "move-floating-window" "-y" "10";
          "Super+Alt+K".action = spawn "niri" "msg" "action" "move-floating-window" "-y" "-10";
          "Super+Alt+L".action = spawn "niri" "msg" "action" "move-floating-window" "-x" "10";

          "Super+Alt+R".action = spawn "bash" "/home/${user}/scripts/record-screen-toggle";

          "Super+S".action = spawn "sh" "-c" "grim -g \"$(slurp)\" - | satty --filename -";
          "Ctrl+Super+S".action = spawn "sh" "-c" "grim - | wl-copy";
          "Alt+Super+S".action = spawn "sh" "-c" "grim -g \"$(slurp -f '%o')\" - | satty --filename -";

          "Super+Alt+M".action = set-dynamic-cast-monitor;
          "Super+Alt+W".action = set-dynamic-cast-window;
          "Super+Alt+N".action = clear-dynamic-cast-target;

          "Super+N".action = spawn "nautilus";
          "Super+Ctrl+C".action =
            spawn "sh" "-c"
              "niri msg pick-color | grep Hex | sd 'Hex: ' '' | sd '\\n' '' | wl-copy";

          # --- Migrated from basic.swhkdrc ---
          "Super+Alt+C".action = spawn "wl-color-picker";
          "Super+Shift+B".action = spawn "noctalia" "msg" "bar-toggle";
          "XF86AudioMute".action = spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle";
          "XF86AudioMicMute".action = spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SOURCE@" "toggle";
          "XF86AudioRaiseVolume".action = spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.1+";
          "XF86AudioLowerVolume".action = spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.1-";
          "Super+Shift+S".action =
            spawn "wshowkeys" "-a" "bottom" "-a" "right" "-F" "Comic Code 30" "-b" "${base00}aa" "-f"
              "${base0E}ee"
              "-s"
              "${base0F}ee"
              "-t"
              "1";
          "Super+E".action = spawn "hexecute";
          "Super+X".action =
            spawn "/home/${user}/.nix-profile/bin/noctalia" "ipc" "call" "sessionMenu"
              "toggle";

          "Super+Shift+W".action = spawn "sh" "-c" "/home/${user}/scripts/change-wal-niri";
        };
        window-rules =
          let
            matchAppIDs = appIDs: map (appID: { app-id = appID; }) appIDs;
          in
          [
            {
              geometry-corner-radius = {
                bottom-left = 10.0;
                bottom-right = 10.0;
                top-left = 10.0;
                top-right = 10.0;
              };
              clip-to-geometry = true;
              draw-border-with-background = false;
              default-column-width = {
                proportion = 0.75;
              };
            }
            {
              matches = [
                { app-id = "yad"; }
                { app-id = "floating-terminal"; }
              ];
              open-floating = true;
            }
            {
              matches = [ { app-id = "obsidian"; } ];
              open-on-workspace = "reading";
              default-column-width = {
                proportion = 1.0;
              };
            }
            {
              matches = [ { app-id = "mihomo-party"; } ];
              open-on-workspace = "proxy";
            }
            {
              matches = [
                { app-id = "menu.kando.Kando"; }
                { app-id = "kando"; }
              ];
              open-floating = true;
            }
            {
              matches = [ { app-id = "brave"; } ];
              open-on-workspace = "browsing";
            }
            {
              matches = matchAppIDs [
                "firefox"
                "org.qutebrowser.qutebrowser"
                "kitty"
                "evince"
                "zathura"
                "Zotero"
                "RStudio"
              ];
              default-column-width = {
                proportion = 0.95;
              };
            }
            {
              matches = [
                { is-focused = true; }
              ];
              opacity = 0.92;
            }
            {
              matches = [
                { is-focused = false; }
              ];
              opacity = 0.75;
            }
            {
              matches = [
                { app-id = "MATLAB R2024b - academic use"; }
              ];
              open-floating = true;
            }
          ];
        layer-rules = [
          {
            matches = [ { namespace = "awww-daemonbackdrop"; } ];
            place-within-backdrop = true;
          }
          {
            matches = [ { namespace = "launcher"; } ];
            geometry-corner-radius = {
              bottom-left = 15.0;
              bottom-right = 15.0;
              top-left = 15.0;
              top-right = 15.0;
            };
            shadow = shadowConfig;
          }
        ];
        gestures = {
          dnd-edge-view-scroll = {
            trigger-width = 60;
            delay-ms = 100;
            max-speed = 1500;
          };
        };
        workspaces = with config.lib.monitors; {
          "1" = {
            open-on-output = mainMonitorName;
            name = "coding";
          };
          "2" = {
            open-on-output = mainMonitorName;
            name = "browsing";
          };
          "3" = {
            open-on-output = builtins.head otherMonitorsNames;
            name = "terminal";
          };
          "4" = {
            open-on-output = builtins.head otherMonitorsNames;
            name = "reading";
          };
          "5" = {
            open-on-output = builtins.head otherMonitorsNames;
            name = "music";
          };
          "6" = {
            open-on-output = builtins.head otherMonitorsNames;
            name = "proxy";
          };
          "7" = {
            open-on-output = mainMonitorName;
            name = "general";
          };
          "8" = {
            open-on-output = mainMonitorName;
            name = "reference";
          };
          "9" = {
            open-on-output = mainMonitorName;
            name = "scratch";
          };
        };
        overview = {
          zoom = 0.36;
          backdrop-color = base02;
        };
        layout = {
          gaps = 12;
          border = {
            enable = true;
            width = 4;
            active = {
              gradient = {
                from = base07;
                to = base0E;
                angle = 45;
                in' = "oklab";
                # relative-to = "workspace-view";
              };
            };
            # inactive.color = "#585b70";
            inactive.color = base02;
          };
          focus-ring.enable = false;
          struts = {
            left = 2;
            right = 2;
            top = 0;
            bottom = 2;
          };
          insert-hint = {
            enable = true;
            display = {
              gradient = {
                from = base0A;
                to = base09;
                angle = 45;
              };
            };
          };
          shadow = shadowConfig;
          tab-indicator = {
            hide-when-single-tab = true;
            gap = 5;
            width = 6;
            length.total-proportion = 0.5;
            position = "right";
            gaps-between-tabs = 2;
          };
        };
      };
  };

  xdg.configFile.niri-config =
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
      enable = lib.mkForce true;
      text = lib.mkForce finalNiriConfig;
    };
}
