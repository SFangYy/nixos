{
  pkgs,
  config,
  user,
  ...
}:
{
  imports = [
    ./boot.nix
  ];

  networking = {
    networkmanager.enable = true;
    proxy = {
      default = "http://127.0.0.1:7890";
      httpProxy = "http://127.0.0.1:7890";
      httpsProxy = "http://127.0.0.1:7890";
      noProxy = "localhost,internal.domain";
    };
  };

  time = {
    timeZone = "Asia/Shanghai";
    hardwareClockInLocalTime = true;
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
        fcitx5-mozc
        fcitx5-gtk
        fcitx5-chinese-addons
        fcitx5-rime
      ];
      fcitx5.waylandFrontend = true;
    };
  };

  services = {
    xserver = {
      enable = true;

      displayManager.gdm.enable = false;
      desktopManager.gnome.enable = true;
      desktopManager.runXdgAutostartIfNone = true;

      xkb.layout = "us";
      xkb.variant = "";
    };

    displayManager.sessionPackages = [ pkgs.hyprland ];

    greetd = {
      enable = true;
      vt = 3;
      settings.default_session = {
        command = # bash
          let
            inherit (config.services.displayManager.sessionData) desktops;
          in
          # bash
          ''
            ${pkgs.greetd.tuigreet}/bin/tuigreet --time \
              --sessions ${desktops}/share/xsessions:${desktops}/share/wayland-sessions \
              --remember --remember-user-session --asterisks --cmd niri-session \
              --user-menu --greeting "Who TF Are You?" --window-padding 2'';
        user = "greeter";
      };
    };

    fprintd = {
      enable = true;
    };

    printing.enable = true;

    flatpak.enable = true;

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    blueman.enable = true;

    gnome.gnome-browser-connector.enable = true;

    gvfs.enable = true;
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
      "docker"
      "libvirtd"
      "video"
    ];
    packages = with pkgs; [
      nautilus
      loupe
      podman-compose
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
      distrobox
      ntfs3g
      base16-schemes
      home-manager
      polkit
      polkit_gnome
    ];

    variables = {
      EDITOR = "lvim";
      GDK_SCALE = "";
      GDK_DPI_SCALE = "";
      NIRI_CONFIG = "/home/${user}/.config/niri/config-override.kdl";
    };

    sessionVariables = {
      XMODIFIERS = "@im=fcitx";
      SDL_IM_MODULE = "fcitx";
      GLFW_IM_MODULE = "ibus";
      QT_SCALE_FACTOR_ROUNDING_POLICY = "round";
      GSK_RENDERER = "vulkan";
      NIXOS_OZONE_WL = "1";
    };

    localBinInPath = true;
  };

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
      defaultNetwork.settings.dns_enabled = true;
    };

    docker = {
      enable = true;
      storageDriver = "btrfs";
      rootless = {
        enable = true;
        setSocketVariable = true;
      };
    };
  };
}
