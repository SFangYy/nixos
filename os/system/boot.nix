{ inputs, pkgs, ... }:
{
  boot = {
    kernelPackages =
      # inputs.nixpkgs-stable.legacyPackages.${pkgs.stdenv.hostPlatform.system}.linuxPackages_zen;
      pkgs.linuxPackages;
    kernelParams = [
      "loglevel=3"
      "quiet"
      "splash"
      "console=tty1"
    ];
    consoleLogLevel = 0;
    initrd.verbose = false;
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 5;
        graceful = true;
        consoleMode = "max";
        editor = false;
      };
      grub = {
        enable = false;
        device = "nodev";
        useOSProber = true;
        efiSupport = true;
        efiInstallAsRemovable = true;
        extraEntries = ''
          menuentry "Reboot" {
            reboot
          }
          menuentry "Poweroff" {
            halt
          }
        '';
        default = 0;
      };
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
    };
    plymouth.enable = true;
  };
}
