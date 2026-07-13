{
  pkgs,
  user,
  ...
}:
{
  imports = [
    ./boot.nix
  ];

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
      enable = true;
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

    flatpak.enable = true;

    upower.enable = true;

    udisks2.enable = true;

    power-profiles-daemon.enable = true;
  };

  security = {
    rtkit.enable = true;
    sudo.extraRules = [
      {
        users = [ user ];
        commands = [
          {
            command = "ALL";
            options = [ "NOPASSWD" ];
          }
        ];
      }
    ];

    polkit.enable = true;
  };

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  documentation.man.generateCaches = true;

  users.users.${user} = {
    shell = pkgs.fish;
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
      "podman"
      "tun"
      "input"
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
      ntfs3g
      base16-schemes
      home-manager
      polkit
      polkit_gnome
      nodejs
      efibootmgr
      pciutils
      xorg.xauth
    ];

    variables = {
      EDITOR = "lvim";
      NIRI_CONFIG = "/home/${user}/.config/niri/config.kdl";
      ALL_PROXY = "http://127.0.0.1:7890";
      HTTP_PROXY = "http://127.0.0.1:7890";
      HTTPS_PROXY = "http://127.0.0.1:7890";
      NO_PROXY = "127.0.0.1,localhost,::1,192.168.122.237,192.168.122.0/24,steampowered.com,steamcontent.com,steamgames.com,steamstatic.com,akamaihd.net,steamserver.net";
      all_proxy = "http://127.0.0.1:7890";
      http_proxy = "http://127.0.0.1:7890";
      https_proxy = "http://127.0.0.1:7890";
      no_proxy = "127.0.0.1,localhost,::1,192.168.122.237,192.168.122.0/24,steampowered.com,steamcontent.com,steamgames.com,steamstatic.com,akamaihd.net,steamserver.net";
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
    polkit-gnome-authentication-agent-1 = {
      description = "polkit-gnome-authentication-agent-1";
      wantedBy = [ "graphical-session.target" ];
      wants = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
    niri-flake-polkit.enable = false;
  };

  virtualisation = {
    libvirtd.enable = true;

    podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
    };
  };
}
