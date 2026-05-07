{ pkgs, ... }:
{
  environment.systemPackages = [ pkgs.davfs2 ];
  services.davfs2.enable = true;
}
