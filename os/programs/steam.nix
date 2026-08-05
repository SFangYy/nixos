{ ... }:
{
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  programs = {
    steam = {
      enable = true;
      remotePlay.openFirewall = true;
    };
    gamemode.enable = true;
  };

  # Steam 客户端联网所需防火墙规则
  networking.firewall = {
    allowedTCPPorts = [ 27036 ];
    allowedTCPPortRanges = [
      {
        from = 27015;
        to = 27030;
      } # Steam 登录 / 内容服务器
    ];
    allowedUDPPorts = [
      4380
      27036
    ];
    allowedUDPPortRanges = [
      {
        from = 27000;
        to = 27100;
      } # Steam datagram relay / P2P
    ];
  };
}
