{ pkgs, ... }:
{
  environment.systemPackages = [ pkgs.hellwm ];
  services.displayManager.sessionPackages = [ pkgs.hellwm ];
}
