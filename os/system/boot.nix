{ pkgs, ... }:
{
  boot = {
    kernelPackages = pkgs.linuxPackages_zen;
    kernelParams = [
      "loglevel=3"
      "quiet"
      "spash"
      "console=tty1"
    ];
    consoleLogLevel = 0;
    initrd.verbose = false;
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      efi.efiSysMountPoint = "/boot";
    };
    plymouth.enable = true;
  };
}
