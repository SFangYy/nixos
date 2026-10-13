{ pkgs, ... }:
{
  home.packages = [ (import ./action-ring/switch-to-macos.nix { inherit pkgs; }) ];
}
