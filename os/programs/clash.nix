{
  pkgs,
  user,
  ...
}: {
  programs.clash-verge = {
    enable = false;
    package = pkgs.clash-verge-rev;
    tunMode = true;
  };

  networking.firewall.trustedInterfaces = ["Mihomo" "mihomo" "tun0"];
  #boot.kernel.sysctl = {
  #  "net.ipv4.ip_forward" = 1;
  #  "net.ipv6.conf.all.forwarding" = 1;
  #};

  # 创建 tun 组并添加用户，用于 TUN 设备访问权限
  users.groups.tun = {};

  # Allow mihomo to run with elevated permissions for TUN mode
  security.wrappers.mihomo = {
    owner = "root";
    group = "root";
    capabilities = "cap_net_admin,cap_net_bind_service+ep";
    source = "${pkgs.mihomo}/bin/mihomo";
  };

  # TUN 模式需要的服务配置
  systemd.services.mihomo-tun-setup = {
    description = "Setup TUN device for mihomo";
    wantedBy = ["multi-user.target"];
    after = ["network.target"];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = "${pkgs.bash}/bin/sh -c '${pkgs.coreutils}/bin/mkdir -p /dev/net && ${pkgs.coreutils}/bin/mknod -m 666 /dev/net/tun c 10 200 || true'";
    };
  };

  # Polkit rule to allow mihomo-party to manage network interfaces
  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
      if ((action.id == "org.freedesktop.policykit.exec" ||
           action.id == "org.freedesktop.NetworkManager.settings.modify.system" ||
           action.id == "org.freedesktop.NetworkManager.network-control") &&
          subject.isInGroup("wheel")) {
        return polkit.Result.YES;
      }
    });
  '';

  # udev 规则确保 TUN 设备权限
  services.udev.extraRules = ''
    KERNEL=="tun", MODE="0666", GROUP="tun", OPTIONS+="static_node=tun"
  '';
}
