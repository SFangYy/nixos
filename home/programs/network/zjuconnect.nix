{ pkgs, ... }:
let
  zju-connect = import ../../../pkgs/zju-connect.nix {
    inherit (pkgs) lib buildGoModule fetchFromGitHub;
  };
  zjuconnect = pkgs.writeShellScriptBin "zjuconnect" ''exec ${zju-connect}/bin/zju-connect --config ~/.config/zju-connect/config.toml'';
in
{
  home.packages = [
    zju-connect
    zjuconnect
  ];
}
