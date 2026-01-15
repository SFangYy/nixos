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
      "auto"
      "x-systemd.automount"
      "rw"
    ];
  };
}