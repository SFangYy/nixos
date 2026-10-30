#!/usr/bin/env bash
# Run as root after nixos-rebuild switch. No files are moved out of the owner account.
set -euo pipefail
if [[ $EUID -ne 0 ]]; then
    echo "Run with sudo: sudo bash $0 /path/to/wheels [source-user]" >&2
    exit 1
fi
wheels="${1:?Pass the prepared wheel directory}"
source_user="${2:-${SUDO_USER:-}}"
[[ -n "$source_user" && "$source_user" != root ]] || { echo "Specify source-user" >&2; exit 1; }
source_home=$(getent passwd "$source_user" | cut -d: -f6)
[[ -n "$source_home" ]] || { echo "Unknown source-user: $source_user" >&2; exit 1; }
getent passwd eda >/dev/null
[[ -x /run/current-system/sw/bin/ue ]]
for tool in vcs verdi uvmc; do
    mountpoint -q "/opt/eda/$tool" || { echo "Missing shared mount: /opt/eda/$tool" >&2; exit 1; }
done
prefix="$source_home/.local"
[[ -x "$prefix/bin/picker" && -d "$prefix/share/picker/python/xspcomm" ]]
shopt -s nullglob
wheel_files=("$wheels"/*.whl)
[[ ${#wheel_files[@]} -gt 0 ]] || { echo "No wheels in $wheels" >&2; exit 1; }
install -d -m 0755 /opt/eda/picker/bin /opt/eda/picker/share/picker/python /opt/eda/wheels
install -m 0755 "$prefix/bin/picker" /opt/eda/picker/bin/picker
for part in template include lib; do
    install -d -m 0755 "/opt/eda/picker/share/picker/$part"
    cp -a "$prefix/share/picker/$part/." "/opt/eda/picker/share/picker/$part/"
done
cp -a "$prefix/share/picker/python/xspcomm" /opt/eda/picker/share/picker/python/
cp -a "${wheel_files[@]}" /opt/eda/wheels/
chown -R root:root /opt/eda/picker /opt/eda/wheels
chmod -R a+rX,go-w /opt/eda/picker /opt/eda/wheels
runuser -l eda -c 'ue env UV_OFFLINE=1 ue-setup-python'
runuser -l eda -c 'ue bash -c '\''picker --version; picker --check; python3 -c "import toffee, toffee_test, xspcomm; print(\"EDA Python imports OK\")"'\'''
echo 'EDA setup complete. Set login access with sudo passwd eda, or install an authorized SSH key.'
