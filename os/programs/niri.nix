{ pkgs, ... }:
{
  programs.niri = {
    enable = true;
    package = pkgs.niri-unstable;
  };
  # Apply the new binary to future sessions without terminating current work.
  systemd.user.services.niri = {
    overrideStrategy = "asDropin";
    # Preserve the user manager's login PATH. NixOS' default service PATH
    # only contains core utilities and prevents Niri from spawning apps.
    enableDefaultPath = false;
    restartIfChanged = false;
    stopIfChanged = false;
  };
}
