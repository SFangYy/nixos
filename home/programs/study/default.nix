{ pkgs, inputs, ... }:
{
  home.packages = with pkgs; [
    # pspp
    zotero
    obsidian
    brave
    vscode
    inputs.antigravity-nix.packages.x86_64-linux.google-antigravity-no-fhs
  ];

  # Antigravity proxy configuration
  xdg.configFile."Antigravity/User/settings.json".text = builtins.toJSON {
    "workbench.colorTheme" = "Tokyo Night";
    "http.proxy" = "http://127.0.0.1:7890";
    "http.proxyStrictSSL" = false;
    "http.proxySupport" = "on";
  };

  # VSCode keybindings configuration
  xdg.configFile."Code/User/keybindings.json".text = ''
    [
      {
        "key": "alt+c",
        "command": "workbench.action.terminal.sendSequence",
        "args": {
          "text": "\u0003"
        },
        "when": "terminalFocus"
      }
,
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
