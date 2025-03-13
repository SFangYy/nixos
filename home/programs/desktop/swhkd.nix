{ user, config, ... }:
{
  xdg.configFile."swhkd/basic.swhkdrc".text = config.lib.swhkd.mkSwhkdrc {
    keyBindings = [
      {
        key = "super + shift + r";
        command = "pkill -HUP swhkd";
      }
      {
        key = "super + alt + c";
        command = "wl-color-picker";
      }
      {
        key = "super + b";
        command = "pkill -USR1 .waybar-wrapped";
      }
      {
        key = "XF86AudioMute";
        command = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
      }
      {
        key = "XF86AudioMicMute";
        command = "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";
      }
      {
        key = "XF86AudioRaiseVolume";
        command = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1+";
      }
      {
        key = "XF86AudioLowerVolume";
        command = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1-";
      }
    ];
  };
  xdg.configFile."swhkd/tofi.swhkdrc".text = config.lib.swhkd.mkSwhkdrc {
    keyBindings = [
      {
        key = "super + x";
        command = "/home/${user}/scripts/tofi/powermenu";
      }
      {
        key = "super + shift + p";
        command = "sh -c $(tofi-drun)";
      }
    ];
  };
}
