{ pkgs, ... }:
let
  switchToMacos = pkgs.writeShellScriptBin "switch-to-macos" ''
    # 参数 1: 显示器 VCP 代码 (默认 0x1b，即 USB-C)
    # 参数 2: 罗技 Solaar 设备 Easy-Switch 主机通道 (默认 2)
    VCP_CODE="''${1:-0x1b}"
    SOLAAR_HOST="''${2:-2}"

    if command -v ddcutil &>/dev/null; then
        echo "正在将所有检测到的显示器输入源切换至 $VCP_CODE ..."
        # 1. 尝试对 ddcutil detect 识别到的 Display 编号执行
        DISPS=$(${pkgs.ddcutil}/bin/ddcutil detect --brief 2>/dev/null | grep -i "^Display " | awk '{print $2}')
        if [ -n "$DISPS" ]; then
            for disp in $DISPS; do
                echo "切换 Display $disp ..."
                ${pkgs.ddcutil}/bin/ddcutil setvcp 60 "$VCP_CODE" --display "$disp" || true
            done
        fi

    else
        echo "[Warning] ddcutil 未在 PATH 中"
    fi

    if command -v solaar &>/dev/null; then
        echo "正在将罗技设备切换至 Easy-Switch 通道 $SOLAAR_HOST ..."
        # 可用 SOLAAR_DEVICE 覆盖；名称只需是设备名称的唯一子串。
        SOLAAR_DEVICE="''${SOLAAR_DEVICE:-MX Master 4}"
        if ${pkgs.coreutils}/bin/timeout 10 ${pkgs.solaar}/bin/solaar config "$SOLAAR_DEVICE" change-host "$SOLAAR_HOST" >/dev/null 2>&1; then
            echo "罗技设备 '$SOLAAR_DEVICE' 已切换至 Easy-Switch 通道 $SOLAAR_HOST。"
        else
            echo "[Error] 未能切换罗技设备 '$SOLAAR_DEVICE' 至 Easy-Switch 通道 $SOLAAR_HOST。"
            echo "请运行: solaar show"
        fi
    else
        echo "[Warning] solaar 未在 PATH 中"
    fi
  '';
in
{
  home.packages = [
    switchToMacos
    pkgs.solaar
  ];

  # Divert the MX Master 4 Haptic button and show the custom Kando menu.
  xdg.configFile."solaar/rules.yaml".text = ''
    %YAML 1.3
    ---
    - Rule:
        - Key: [Haptic, pressed]
        - Execute: ["${pkgs.kando}/bin/kando", "--menu", "My Config"]
    ...
  '';
}
