{ pkgs }:
pkgs.writeShellApplication {
  name = "switch-to-macos";
  runtimeInputs = with pkgs; [
    solaar
    ddcutil
    coreutils
    gawk
    libnotify
    util-linux
  ];
  text = builtins.readFile ./switch-to-macos.sh;
}
