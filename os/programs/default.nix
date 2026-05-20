{ inputs, pkgs, ... }:
{
  imports = [
    ./basic.nix
    ./doas.nix
    ./niri.nix
    ./steam.nix
    ./swhkd.nix
    ./tuigreet.nix
    ./clash.nix
  ];

  services.displayManager.sessionPackages = [
    pkgs.halley
  ];
}
