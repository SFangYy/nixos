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
    ./services/webdav.nix
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
      davfs2
      pay-respects  # Command correction tool (like thefuck)
      netcat-openbsd  # For SSH SOCKS5 proxy (nc -X 5)
      nmap  # For SSH HTTP proxy (ncat --proxy-type http)
    ];

    activation = {
      ensure-xauthority =
        lib.hm.dag.entryAfter [ "writeBoundary" ]
          ''
            XAUTHORITY_FILE="${config.home.homeDirectory}/.Xauthority"

            if [ ! -e "$XAUTHORITY_FILE" ]; then
              install -m 600 /dev/null "$XAUTHORITY_FILE"
            else
              chmod 600 "$XAUTHORITY_FILE"
            fi
          '';

      fix-ssh-config =
        lib.hm.dag.entryAfter [ "writeBoundary" ]
          # bash
          ''
            SSH_DIR="${config.home.homeDirectory}/.ssh"
            HM_SSH_CONFIG="$SSH_DIR/config"
            TMP_CONFIG="$SSH_DIR/config.hm.tmp"

            mkdir -p "$SSH_DIR"
            chmod 700 "$SSH_DIR"

            if [ -e "$HM_SSH_CONFIG" ]; then
              cp "$HM_SSH_CONFIG" "$TMP_CONFIG"
              rm -f "$HM_SSH_CONFIG"
              install -m 600 "$TMP_CONFIG" "$HM_SSH_CONFIG"
              rm -f "$TMP_CONFIG"
            fi
            if ${pkgs.systemd}/bin/systemctl --user is-active dms.service; then
              run --silence ${pkgs.systemd}/bin/systemctl --user stop dms.service
            fi
            if ${pkgs.systemd}/bin/systemctl --user is-active caelestia.service; then
              run --silence ${pkgs.systemd}/bin/systemctl --user stop caelestia.service
            fi
            if ${pkgs.systemd}/bin/systemctl --user is-active noctalia.service; then
              run --silence ${pkgs.systemd}/bin/systemctl --user stop noctalia.service
            fi
            run --silence ${pkgs.systemd}/bin/systemctl --user start ${if config.desktopShell == "noctalia-shell" then "noctalia" else config.desktopShell}.service || true
          '';
    };

    file.".ssh/config".force = true;
  };

  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5 = {
      addons = with pkgs; [
        fcitx5-gtk
        libsForQt5.fcitx5-qt
        qt6Packages.fcitx5-chinese-addons
        fcitx5-rime
        fcitx5-pinyin-moegirl
        fcitx5-pinyin-zhwiki
      ];
      waylandFrontend = true;
    };
  };

  # Keep pre-26.05 GTK4 theme behavior explicit to avoid HM legacy-default warning.
  gtk.gtk4.theme = lib.mkDefault config.gtk.theme;

  programs = {
    git = {
      enable = true;
      signing.format = "openpgp";
      settings = {
        user = {
          name = "SFangYy";
          email = "sfangyy@163.com";
        };
        safe = {
          directory = "*";
        };
        http = {
          proxy = "http://127.0.0.1:7890";
          version = "HTTP/1.1";
        };
        https = {
          proxy = "http://127.0.0.1:7890";
        };
      };
    };

    ssh = {
      enable = true;
      enableDefaultConfig = false;
      settings = {
        "github.com" = {
          HostName = "ssh.github.com";
          Port = 443;
          User = "git";
          # Route SSH through local HTTP proxy to avoid blocked/unstable direct 22.
          ProxyCommand = "${pkgs.nmap}/bin/ncat --proxy 127.0.0.1:7890 --proxy-type http %h %p";
          ServerAliveInterval = 30;
          ServerAliveCountMax = 3;
        };
        "172.19.20.3" = {
          HostName = "172.19.20.3";
          User = "songfangyuan";
        };
      };
    };

    nh = {
      enable = true;
      clean.enable = true;
      clean.extraArgs = "--keep-since 7d --keep 5";
      flake = "${config.home.homeDirectory}/.config/nixos";
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
