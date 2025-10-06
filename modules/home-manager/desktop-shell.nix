{ config, lib, ... }:
with lib;
{
  options.desktopShell = mkOption {
    type = types.str;
    description = "The desktop shell to use.";
  };

  config = {
    programs.waybar = {
      enable = config.desktopShell == "waybar";
      systemd.enable = config.desktopShell == "waybar";
    };
    programs.dankMaterialShell = {
      enable = config.desktopShell == "dms";
      enableSystemd = config.desktopShell == "dms";
    };
  };
}
