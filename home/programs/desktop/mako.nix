{ pkgs, ... }:
{
  services.mako = {
    enable = true;
    borderSize = 4;
    borderRadius = 8;
  };
  stylix.targets.mako.enable = true;
  home.packages = [ pkgs.libnotify ];
}
