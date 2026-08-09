{ pkgs, ... }: {
  home.username = "fy"; # 请在此处修改为你的 macOS 用户名
  home.homeDirectory = "/Users/fy"; # 请在此处修改为你的 macOS 用户名
  home.stateVersion = "23.11";

  imports = [
    ../../home/programs/shell/fish.nix
    ../../home/programs/shell/starship.nix
    ../../home/programs/terminal/tmux.nix
    ../../home/programs/coding/nixvim
  ];

  stylix = {
    enable = true;
    autoEnable = false;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/everforest.yaml";
    polarity = "dark";
    targets.nixvim.enable = true;
    targets.starship.enable = false;
    fonts = {
      monospace = {
        name = "JetBrainsMono Nerd Font";
        package = pkgs.nerd-fonts.jetbrains-mono;
      };
      sansSerif = {
        name = "JetBrainsMono Nerd Font";
        package = pkgs.nerd-fonts.jetbrains-mono;
      };
      serif = {
        name = "JetBrainsMono Nerd Font";
        package = pkgs.nerd-fonts.jetbrains-mono;
      };
      emoji = {
        name = "Noto Color Emoji";
        package = pkgs.noto-fonts-color-emoji;
      };
    };
  };

  fonts.fontconfig.enable = true;

  # 解决 macOS 默认开启 zsh 的问题：进入交互式 zsh 时自动跳转到 fish
  programs.zsh = {
    enable = true;
    profileExtra = ''
      # Added by OrbStack: command-line tools and integration
      source ~/.orbstack/shell/init.zsh 2>/dev/null || :
    '';
    initContent = ''
      if [[ -z "$DISPLAY" ]]; then
        launchd_display="$(/bin/launchctl getenv DISPLAY 2>/dev/null)"
        if [[ -n "$launchd_display" ]]; then
          export DISPLAY="$launchd_display"
        elif [[ -x /opt/X11/bin/Xquartz ]]; then
          export DISPLAY=:0
        fi
      fi

      if [[ $- == *i* ]] && [[ -x "$HOME/.nix-profile/bin/fish" && -z "$IN_FISH" ]]; then
        export IN_FISH=1
        exec "$HOME/.nix-profile/bin/fish" -l
      fi
    '';
  };

  # macOS 额外需要的包
  home.packages = with pkgs; [
    eza
    zoxide
    pay-respects
    nerd-fonts.jetbrains-mono
    nerd-fonts.symbols-only
  ];

  # 启用 yazi 终端文件管理器及 shell 集成
  programs.yazi = {
    enable = true;
    enableFishIntegration = true;
    enableZshIntegration = true;
    shellWrapperName = "y";
  };

  programs.home-manager.enable = true;
}
