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
    trustedInterfaces = [ "waydroid0" ];
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

  # 3. 使用 socat 进行端口映射
  # 脚本内部会等待虚拟机启动，所以直接随系统启动即可
  systemd.services.vm-port-forward = {
    description = "Forward ports to VM";
    after = [
      "network.target"
      "libvirtd.service"
    ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "simple";
      Restart = "on-failure";
      RestartSec = "10s";
      ExecStart =
        let
          script = pkgs.writeShellScript "vm-port-forward" ''
            # === 配置区域 ===
            VM_IP="${vmIP}"
            # 生成端口数组
            PORTS=(${builtins.toString forwardPorts})
            SOCAT_BIN="${pkgs.socat}/bin/socat"
            PING_BIN="${pkgs.iputils}/bin/ping"
            PKILL_BIN="${pkgs.procps}/bin/pkill"

            echo "开始监控虚拟机 ''${VM_IP} ..."

            # 持续循环，直到能 ping 通虚拟机
            while ! "$PING_BIN" -c 1 -W 1 "$VM_IP" &>/dev/null; do
                echo "虚拟机尚未就绪，5秒后重试..."
                sleep 5
            done

            echo "虚拟机 ''${VM_IP} 已上线！清理旧转发进程..."
            # 清理旧进程
            "$PKILL_BIN" -f "socat.*''${VM_IP}" || true

            # 循环启动转发
            for PORT in "''${PORTS[@]}"; do
                echo "正在映射端口: 宿主机:''${PORT} -> 虚拟机:''${PORT}"
                "$SOCAT_BIN" TCP4-LISTEN:"''${PORT}",fork,reuseaddr TCP4:"''${VM_IP}":"''${PORT}" &
            done

            echo "所有端口转发已在后台启动。"

            # 保持脚本运行，监控子进程
            wait
          '';
        in
        "${script}";
    };
  };

  environment.systemPackages = [ pkgs.socat ];
}
