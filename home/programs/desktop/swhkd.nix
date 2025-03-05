{ user, ... }:
{

  xdg.configFile."swhkd/basic.swhkdrc".text = ''
    super + shift + r
      pkill -HUP swhkd

    super + enter
      kitty /home/${user}

    super + alt + c
      wl-color-picker

    super + b
      pkill -USR1 .waybar-wrapped

    XF86AudioMute
      wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle

    XF86AudioMicMute
      wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle

    XF86AudioRaiseVolume
      wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1+

    XF86AudioLowerVolume
      wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1-
  '';
  xdg.configFile."swhkd/tofi.swhkdrc".text = ''
    super + x
      /home/${user}/scripts/tofi/powermenu

    super + shift + c
      /home/${user}/scripts/tofi/colorscheme

    super + {_, shift +} p
      sh -c $(tofi-{run, drun})
  '';
}
