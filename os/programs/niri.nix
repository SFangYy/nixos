{ pkgs, ... }:
{
  programs.niri = {
    enable = true;
    package = pkgs.niri-unstable;
  };
  # Apply the new binary to future sessions without terminating current work.
  systemd.user.services.niri = {
    overrideStrategy = "asDropin";
    restartIfChanged = false;
    stopIfChanged = false;
  };
}
