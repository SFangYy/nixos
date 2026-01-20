{ pkgs, inputs, ... }:
{
  home.packages = with pkgs; [
    # pspp
    zotero
    obsidian
    brave
    vscode
    inputs.antigravity-nix.packages.x86_64-linux.default
  ];

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
