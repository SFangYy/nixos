{ inputs, pkgs, ... }:
{
  imports = [
    ./basic.nix
    ./doas.nix
    ./niri.nix
    # ./steam.nix
    ./waydroid.nix
    ./tuigreet.nix
    ./clash.nix
  ];

  services.displayManager.sessionPackages = [
    pkgs.halley
  ];

  programs.steam.enable = true;
}
