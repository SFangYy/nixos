# Arguments remain compatible with switch-to-macos [VCP] [host].
set -euo pipefail
mode=all
dry_run=false
case "${1:-}" in
  --help|-h)
    echo 'Usage: switch-to-macos [--dry-run|--mouse-only|--display-only|--status] [VCP=0x1b] [host=2]'
    echo 'SOLAAR_DEVICE overrides the device name; SOLAAR_TIMEOUT defaults to 30 seconds.'
    exit 0
    ;;
  --dry-run) dry_run=true; shift ;;
  --mouse-only) mode=mouse; shift ;;
  --display-only) mode=display; shift ;;
  --status) exec solaar config "${SOLAAR_DEVICE:-MX Master 4}" change-host ;;
esac
vcp=${1:-0x1b}
host=${2:-2}
device=${SOLAAR_DEVICE:-MX Master 4}
if [[ $# -gt 2 || ! $vcp =~ ^(0[xX][[:xdigit:]]+|[0-9]+)$ || ! $host =~ ^[123]$ ]]; then
  echo 'Invalid arguments. Use --help; Easy-Switch hosts are numbered 1, 2, 3.' >&2
  exit 2
fi
if $dry_run; then
  printf '1. solaar config %q change-host %q (timeout %ss)\n' "$device" "$host" "${SOLAAR_TIMEOUT:-30}"
  printf '2. ddcutil setvcp 60 %q for each detected display I2C bus\n' "$vcp"
  exit 0
fi
state_dir=${XDG_STATE_HOME:-$HOME/.local/state}/action-ring
mkdir -p "$state_dir"
exec 9>"${XDG_RUNTIME_DIR:-$state_dir}/action-ring-switch.lock"
flock -n 9 || { echo 'A device switch is already running.' >&2; exit 1; }
log_file=$state_dir/switch-to-macos.log
exec > >(tee -a "$log_file") 2>&1
printf '\n[%s] mode=%s device=%s host=%s vcp=%s\n' "$(date --iso-8601=seconds)" "$mode" "$device" "$host" "$vcp"
fail() {
  echo "[Error] $*"
  notify-send -u critical '设备切换失败' "$*\n日志：$log_file" || true
  exit 1
}

# Discover first and keep bus identities: switching one monitor can renumber
# the remaining Display indices. Never hide discovery or write errors.
buses=()
if [[ $mode != mouse ]]; then
  if ! displays=$(ddcutil detect --brief 2>&1); then
    echo "$displays"
    fail '无法检测显示器；未执行切换。'
  fi
  echo "$displays"
  mapfile -t buses < <(printf '%s\n' "$displays" | awk '
    /^Display [0-9]+/ { valid=1 }
    /^Invalid display/ { valid=0 }
    valid && /I2C bus:/ { sub(/.*\/dev\/i2c-/, ""); if ($0 ~ /^[0-9]+[[:space:]]*$/) print $1 }
  ')
  [[ ${#buses[@]} -gt 0 ]] || fail '没有检测到可切换的显示器；未执行切换。'
fi

# Send the host change while the source computer still owns all displays.
# CHANGE_HOST has no reply: success means the command was sent, not that the
# destination computer accepted the Bluetooth connection.
if [[ $mode != display ]]; then
  echo "Sending Easy-Switch host $host to $device ..."
  if timeout "${SOLAAR_TIMEOUT:-30}" solaar config "$device" change-host "$host"; then
    echo "鼠标切换命令已发送至通道 $host。"
  else
    status=$?
    fail "鼠标切换失败（退出码 $status）；显示器未切换。可用 --display-only 单独切屏。"
  fi
fi

failed=0
for bus in "${buses[@]}"; do
  echo "Switching I2C bus $bus input to $vcp ..."
  if ! ddcutil setvcp 60 "$vcp" --bus "$bus"; then
    failed=$((failed + 1))
  fi
done
[[ $failed -eq 0 ]] || fail "$failed 台显示器切换失败；详见日志。"
notify-send '设备切换' '切换命令已执行。若 Mac 未连接鼠标，请检查 Mac 蓝牙；底部按钮通道 1 可返回 NixOS。' || true
