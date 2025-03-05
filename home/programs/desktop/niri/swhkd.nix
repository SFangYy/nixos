{ user, ... }:
{
  xdg.configFile."niri/swhkd/niri.swhkdrc".text = ''
    include /home/${user}/.config/swhkd/basic.swhkdrc
    include /home/${user}/.config/swhkd/tofi.swhkdrc

    super + shift + w
      /home/${user}/scripts/change-wal-niri

    super + q
      niri msg action close-window

    super + e
      niri msg action expand-column-to-available-width

    super + t
      niri msg action toggle-column-tabbed-display

    super + {left, down, up, right}
      niri msg action focus-column-{left, down, up, right}

    super + {h, l}
      niri msg action focus-column-or-monitor-{left, right}

    super + {j, k}
      niri msg action focus-window-or-workspace-{down, up}

    super + shift + h
      niri msg action move-column-left-or-to-monitor-left

    super + shift + l
      niri msg action move-column-right-or-to-monitor-right

    super + shift + j
      niri msg action move-window-down-or-to-workspace-down

    super + shift + k
      niri msg action move-window-up-or-to-workspace-up

    super + ctrl + {left, down, up, right}
      niri msg action focus-monitor-{left, down, up, right}

    super + ctrl + {h, j, k, l}
    	niri msg action focus-monitor-{left, down, up, right}

    super + shift + ctrl + {left, down, up, right}
    	niri msg action move-window-to-monitor-{left, down, up, right}

    super + shift + ctrl + {h, j, k, l}
    	niri msg action move-window-to-monitor-{left, down, up, right}

    super + shift + space
      niri msg action toggle-window-floating

    super + space
      niri msg action switch-focus-between-floating-and-tiling

    super + {_, shift +} {1-9}
      niri msg action {focus\-workspace, move\-window\-to\-workspace} {1-9}

    super + comma
      niri msg action consume-window-into-column

    super + period
      niri msg action expel-window-from-column

    super + r
      niri msg action switch-preset-column-width

    super + f
      niri msg action maximize-column

    super + shift + f
      niri msg action fullscreen-window

    super + c
      niri msg action center-column

    super + {_, shift +} {minus, equal}
      niri msg action set-{column\-width, window\-height} "{\-, +}10%"

    {ctrl +, alt +} print
      niri msg action screenshot-{screen, window}

    print
      niri msg action screenshot
  '';
}
