set -euo pipefail
case "${1:-}" in
  switch-macos) exec switch-to-macos ;;
  switch-status) exec kitty --hold switch-to-macos --status ;;
  obsidian) exec obsidian "obsidian://open?vault=EIOTO" ;;
  daily-note) exec obsidian-cli vault=EIOTO daily ;;
  terminal) exec kitty ;;
  overview) exec niri msg action toggle-overview ;;
  fullscreen) exec niri msg action fullscreen-window ;;
  floating) exec niri msg action toggle-window-floating ;;
  focus-left) exec niri msg action focus-column-or-monitor-left ;;
  focus-right) exec niri msg action focus-column-or-monitor-right ;;
  workspace-up) exec niri msg action focus-workspace-up ;;
  workspace-down) exec niri msg action focus-workspace-down ;;
  screenshot)
    geometry=$(slurp) || exit 0
    [[ -n $geometry ]] || exit 0
    shot_file=$(mktemp --suffix=.png)
    trap 'rm -f "$shot_file"' EXIT
    grim -g "$geometry" "$shot_file"
    wl-copy < "$shot_file"
    satty --filename "$shot_file"
    ;;
  audio-mute) exec wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle ;;
  mic-mute) exec wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle ;;
  volume-up) exec wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 0.05+ ;;
  volume-down) exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.05- ;;
  *) echo "Unknown Action Ring action: ${1:-}" >&2; exit 2 ;;
esac
