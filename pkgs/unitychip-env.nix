{ pkgs, ... }:
let
  pkgsOld = import (builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/nixos-23.11.tar.gz";
    sha256 = "1f5d2g1p6nfwycpmrnnmc2xmcszp804adp16knjvdkj8nz36y1fg";
  }) { system = "x86_64-linux"; };
in
pkgsOld.buildFHSEnv {
  name = "ue";
  targetPkgs =
    pkgsTarget:
    (with pkgsTarget; [
      coreutils
      gawk
      gnugrep
      gnused
      file
      which
      binutils
      gcc
      gnumake

      # X11 libraries
      xorg.libX11
      xorg.libXext
      xorg.libXt
      xorg.libXft
      xorg.libXrender
      xorg.libXScrnSaver
      xorg.libXcursor
      xorg.libXdmcp
      xorg.libXau
      xorg.libXi
      xorg.libXrandr

      # Fonts
      fontconfig
      freetype

      # Common libraries
      zlib
      zlib.dev
      glibc
      libxcrypt
      ncurses5
      libxcrypt-legacy
      elfutils
      tcsh

      # Tools
      bc
      time

      # Shell
      bash

      # User requested
      cmake
      python311
      pkgs.verilator
      verible
      pkgs.swig
    ]);
  runScript = "bash -c 'cd ~/work && bash'";
}
