{ config, pkgs, ... }:
{
  # Create .davfs2 directory and config
  home.file.".davfs2/davfs2.conf".text = ''
    use_locks 0
  '';

  # WebDAV mount service using systemd user service
  systemd.user.services.webdav-mount = {
    Unit = {
      Description = "Mount WebDAV share";
      After = [ "network-online.target" ];
      Wants = [ "network-online.target" ];
    };
    Service = {
      Type = "forking";
      ExecStartPre = "${pkgs.coreutils}/bin/mkdir -p %h/mnt/webdav";
      ExecStart = "${pkgs.davfs2}/bin/mount.davfs http://192.168.122.237:5005 %h/mnt/webdav -o rw,uid=%U";
      ExecStop = "${pkgs.util-linux}/bin/umount %h/mnt/webdav";
      Restart = "on-failure";
      RestartSec = "10s";
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
  };
}
