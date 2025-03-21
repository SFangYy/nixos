{ user, config, ... }:
let
  niriAction = key: action: {
    inherit key;
    command = "niri msg action ${action}";
  };
in
{
  xdg.configFile."niri/swhkd/niri.swhkdrc".text = config.lib.swhkd.mkSwhkdrc {
    includes = [
      "/home/${user}/.config/swhkd/basic.swhkdrc"
      "/home/${user}/.config/swhkd/tofi.swhkdrc"
    ];
    keyBindings = [
      {
        key = "super + shift + w";
        command = "/home/${user}/scripts/change-wal-niri";
      }
      (niriAction "super + q" "close-window")
      (niriAction "super + e" "expand-column-to-available-width")
      (niriAction "super + t" "toggle-column-tabbed-display")
      (niriAction "super + {left, down, up, right}" "focus-column-{left, down, up, right}")
      (niriAction "super + {h, l}" "focus-column-or-monitor-{left, right}")
      (niriAction "super + {j, k}" "focus-window-or-workspace-{down, up}")
      (niriAction "super + shift + h" "move-column-left-or-to-monitor-left")
      (niriAction "super + shift + l" "move-column-right-or-to-monitor-right")
      (niriAction "super + shift + j" "move-window-down-or-to-workspace-down")
      (niriAction "super + shift + k" "move-window-up-or-to-workspace-up")
      (niriAction "super + ctrl + {left, down, up, right}" "focus-monitor-{left, down, up, right}")
      (niriAction "super + ctrl + {h, j, k, l}" "focus-monitor-{left, down, up, right}")
      (niriAction "super + shift + ctrl + {left, down, up, right}" "move-window-to-monitor-{left, down, up, right}")
      (niriAction "super + shift + ctrl + {h, j, k, l}" "move-window-to-monitor-{left, down, up, right}")
      (niriAction "super + shift + space" "toggle-window-floating")
      (niriAction "super + space" "switch-focus-between-floating-and-tiling")
      (niriAction "super + {_, shift +} {1-9}" "{focus\\-workspace, move\\-window\\-to\\-workspace} {1-9}")
      (niriAction "super + comma" "consume-window-into-column")
      (niriAction "super + period" "expel-window-from-column")
      (niriAction "super + r" "switch-preset-column-width")
      (niriAction "super + f" "maximize-column")
      (niriAction "super + shift + f" "fullscreen-window")
      (niriAction "super + c" "center-column")
      (niriAction "super + {_, shift +} {minus, equal}" "set-{column\\-width, window\\-height} \"{\\-, +}10%\"")
      (niriAction "{ctrl +, alt +} print" "screenshot-{screen, window}")
      (niriAction "print" "screenshot")
    ];
  };
}
