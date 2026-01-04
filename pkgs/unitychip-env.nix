{ pkgs, ... }:
let
  pkgsOld = import (builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/nixos-23.11.tar.gz";
    sha256 = "1f5d2g1p6nfwycpmrnnmc2xmcszp804adp16knjvdkj8nz36y1fg";
  }) { system = "x86_64-linux"; };

  pkgsLegacy = import (builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/nixos-21.11.tar.gz";
    sha256 = "04ffwp2gzq0hhz7siskw6qh9ys8ragp7285vi1zh8xjksxn1msc5";
  }) { system = "x86_64-linux"; };
in
pkgsOld.buildFHSEnv {
  name = "ue";
  targetPkgs =
    pkgsTarget:
    (with pkgsTarget; [
      coreutils
      gawk
      (pkgsOld.lib.hiPrio pkgsLegacy.pkgsStatic.gnugrep)
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
      (runCommand "gmake-symlink" {} ''
        mkdir -p $out/bin
        ln -s ${gnumake}/bin/make $out/bin/gmake
      '')
    ]);
  profile = ''
    export VERDI_HOME=$HOME/EDAHome/verdi/W-2024.09-SP1 
    export VCS_HOME=$HOME/EDAHome/vcs/W-2024.09-SP1
    export UVMC_HOME=$HOME/EDAHome/uvmc
    export UVM_HOME=$VCS_HOME/etc/uvm
    export PATH=$VCS_HOME/bin:$VERDI_HOME/bin:$PATH
  ''; 
  runScript = "bash -c 'cd ~/work && bash'";
}
