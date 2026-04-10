{ pkgs, user, ... }:
{
  environment.systemPackages = [ pkgs.davfs2 ];
  services.davfs2.enable = true;

  fileSystems."/home/${user}/work/fnos" = {
    device = "http://192.168.122.237:5005";
    fsType = "davfs";
    options = [
      "uid=${user}"
      "gid=users"
      "_netdev"
      "noauto"
      "nofail"
      "x-systemd.automount"
      "x-systemd.mount-timeout=10s"
      "x-systemd.device-timeout=5s"
      "x-systemd.idle-timeout=1min"
      "rw"
    ];
  };
}