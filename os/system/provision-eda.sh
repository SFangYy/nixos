#!/usr/bin/env bash
# Run as root after nixos-rebuild switch. No files are moved out of the owner account.
# The shared account gets plain VCS/Verdi/UVMC through the read-only /opt/eda
# mounts; Picker and its Python bindings are no longer installed for it.
set -euo pipefail
if [[ $EUID -ne 0 ]]; then
    echo "Run with sudo: sudo bash $0" >&2
    exit 1
fi
getent passwd eda >/dev/null
[[ -x /run/current-system/sw/bin/ue ]]
for tool in vcs verdi uvmc; do
    mountpoint -q "/opt/eda/$tool" || { echo "Missing shared mount: /opt/eda/$tool" >&2; exit 1; }
done
runuser -l eda -c 'ue bash -c '\''command -v vcs; command -v verdi'\'''
echo 'EDA setup complete. Set login access with sudo passwd eda, or install an authorized SSH key.'
