{
  pkgs,
  user,
  ...
}:
{
  networking.networkmanager.enable = true;
  systemd.services.NetworkManager-wait-online.enable = false;

  time = {
    timeZone = "Asia/Shanghai";
  };

  i18n = {
    extraLocaleSettings = {
      LANGUAGE = "en_US.UTF-8";
      LC_ALL = "en_US.UTF-8";
      LC_ADDRESS = "en_US.UTF-8";
      LC_IDENTIFICATION = "en_US.UTF-8";
      LC_MEASUREMENT = "en_US.UTF-8";
      LC_MONETARY = "en_US.UTF-8";
      LC_NAME = "en_US.UTF-8";
      LC_NUMERIC = "en_US.UTF-8";
      LC_PAPER = "en_US.UTF-8";
      LC_TELEPHONE = "en_US.UTF-8";
      LC_TIME = "en_US.UTF-8";
    };

    inputMethod = {
      enable = true;
      type = "fcitx5";
      fcitx5.addons = with pkgs; [
        fcitx5-gtk
        libsForQt5.fcitx5-qt
        qt6Packages.fcitx5-chinese-addons
        fcitx5-rime
        fcitx5-pinyin-moegirl
        fcitx5-pinyin-zhwiki
      ];
    };
  };

  services = {
    displayManager.gdm.enable = false;
    desktopManager.gnome.enable = true;

    xserver = {
      enable = true;
      desktopManager.runXdgAutostartIfNone = true;
      xkb.layout = "us";
      xkb.variant = "";
    };

    fprintd = {
      enable = false;
    };

    printing.enable = true;

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    blueman.enable = true;

    # gnome.gnome-browser-connector.enable = true;

    gvfs.enable = true;

    openssh = {
      enable = true;
      openFirewall = true;
      settings.X11Forwarding = true;
    };

    # dae = {
    #   enable = true;
    #   configFile = "/home/${user}/.config/dae/config.dae";
    # };

    upower.enable = true;

    udisks2.enable = true;

    tuned.enable = true;
  };

  security = {
    rtkit.enable = true;
    sudo.extraRules = [
      {
        users = [ user ];
        commands = [
          {
            command = "/run/current-system/sw/bin/nixos-rebuild";
            options = [ "NOPASSWD" ];
          }
          {
            command = "/run/current-system/sw/bin/systemctl start nh-clean.service";
            options = [ "NOPASSWD" ];
          }
        ];
      }
    ];

    polkit.enable = true;
  };

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  hardware.i2c.enable = true;
  hardware.logitech.wireless.enable = true;

  documentation.man.cache.enable = true;

  users.users.${user} = {
    # VS Code Remote-SSH executes POSIX shell startup scripts on the remote
    # host. Keep the login shell POSIX-compatible; fish can still be launched
    # from interactive terminals via the user's shell configuration.
    shell = pkgs.bashInteractive;
    isNormalUser = true;
    description = "Eden Lee";
    extraGroups = [
      "networkmanager"
      "wheel"
      "adbuser"
      "libvirtd"
      "video"
      "kvm"
      "davfs2"
      "docker"
      "tun"
      "input"
      "i2c"
    ];
  };

  environment = {
    systemPackages = with pkgs; [
      git
      gcc
      wget
      curl
      gnumake
      cmake
      rustc
      cargo
      rustfmt
      clippy
      rust-analyzer
      ntfs3g
      base16-schemes
      home-manager
      polkit
      polkit_gnome
      nodejs
      efibootmgr
      pciutils
      xauth
      ddcutil
    ];

    variables = {
      EDITOR = "nvim";
      NIRI_CONFIG = "/home/${user}/.config/niri/config.kdl";
      ALL_PROXY = "http://127.0.0.1:7890";
      HTTP_PROXY = "http://127.0.0.1:7890";
      HTTPS_PROXY = "http://127.0.0.1:7890";
      NO_PROXY = "127.0.0.1,localhost,::1,192.168.122.237,192.168.122.0/24,172.16.0.0/12,10.0.0.0/8,192.168.0.0/16,api.kxyai.top";
      all_proxy = "http://127.0.0.1:7890";
      http_proxy = "http://127.0.0.1:7890";
      https_proxy = "http://127.0.0.1:7890";
      no_proxy = "127.0.0.1,localhost,::1,192.168.122.237,192.168.122.0/24,172.16.0.0/12,10.0.0.0/8,192.168.0.0/16,api.kxyai.top";
    };

    sessionVariables = {
      SDL_IM_MODULE = "fcitx";
      GLFW_IM_MODULE = "fcitx";
      QT_SCALE_FACTOR_ROUNDING_POLICY = "round";
      GSK_RENDERER = "vulkan";
      NIXOS_OZONE_WL = "1";
    };

    localBinInPath = true;
  };

  # systemd.services.clash-verge-service = {
  #   description = "Clash Verge Service Mode";
  #   wantedBy = [ "multi-user.target" ];
  #   serviceConfig = {
  #     ExecStart = "${pkgs.clash-verge-rev}/bin/clash-verge-service"; # 注意检查路径是否存在
  #     Restart = "always";
  #     User = "root"; # 服务模式必须 root 运行
  #   };
  # };

  systemd.user.services = {
    # GNOME's XDG autostart already provides the authentication agent.
    niri-flake-polkit.enable = false;
  };

  virtualisation = {
    libvirtd.enable = true;

    # UCSwarm's service/stack backend requires the real Docker Swarm API.
    docker.enable = true;

  };
}
