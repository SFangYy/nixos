{
  pkgs,
  user,
  ...
}:
# Shared login account for colleagues who SSH in to run VCS/Verdi through the
# system-wide `ue` environment. The password is set interactively after the
# first rebuild (`sudo passwd eda`) so no hash lives in this repository.
{
  users.users.eda = {
    isNormalUser = true;
    description = "EDA shared account";
    # Keep the login shell POSIX-compatible for VS Code Remote-SSH; fish is
    # launched from inside `ue` anyway.
    shell = pkgs.bashInteractive;
    # Deliberately no wheel/docker/libvirtd: those groups are root-equivalent
    # on this host.
  };

  # Expose only the installed tool trees, without opening the owner's home.
  # Read-only bind mounts also avoid duplicating ~31 GiB of vendor binaries.
  fileSystems = builtins.listToAttrs (
    map
      (tool: {
        name = "/opt/eda/${tool}";
        value = {
          device = "/home/${user}/EDAHome/${tool}";
          fsType = "none";
          options = [
            "bind"
            "ro"
            "nofail"
          ];
        };
      })
      [
        "vcs"
        "verdi"
        "uvmc"
      ]
  );

  # `ue` starts in ~/work by convention; create it for the shared account.
  systemd.tmpfiles.rules = [
    "d /home/eda/work 0750 eda users - -"
    "d /opt/eda 0755 root root - -"
    "d /etc/eda 0755 root root - -"
  ];
}
