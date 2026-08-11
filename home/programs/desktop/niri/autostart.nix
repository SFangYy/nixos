{
  pkgs,
  lib,
  user,
  config,
  ...
}:
let
  niri-autostart = pkgs.writeShellApplication {
    name = "niri-autostart";
    runtimeInputs = with pkgs; [
      niri
      awww
      wlsunset
      systemd
      killall
      waycorner
      coreutils
      findutils
      jq
      gnused
    ];
    extraShellCheckFlags = [ ];
    bashOptions = [ ];
    text =
      # bash
      ''
        awww kill || true
        # awww-daemon --namespace "background" &
        awww-daemon --namespace "backdrop" &
        awww restore --namespace "background"
        awww restore --namespace "backdrop"
        wlsunset -s 00:00 -S 00:00 -t 5000 -T 5001 &
        sleep 0.2
      ''
      + (
        builtins.attrNames config.monitors
        |> map (monitor: [
          "awww img --namespace background -o ${monitor} \"/home/${user}/Pictures/Wallpapers/generated/$(cat ~/Pictures/Wallpapers/${monitor}-file)\""
          "sleep 0.2"
          "awww img --namespace backdrop -o ${monitor} \"/home/${user}/Pictures/Wallpapers/generated/$(cat ~/Pictures/Wallpapers/${monitor}-blurred-file)\""
          "sleep 0.2"
        ])
        |> builtins.concatLists
        |> builtins.concatStringsSep "\n"
      )
      + "\n";
  };
in
{
  programs.niri.settings.spawn-at-startup = [
    { command = [ "${niri-autostart}/bin/niri-autostart" ]; }
    { command = [ "${pkgs.solaar}/bin/solaar" "--window" "hide" ]; }
    { command = [ "${pkgs.kando}/bin/kando" ]; }
  ];
}
