{ config, pkgs, lib, ... }:

let
  vmIP = "192.168.122.237";
  vmNetwork = "192.168.122.0/24";
  forwardPorts = [ 5666 445 5005 5173 4533];
in
{
  # 1. 基础内核转发
  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
  };

  # 2. 开放防火墙端口 (宿主机入口)
  networking.firewall = {
    enable = true;
    allowedTCPPorts = forwardPorts;

    # 恢复并固定虚拟机的 NAT 出网规则
    extraCommands = ''
      # 允许虚拟机访问外网的 NAT 规则 (如果 Libvirt 没自动创建)
      iptables -t nat -A POSTROUTING -s ${vmNetwork} ! -d ${vmNetwork} -j MASQUERADE

      # 允许转发虚拟机的流量
      iptables -I FORWARD 1 -s ${vmNetwork} -i virbr0 -j ACCEPT
      iptables -I FORWARD 1 -d ${vmNetwork} -o virbr0 -m state --state RELATED,ESTABLISHED -j ACCEPT
    '';
  };

  # 3. 使用 socat 进行端口映射 (入站)
  # 这样完全不干扰 Clash，因为对系统来说这就是宿主机进程在发包
  systemd.services = builtins.listToAttrs (map (port: {
    name = "port-forward-${toString port}";
    value = {
      description = "Forward port ${toString port} to VM";
      after = [ "network-online.target" "libvirtd.service" "sys-devices-virtual-net-virbr0.device" ];
      wants = [ "network-online.target" ];
      requires = [ "libvirtd.service" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.socat}/bin/socat TCP4-LISTEN:${toString port},fork,reuseaddr TCP4:${vmIP}:${toString port}";
        Restart = "always";
        RestartSec = "10s";
        StartLimitIntervalSec = 0;
        # 添加网络检查，确保 VM 网络就绪后再启动
        ExecStartPre = "${pkgs.bash}/bin/bash -c 'for i in {1..30}; do ${pkgs.iputils}/bin/ping -c1 -W1 ${vmIP} &>/dev/null && break || sleep 1; done'";
      };
    };
  }) forwardPorts);

  environment.systemPackages = [ pkgs.socat ];
}
