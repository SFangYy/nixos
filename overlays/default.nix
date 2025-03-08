{ inputs, ... }:
{
  imports = [
    ./qutebrowser.nix
    ./cherry-studio.nix
    ./customColorSchemes
  ];
  nixpkgs.overlays = [
    inputs.niri.overlays.niri
  ];
}
