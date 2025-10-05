{
  pkgs,
  lib,
  user,
  config,
  ...
}:
{
  imports = [
    ./lib
    ./programs
    ./tweaks
  ];

  home = {
    username = user;
    homeDirectory = "/home/${user}";

    packages = with pkgs; [
      # files
      zip
      xz
      unzip

      # utils
      ripgrep
      zoxide
      fzf
      eza
      fd
    ];

    activation = {
      niri-transition =
        lib.hm.dag.entryAfter [ "writeBoundary" ]
          # bash
          ''
            run ${pkgs.niri-unstable}/bin/niri msg action do-screen-transition
          '';
      reload-swhkd =
        lib.hm.dag.entryAfter [ "niri-transition" ]
          # bash
          ''
            run --quiet ${pkgs.procps}/bin/pkill -HUP swhkd
          '';
    }
    // lib.mkIf (config.desktopShell == "waybar") {
      reload-waybar =
        lib.hm.dag.entryAfter [ "reload-swhkd" ]
          # bash
          ''
            run --quiet ${pkgs.systemd}/bin/systemctl --user reload waybar.service
          '';
    }
    // lib.mkIf (config.desktopShell == "dms") {
      reload-dms =
        lib.hm.dag.entryAfter [ "reload-swhkd" ]
          # bash
          ''
            run --quiet ${pkgs.systemd}/bin/systemctl --user reload dms.service
          '';
    };
  };

  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5 = {
      addons = with pkgs; [
        fcitx5-gtk
        libsForQt5.fcitx5-qt
        fcitx5-chinese-addons
        fcitx5-rime
        fcitx5-pinyin-moegirl
        fcitx5-pinyin-zhwiki
      ];
      waylandFrontend = true;
    };
  };

  programs = {
    git = {
      enable = true;
      userName = "EdenQwQ";
      userEmail = "lsahlm1eden@gmail.com";
      extraConfig = {
        safe = {
          directory = "*";
        };
      };
    };

    nix-index = {
      enable = true;
      enableFishIntegration = true;
      enableBashIntegration = false;
      enableZshIntegration = false;
    };

    home-manager.enable = true;
  };
}
