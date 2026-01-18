{
  config,
  user,
  inputs,
  pkgs,
  lib,
  ...
}:
{
  programs.noctalia-shell = {
    colors = with config.lib.stylix.colors.withHashtag; {
      mError = base08;
      mOnError = base00;
      mOnPrimary = base00;
      mOnSecondary = base01;
      mOnSurface = base05;
      mOnSurfaceVariant = base07;
      mOnTeritiary = base00;
      mOutline = base02;
      mPrimary = base0B;
      mSecondary = base0A;
      mShadow = "#000000";
      mSurface = base01;
      mSurfaceVariant = base01;
      mTeritiary = base0C;
    };
    settings = {
      setupCompleted = true;
      bar = {
        density = "comfortable";
        floating = true;
        showCapsule = true;
        outerCorners = true;
        position = "left";
        showOutline = true;
        widgets = {
          center = [
            {
              id = "SystemMonitor";
              showCpuTemp = true;
              showCpuUsage = true;
              showDiskUsage = false;
              showMemoryAsPercent = false;
              showMemoryUsage = true;
              showNetworkoStats = false;
              usePrimaryColor = true;
            }
            {
              id = "Clock";
              formatHorizontal = "HH:mm ddd, MMM dd";
              formatVertical = "HH mm - dd MMM";
            }
          ];
          left = [
            {
              id = "Launcher";
            }
            {
              id = "Workspace";
              labelMode = "none";
              hideUnoccupied = false;
            }
            {
              id = "MediaMini";
              autoHide = true;
              scrollingMode = "hover";
              showAlbumArt = true;
              showVisualizer = true;
              visualizerType = "wave";
            }
            {
              id = "ActiveWindow";
            }
          ];
          right = [
            {
              id = "Tray";
              drawerEnabled = false;
              colorizeIcons = true;
              blacklist = [ ];
            }
            {
              id = "Volume";
              displayMode = "onhover";
            }
            {
              id = "Battery";
              displayMode = "alwaysShow";
              warningThreshold = 30;
            }
            {
              id = "ControlCenter";
              customIconPath = "";
              icon = "";
              useDistroLogo = false;
            }
          ];
        };
      };
      appLauncher = {
        enableClipboardHistory = true;
        autoPasteClipboard = true;
        enableClipPreview = true;
        clipboardWrapText = true;
        position = "top_left";
    };
      colorSchemes = {
        generateTemplatesForPredefined = false;
        useWallpaperColors = false;
      };
      general = {
        avatarImage = "/home/${user}/.face";
        forceBlackScreenCorners = true;
        showScreenCorners = true;
      };
        appLauncher = {
        };
        controlCenter = {
          cards = [
            {
              enabled = false;
              id = "brightness-card";
            }
            {
              enabled = true;
              id = "weather-card";
            }
            {
              enabled = true;
              id = "media-sysmon-card";
            }
            {
              enabled = true;
              id = "audio-card";
            }
            {
              enabled = true;
              id = "shortcuts-card";
            }
            {
              enabled = true;
              id = "profile-card";
            }
          ];
        };
        sessionMenu = {
          position = "bottom_left";
        };
      location = {
        name = "海淀";
      };
      ui = {
        fontDefault = "JetBrains Mono";
        fontFixed = "JetBrains Mono";
        panelBackgroundOpacity = 0.9;
      };
      dock.enabled = false;
      wallpaper.enabled = false;
      desktopWidgets = {
        editMode = false;
        enabled = true;
        monitorWidgets = [
          {
            name = config.lib.monitors.mainMonitorName;
            widgets = [
              {
                id = "Clock";
                showBackground = true;
                x = 80;
                y = 100;
              }
              {
                id = "Weather";
                showBackground = true;
                x = 80;
                y = 300;
              }
            ];
          }
        ];
      };
    };
  };

  systemd.user.services = lib.mkIf (config.desktopShell == "noctalia-shell") {
    noctalia-shell =
      let
        noctaliaPackage = inputs.noctalia-shell.packages.${pkgs.stdenv.hostPlatform.system}.default;
        noctaliaConfig = "/home/${user}/.config/noctalia/gui-settings.json";
      in
      {
        Unit = {
          After = [ "graphical-session.target" ];
          PartOf = [ "graphical-session.target" ];
          StartLimitIntervalSec = 60;
          StartLimitBurst = 3;
          X-Restart-Triggers = [
            noctaliaPackage
            noctaliaConfig
          ];
        };
        Install.WantedBy = [ "graphical-session.target" ];
        Service = {
          ExecStart = "${noctaliaPackage}/bin/noctalia-shell";
          Restart = "on-failure";
          RestartSec = 3;
          TimeoutStartSec = 10;
          TimeoutStopSec = 5;
          Environment = [
            "NOCTALIA_SETTINGS_FALLBACK=${noctaliaConfig}"
          ];
        };
      };
  };
}
