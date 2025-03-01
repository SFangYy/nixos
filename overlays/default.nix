{ inputs, ... }:
{
  imports = [
    ./qutebrowser.nix
    ./customColorSchemes
  ];
  nixpkgs.overlays = [
    inputs.niri.overlays.niri
  ];
}
