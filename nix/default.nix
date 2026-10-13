{ nixpkgs, ... }:
{
  imports = [
    ./substituters.nix
    ./nh.nix
    ./nixpkgs.nix
  ];

  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
        "pipe-operators"
      ];
      auto-optimise-store = true;
    };
    nixPath = [ "nixpkgs=${nixpkgs}" ];
  };

  # Proxy settings for Nix daemon
  # Clash-party default HTTP proxy port
  systemd.services.nix-daemon.environment = {
    HTTP_PROXY = "http://127.0.0.1:7893";
    HTTPS_PROXY = "http://127.0.0.1:7893";
    http_proxy = "http://127.0.0.1:7893";
    https_proxy = "http://127.0.0.1:7893";
    NO_PROXY = "localhost,127.0.0.1,::1";
    no_proxy = "localhost,127.0.0.1,::1";
  };
  systemd.services.nix-daemon = {
    wants = [ "mihomo.service" ];
    after = [ "mihomo.service" ];
  };
}
