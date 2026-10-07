{
  config,
  lib,
  ...
}:
{
  options.desktopShell =
    with lib;
    mkOption {
      type = types.str;
      description = "The desktop shell to use.";
    };

  config = {
    programs.waybar = {
      enable = config.desktopShell == "waybar";
      systemd.enable = config.desktopShell == "waybar";
    };
    # HM's module installs noctalia from nixpkgs by default.
    programs.noctalia = {
      enable = config.desktopShell == "noctalia-shell";
      systemd.enable = config.desktopShell == "noctalia-shell";
    };
  };
}
