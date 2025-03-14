{ pkgs, ... }:
let
  zju-connect = pkgs.callPackage ../../../pkgs/zju-connect.nix { };
  zjuconnect = pkgs.writeShellScriptBin "zjuconnect" ''exec ${zju-connect}/bin/zju-connect --config ~/.config/zju-connect/config.toml'';
in
{
  home.packages = [
    zju-connect
    zjuconnect
  ];
}
