{ pkgs, ... }:
let
  switchToNixos = pkgs.writeShellScriptBin "switch-to-nixos" ''
    # 参数 1: 显示器 DP VCP 代码 (默认 15 即 0x0f / DisplayPort 1, 某些显示器为 16 即 0x10)
    DP_VCP="''${1:-15}"

    # 查找 m1ddc 命令路径 (优先使用 PATH 中的，其次寻找 Homebrew 路径)
    M1DDC=""
    if command -v m1ddc &>/dev/null; then
      M1DDC="$(command -v m1ddc)"
    elif [ -x "/opt/homebrew/bin/m1ddc" ]; then
      M1DDC="/opt/homebrew/bin/m1ddc"
    elif [ -x "/usr/local/bin/m1ddc" ]; then
      M1DDC="/usr/local/bin/m1ddc"
    fi

    if [ -z "$M1DDC" ]; then
      echo "[错误] 未找到 m1ddc 工具，请先在 macOS 终端运行: brew install m1ddc"
      exit 1
    fi
    echo "==> 获取已连接显示器列表..."
    if ! DISPLAY_LIST=$("$M1DDC" display list 2>&1); then
      echo "[错误] m1ddc 无法获取显示器列表:"
      printf '%s\n' "$DISPLAY_LIST"
      exit 1
    fi
    printf '%s\n' "$DISPLAY_LIST"

    # m1ddc 的列表格式为 `[1] Display Name (UUID)`。使用稳定 UUID 而非数字索引：
    # 第一台屏切走后会从 macOS 列表消失，数字索引随之重排，导致第二台无法命中。
    DISPS=$(printf '%s\n' "$DISPLAY_LIST" | sed -nE 's/^\[[0-9]+\].*\(([[:xdigit:]-]{36})\)$/\1/p')
    if [ -z "$DISPS" ]; then
      # 兼容无 UUID 的旧版输出。倒序切换可避免前面的索引在显示器消失后改变。
      DISPS=$(printf '%s\n' "$DISPLAY_LIST" | sed -nE 's/^\[([0-9]+)\].*$/\1/p; s/^([0-9]+):.*$/\1/p' | sort -rn)
    fi
    if [ -z "$DISPS" ]; then
      echo "[错误] 未从 m1ddc 输出中识别到外接显示器。"
      exit 1
    fi

    echo "==> 正在将所有外接显示器输入源切换至 DP (VCP: $DP_VCP)..."
    SUCCESS=0
    FAILED=0
    for d in $DISPS; do
      echo "  - 切换显示器 $d 输入源至 DP ($DP_VCP) ..."
      if OUTPUT=$("$M1DDC" display "$d" set input "$DP_VCP" 2>&1); then
        SUCCESS=$((SUCCESS + 1))
      else
        FAILED=$((FAILED + 1))
        echo "    [警告] 切换失败: $OUTPUT"
      fi
    done

    if [ "$FAILED" -gt 0 ]; then
      echo "[错误] 已成功切换 $SUCCESS 台，失败 $FAILED 台。"
      exit 1
    fi
    echo "==> 已成功切换 $SUCCESS 台外接显示器至 NixOS (DP)！"
  '';
in
{
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
    targets.nixvim.enable = false;
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
    switchToNixos
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
