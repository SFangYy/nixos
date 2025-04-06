{ pkgs, ... }:
{
  home.packages = [ pkgs.waycorner ];
  xdg.configFile."waycorner/config.toml".text = ''
    [niri-overview]
    enter_command = ["niri", "msg", "action", "toggle-overview"]
    locations = ["top_right"]
    size = 10
    margin = 20
    timeout_ms = 250
    color = "#FFFF0000"

    [niri-overview.output]
    description = ""
  '';
}
