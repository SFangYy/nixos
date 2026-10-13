{
  pkgs,
  lib,
  config,
  ...
}:
let
  kando = import ./kando.nix { inherit pkgs; };
  actions = pkgs.writeShellApplication {
    name = "action-ring-action";
    runtimeInputs = with pkgs; [
      niri
      obsidian
      kitty
      grim
      slurp
      satty
      wl-clipboard
      wireplumber
      coreutils
    ];
    text = builtins.readFile ./actions.sh;
  };
in
{
  home.packages = [
    pkgs.solaar
    kando
    actions
  ];

  programs.niri.settings.spawn-at-startup = [
    {
      command = [
        "${pkgs.solaar}/bin/solaar"
        "--window"
        "hide"
      ];
    }
    { command = [ "${kando}/bin/kando" ]; }
  ];

  # Kando draws a monitor-sized transparent window and positions the pie
  # relative to its top-left corner. Niri's floating placement must agree.
  programs.niri.settings.window-rules = [
    {
      matches = [ { title = "^Kando Menu$"; } ];
      open-floating = true;
      default-floating-position = {
        x = 0;
        y = 0;
        relative-to = "top-left";
      };
      focus-ring.enable = false;
      border.enable = false;
      shadow.enable = false;
    }
  ];

  xdg.configFile."solaar/rules.yaml".text = ''
    %YAML 1.3
    ---
    - Rule:
        - Key: [Haptic, pressed]
        - Execute: ["${kando}/bin/kando", "--menu", "My Config"]
    ...
  '';

  # Keep Kando's file writable; update only My Config, preserving other menus
  # and backing up GUI edits before applying the declarative menu.
  home.activation.actionRingMenu = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    run ${pkgs.python3}/bin/python3 ${./merge-menu.py} \
      ${./menu.json} ${lib.escapeShellArg "${config.xdg.configHome}/kando/menus.json"} \
      --actions ${actions}/bin/action-ring-action
  '';
}
