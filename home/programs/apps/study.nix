{
  pkgs,
  inputs,
  lib,
  ...
}:
{
  home.packages = with pkgs; [
    obsidian
    brave
    vscode
    inputs.antigravity-flake.packages.${pkgs.stdenv.hostPlatform.system}.antigravity-fhs
  ];

  home.activation.antigravitySettingsBootstrap = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    AG_SETTINGS="$HOME/.config/Antigravity/User/settings.json"
    mkdir -p "$(dirname "$AG_SETTINGS")"

    if [ ! -e "$AG_SETTINGS" ] || [ -L "$AG_SETTINGS" ]; then
      rm -f "$AG_SETTINGS"
      cat > "$AG_SETTINGS" <<'EOF'
    {
      "workbench.colorTheme": "Tokyo Night",
      "http.proxy": "http://127.0.0.1:7890",
      "http.proxyStrictSSL": false,
      "http.proxySupport": "on"
    }
    EOF
      chmod 644 "$AG_SETTINGS"
    fi
  '';

  xdg.configFile."Code/User/keybindings.json".text = ''
    [
      {
        "key": "alt+c",
        "command": "workbench.action.terminal.sendSequence",
        "args": { "text": "\u0003" },
        "when": "terminalFocus"
      },
      {
        "key": "ctrl+c",
        "command": "workbench.action.terminal.copySelection",
        "when": "terminalFocus && terminalTextSelected"
      },
      {
        "key": "ctrl+v",
        "command": "workbench.action.terminal.paste",
        "when": "terminalFocus"
      }
    ]
  '';
}
