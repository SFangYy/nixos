{ config, pkgs, lib, ... }:

let
  aic8800 = config.boot.kernelPackages.callPackage ../../pkgs/aic8800 { };
in
{
  # Kernel modules
  boot.extraModulePackages = [ aic8800 ];
  boot.kernelModules = [ "aic_load_fw" "aic8800_fdrv" ];

  # Firmware files (reuse from the same derivation)
  hardware.firmware = [ aic8800 ];

  # udev rules: auto-eject the virtual CD-ROM so the device switches to Wi-Fi mode
  services.udev.extraRules = ''
    # AIC8800 USB Wi-Fi adapter - eject virtual CD-ROM to switch to Wi-Fi mode
    KERNEL=="sd*", ATTRS{idVendor}=="a69c", ATTRS{idProduct}=="5721", SYMLINK+="aicudisk", RUN+="${pkgs.util-linux}/bin/eject /dev/%k"
    KERNEL=="sd*", ATTRS{idVendor}=="a69c", ATTRS{idProduct}=="5723", SYMLINK+="tendaudisk", RUN+="${pkgs.util-linux}/bin/eject /dev/%k"
    KERNEL=="sd*", ATTRS{idVendor}=="a69c", ATTRS{idProduct}=="5725", SYMLINK+="tendaudiskv2", RUN+="${pkgs.util-linux}/bin/eject /dev/%k"
  '';
}
