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
    };
    nixPath = [ "nixpkgs=${nixpkgs}" ];
  };

  # Proxy settings for Nix daemon
  # Clash-party default HTTP proxy port
  systemd.services.nix-daemon.environment = {
    HTTP_PROXY = "http://127.0.0.1:7890";
    HTTPS_PROXY = "http://127.0.0.1:7890";
    http_proxy = "http://127.0.0.1:7890";
    https_proxy = "http://127.0.0.1:7890";
  };
}
