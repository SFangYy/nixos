{
  pkgs,
  lib,
  user,
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
      reload-waybar =
        lib.hm.dag.entryAfter [ "niri-transition" ]
          # bash
          ''
            run --quiet ${pkgs.systemd}/bin/systemctl --user restart waybar.service
          '';
    };

  };

  programs = {
    git = {
      enable = true;
      userName = "EdenQwQ";
      userEmail = "lsahlm1eden@gmail.com";
      extraConfig = {
        http = {
          proxy = "http://127.0.0.1:7890";
        };
        https = {
          proxy = "http://127.0.0.1:7890";
        };
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
