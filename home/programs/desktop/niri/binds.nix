{ config, user, ... }:
{
  programs.niri.settings.binds = with config.lib.niri.actions; {
    "Mod+Return".action = spawn "kitty";
    "Mod+X".action = spawn "/home/${user}/scripts/tofi/powermenu";
    "Mod+Shift+C".action = spawn "/home/${user}/scripts/tofi/colorscheme";
    "Mod+P".action = spawn "sh" "-c" "$(tofi-run)";
    "Mod+Shift+P".action = spawn "tofi-drun" "--drun-launch=true";
    "Mod+Shift+W".action = spawn "/home/${user}/scripts/change-wal-niri";
    "Mod+B".action = spawn "pkill" "-USR1" ".waybar-wrapped";
    "Mod+Q".action = close-window;
    "Mod+E".action = expand-column-to-available-width;
    "Mod+ALt+C".action = spawn "wl-color-picker";
    "Mod+N".action =
      spawn "wayneko" "--layer" "top" "--follow-pointer" "true" "--survive-close" "--background-colour"
        "0x${config.lib.stylix.colors.base0E}dd"
        "--outline-colour"
        "0x${config.lib.stylix.colors.base01}dd";

    "Mod+Shift+Slash".action = show-hotkey-overlay;
    "Mod+T".action = toggle-column-tabbed-display;

    "XF86AudioMute".action = spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle";
    "XF86AudioMicMute".action = spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SOURCE@" "toggle";
    "XF86AudioRaiseVolume".action = spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.1+";
    "XF86AudioLowerVolume".action = spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.1-";

    "Mod+Left".action = focus-column-left;
    "Mod+Down".action = focus-window-down;
    "Mod+Up".action = focus-window-up;
    "Mod+Right".action = focus-column-right;
    "Mod+H".action = focus-column-or-monitor-left;
    "Mod+J".action = focus-window-or-workspace-down;
    "Mod+K".action = focus-window-or-workspace-up;
    "Mod+L".action = focus-column-or-monitor-right;

    "Mod+Shift+Left".action = move-column-left;
    "Mod+Shift+Down".action = move-window-down;
    "Mod+Shift+Up".action = move-window-up;
    "Mod+Shift+Right".action = move-column-right;
    "Mod+Shift+H".action = move-column-left-or-to-monitor-left;
    "Mod+Shift+J".action = move-window-down-or-to-workspace-down;
    "Mod+Shift+K".action = move-window-up-or-to-workspace-up;
    "Mod+Shift+L".action = move-column-right-or-to-monitor-right;

    "Mod+Ctrl+Left".action = focus-monitor-left;
    "Mod+Ctrl+Down".action = focus-monitor-down;
    "Mod+Ctrl+Up".action = focus-monitor-up;
    "Mod+Ctrl+Right".action = focus-monitor-right;
    "Mod+Ctrl+H".action = focus-monitor-left;
    "Mod+Ctrl+J".action = focus-monitor-down;
    "Mod+Ctrl+K".action = focus-monitor-up;
    "Mod+Ctrl+L".action = focus-monitor-right;

    "Mod+Shift+Ctrl+Left".action = move-window-to-monitor-left;
    "Mod+Shift+Ctrl+Down".action = move-window-to-monitor-down;
    "Mod+Shift+Ctrl+Up".action = move-window-to-monitor-up;
    "Mod+Shift+Ctrl+Right".action = move-window-to-monitor-right;
    "Mod+Shift+Ctrl+H".action = move-window-to-monitor-left;
    "Mod+Shift+Ctrl+J".action = move-window-to-monitor-down;
    "Mod+Shift+Ctrl+K".action = move-window-to-monitor-up;
    "Mod+Shift+Ctrl+L".action = move-window-to-monitor-right;

    "Mod+Shift+Space".action = toggle-window-floating;
    "Mod+Space".action = switch-focus-between-floating-and-tiling;

    "Mod+TouchpadScrollDown" = {
      action = focus-workspace-down;
      cooldown-ms = 150;
    };
    "Mod+TouchpadScrollUp" = {
      action = focus-workspace-up;
      cooldown-ms = 150;
    };

    "Mod+1".action = focus-workspace 1;
    "Mod+2".action = focus-workspace 2;
    "Mod+3".action = focus-workspace 3;
    "Mod+4".action = focus-workspace 4;
    "Mod+5".action = focus-workspace 5;
    "Mod+6".action = focus-workspace 6;
    "Mod+7".action = focus-workspace 7;
    "Mod+8".action = focus-workspace 8;
    "Mod+9".action = focus-workspace 9;
    "Mod+Ctrl+1".action = move-window-to-workspace 1;
    "Mod+Ctrl+2".action = move-window-to-workspace 2;
    "Mod+Ctrl+3".action = move-window-to-workspace 3;
    "Mod+Ctrl+4".action = move-window-to-workspace 4;
    "Mod+Ctrl+5".action = move-window-to-workspace 5;
    "Mod+Ctrl+6".action = move-window-to-workspace 6;
    "Mod+Ctrl+7".action = move-window-to-workspace 7;
    "Mod+Ctrl+8".action = move-window-to-workspace 8;
    "Mod+Ctrl+9".action = move-window-to-workspace 9;

    "Mod+Comma".action = consume-window-into-column;
    "Mod+Period".action = expel-window-from-column;
    "Mod+BracketLeft".action = consume-or-expel-window-left;
    "Mod+BracketRight".action = consume-or-expel-window-left;

    "Mod+R".action = switch-preset-column-width;
    "Mod+Shift+R".action = reset-window-height;
    "Mod+F".action = maximize-column;
    "Mod+Shift+F".action = fullscreen-window;
    "Mod+C".action = center-column;

    "Mod+Minus".action = set-column-width "-10%";
    "Mod+Equal".action = set-column-width "+10%";
    "Mod+Shift+Minus".action = set-window-height "-10%";
    "Mod+Shift+Equal".action = set-window-height "+10%";

    "Print".action = screenshot;
    "Ctrl+Print".action = screenshot-screen;
    "Alt+Print".action = screenshot-window;

    "Mod+Shift+E".action = quit;
  };
}
