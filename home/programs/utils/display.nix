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

        # 2. 对 AUX / DP / i2c 总线（例如 i2c-12, i2c-13, i2c-14）进行补漏切换，确保双显示器都能切到
        for bus in 12 13 14; do
            if [ -e "/dev/i2c-$bus" ]; then
                echo "尝试对 I2C 总线 /dev/i2c-$bus 发送切换指令..."
                ${pkgs.ddcutil}/bin/ddcutil setvcp 60 "$VCP_CODE" --bus "$bus" --force-slave-address 2>/dev/null || true
            fi
        done
    else
        echo "[Warning] ddcutil 未在 PATH 中"
    fi

    if command -v solaar &>/dev/null; then
        echo "正在将罗技设备切换至 Easy-Switch 通道 $SOLAAR_HOST ..."
        # 使用 timeout 2 防止无设备连接时阻塞卡住
        ${pkgs.coreutils}/bin/timeout 2 ${pkgs.solaar}/bin/solaar config mouse change-host "$SOLAAR_HOST" &>/dev/null || \
        ${pkgs.coreutils}/bin/timeout 2 ${pkgs.solaar}/bin/solaar config "MX Master 3S" &>/dev/null || \
        ${pkgs.coreutils}/bin/timeout 2 ${pkgs.solaar}/bin/solaar config 1 change-host "$SOLAAR_HOST" &>/dev/null || true
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
}
