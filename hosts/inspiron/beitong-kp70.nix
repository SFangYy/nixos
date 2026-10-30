{ pkgs, ... }:
let
  init = pkgs.writeScript "kp70-xinput-init" (
    "#!${pkgs.python3}/bin/python3\n" + builtins.readFile ./scripts/kp70-xinput-init.py
  );
in
{
  # KP70C falls back to NS/BFM after ~2 seconds without the XUSB10 handshake.
  # Run immediately on USB add, before that timeout; no driver replacement needed.
  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", ATTR{idVendor}=="20bc", ATTR{idProduct}=="5173", ATTR{product}=="*XINPUT WIRED", RUN+="${init} $env{DEVNAME}"
  '';
}
