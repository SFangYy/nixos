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

  # Proxy settings for Nix daemon. Keep this aligned with the user session
  # proxy; 7893 is the inactive Clash service port on this host, while 7890
  # is the working HTTP proxy used by curl and other tools.
  systemd.services.nix-daemon.environment = {
    HTTP_PROXY = "http://127.0.0.1:7890";
    HTTPS_PROXY = "http://127.0.0.1:7890";
    http_proxy = "http://127.0.0.1:7890";
    https_proxy = "http://127.0.0.1:7890";
    NO_PROXY = "localhost,127.0.0.1,::1";
    no_proxy = "localhost,127.0.0.1,::1";
  };
  systemd.services.nix-daemon = {
    wants = [ "mihomo.service" ];
    after = [ "mihomo.service" ];
  };
}
