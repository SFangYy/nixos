{ pkgs }:
let
  mouseSwitch = import ./switch-mouse-host.nix { inherit pkgs; };
in
pkgs.writeShellApplication {
  name = "switch-to-macos";
  runtimeInputs = with pkgs; [
    mouseSwitch
    ddcutil
    coreutils
    gawk
    libnotify
    util-linux
  ];
  text = builtins.readFile ./switch-to-macos.sh;
}
