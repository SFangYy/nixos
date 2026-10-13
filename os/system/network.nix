{
  config,
  pkgs,
  lib,
  ...
}:

let
  vmIP = "192.168.122.237";
  vmNetwork = "192.168.122.0/24";
  waydroidNetwork = "192.168.240.0/24";
  forwardPorts = [
    5666
    4450
    5005
    5173
    4533
  ];
  extraPorts = [
    8830 # UCSwarm runs on the host, not in the VM.
    8765
    8766
    8800
    53317
  ];
in
{
  # 1. 基础内核转发
  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
  };

  # 2. 开放防火墙端口 (宿主机入口)
  networking.nftables.enable = true;
  networking.firewall = {
    enable = true;
    allowedTCPPorts = forwardPorts ++ extraPorts;
    allowedUDPPorts = [ 53317 ]; # LocalSend
    trustedInterfaces = [
      "virbr0"
      "waydroid0"
    ];
  };

  # 声明式 NAT: 为 libvirt 和 waydroid 的内部网段都提供出站转发
  networking.nat = {
    enable = true;
    internalIPs = [
      vmNetwork
      waydroidNetwork
    ];
    internalInterfaces = [
      "virbr0"
      "waydroid0"
    ];
  };

  # Each listener has its own supervised lifetime. Backend outages only
  # affect individual connections, and one failed port cannot hide the rest.
  systemd.services = lib.listToAttrs (
    map (port: {
      name = "vm-port-forward-${toString port}";
      value = {
        description = "Forward TCP ${toString port} to VM";
        after = [
          "network.target"
          "libvirtd.service"
        ];
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          ExecStart = "${pkgs.socat}/bin/socat TCP4-LISTEN:${toString port},fork,reuseaddr TCP4:${vmIP}:${toString port}";
          Restart = "always";
          RestartSec = 5;
          DynamicUser = true;
          NoNewPrivileges = true;
          PrivateTmp = true;
          ProtectSystem = "strict";
          ProtectHome = true;
        };
      };
    }) forwardPorts
  );

  environment.systemPackages = [ pkgs.socat ];
}
