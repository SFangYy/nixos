#!/usr/bin/env bash
set -euo pipefail

# Auto-update pkgs/mihomo-party.nix to latest upstream tag.
# Usage:
#   ./scripts/update-mihomo-party.sh
#   ./scripts/update-mihomo-party.sh --dry-run

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PKG_FILE="$REPO_ROOT/pkgs/mihomo-party.nix"
TAG_REMOTE="https://github.com/mihomo-party-org/clash-party.git"

DRY_RUN="false"
if [[ "${1:-}" == "--dry-run" ]]; then
  DRY_RUN="true"
elif [[ -n "${1:-}" ]]; then
  echo "Unsupported option: $1" >&2
  echo "Usage: $0 [--dry-run]" >&2
  exit 2
fi

need_cmd() {
  command -v "$1" >/dev/null 2>&1 || {
    echo "Missing required command: $1" >&2
    exit 1
  }
}

need_cmd git
need_cmd awk
need_cmd sed
need_cmd sort
need_cmd tail
need_cmd nix-prefetch-url
need_cmd perl

if [[ ! -f "$PKG_FILE" ]]; then
  echo "Package file not found: $PKG_FILE" >&2
  exit 1
fi

current_version="$(sed -n 's/^[[:space:]]*version = "\([^"]\+\)";.*/\1/p' "$PKG_FILE" | head -n1)"
if [[ -z "$current_version" ]]; then
  echo "Could not parse current version from $PKG_FILE" >&2
  exit 1
fi

latest_version="$({
  git ls-remote --tags --refs "$TAG_REMOTE" \
    | awk '{print $2}' \
    | sed -n 's#refs/tags/v\([0-9][0-9.]*\)$#\1#p' \
    | sort -V \
    | tail -n1
} || true)"

if [[ -z "$latest_version" ]]; then
  echo "Failed to fetch latest version tag from: $TAG_REMOTE" >&2
  exit 1
fi

url="https://github.com/mihomo-party-org/mihomo-party/releases/download/v${latest_version}/mihomo-party-linux-${latest_version}-amd64.deb"

if [[ "$current_version" == "$latest_version" ]]; then
  echo "Already up-to-date: v${current_version}"
  exit 0
fi

echo "Current version : v${current_version}"
echo "Latest version  : v${latest_version}"
echo "Prefetching hash from: $url"

new_hash="$(nix-prefetch-url --type sha256 "$url")"
if [[ -z "$new_hash" ]]; then
  echo "Failed to prefetch sha256 for: $url" >&2
  exit 1
fi

if [[ "$DRY_RUN" == "true" ]]; then
  echo "[dry-run] Would set version to v${latest_version}"
  echo "[dry-run] Would set sha256 to ${new_hash}"
  exit 0
fi

perl -0i -pe 's/version = "[^"]+";/version = "'"$latest_version"'";/; s/sha256 = "[^"]+";/sha256 = "'"$new_hash"'";/' "$PKG_FILE"

echo "Updated: $PKG_FILE"
echo "  version = \"${latest_version}\""
echo "  sha256  = \"${new_hash}\""
echo

echo "Next steps:"
echo "  1) git diff -- $PKG_FILE"
echo "  2) nix build .#mihomo-party"
echo "  3) home-manager switch / nixos-rebuild switch"
