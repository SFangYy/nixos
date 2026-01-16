{ pkgs, ... }:
{
  programs.clash-verge = {
    enable = false;
    package = pkgs.clash-verge-rev;
    tunMode = true;
  };

  # Allow mihomo to run with elevated permissions for TUN mode
  security.wrappers.mihomo = {
    owner = "root";
    group = "root";
    capabilities = "cap_net_admin,cap_net_bind_service=+ep";
    source = "${pkgs.mihomo}/bin/mihomo";
  };
}
