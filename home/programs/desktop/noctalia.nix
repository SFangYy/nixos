{
  config,
  user,
  ...
}:
{
  programs.noctalia = {
    systemd.enable = true;
    customPalettes.stylix.dark = with config.lib.stylix.colors.withHashtag; {
      mPrimary = base0D;
      mOnPrimary = base00;
      mSecondary = base0E;
      mOnSecondary = base00;
      mTertiary = base0C;
      mOnTertiary = base00;
      mError = base08;
      mOnError = base00;
      mSurface = base00;
      mOnSurface = base05;
      mHover = base0C;
      mOnHover = base00;
      mSurfaceVariant = base01;
      mOnSurfaceVariant = base04;
      mOutline = base03;
      mShadow = base00;

      terminal = {
        foreground = base05;
        background = base00;
        cursor = base05;
        cursorText = base00;
        selectionFg = base05;
        selectionBg = base02;
        normal = {
          black = base00;
          red = base08;
          green = base0B;
          yellow = base0A;
          blue = base0D;
          magenta = base0E;
          cyan = base0C;
          white = base05;
        };
        bright = {
          black = base03;
          red = base08;
          green = base0B;
          yellow = base0A;
          blue = base0D;
          magenta = base0E;
          cyan = base0C;
          white = base07;
        };
      };
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
              colorizeIcons = false;
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
        fontDefault = "Hug Me Tight";
        fontFixed = "Maple Mono";
        panelBackgroundOpacity = 0.85;
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
    validateConfig = false;
  };
}
