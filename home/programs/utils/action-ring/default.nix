{
  pkgs,
  lib,
  config,
  ...
}:
let
  kando = import ./kando.nix { inherit pkgs; };
  switchToMacos = import ./switch-to-macos.nix { inherit pkgs; };
  mouseSwitch = import ./switch-mouse-host.nix { inherit pkgs; };
  actions = pkgs.writeShellApplication {
    name = "action-ring-action";
    runtimeInputs = with pkgs; [
      config.programs.niri.package
      switchToMacos
      obsidian
      kitty
      grim
      slurp
      satty
      wl-clipboard
      wireplumber
      coreutils
    ];
    # Use the same compositor CLI as the configured Niri package.
    text = builtins.readFile ./actions.sh;
  };
in
{
  home.packages = [
    pkgs.solaar
    kando
    actions
  ];

  home.file = {
    ".local/bin/kando".source = "${kando}/bin/kando";
    ".local/bin/action-ring-action".source = "${actions}/bin/action-ring-action";
    ".local/bin/switch-to-macos".source = "${switchToMacos}/bin/switch-to-macos";
    ".local/bin/switch-mouse-host".source = "${mouseSwitch}/bin/switch-mouse-host";
  };
  systemd.user.services = {
    kando = {
      Unit = {
        Description = "Kando Action Ring";
        After = [ "graphical-session.target" ];
        PartOf = [ "graphical-session.target" ];
      };
      Service = {
        ExecStart = "${kando}/bin/kando";
        Restart = "on-failure";
        RestartSec = 2;
      };
      Install.WantedBy = [ "graphical-session.target" ];
    };
    solaar = {
      Unit = {
        Description = "Logitech Action Ring input";
        After = [
          "graphical-session.target"
          "kando.service"
        ];
        PartOf = [ "graphical-session.target" ];
      };
      Service = {
        ExecStart = "${pkgs.solaar}/bin/solaar --window hide";
        Restart = "on-failure";
        RestartSec = 2;
      };
      Install.WantedBy = [ "graphical-session.target" ];
    };
  };

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
