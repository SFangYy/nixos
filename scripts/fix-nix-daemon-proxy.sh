#!/usr/bin/env bash
set -euo pipefail

# 修复 Nix daemon 使用失效代理端口导致的 cache.nixos.org TLS 错误。
# 该脚本需要在宿主机终端执行，并由 sudo 提供 root 权限。

proxy_url="${NIX_DAEMON_PROXY:-http://127.0.0.1:7890}"
dropin_dir="/run/systemd/system/nix-daemon.service.d"
dropin_file="$dropin_dir/proxy.conf"

if [[ "${EUID}" -ne 0 ]]; then
  echo "请使用 sudo 执行：sudo $0" >&2
  exit 1
fi

command -v systemctl >/dev/null || {
  echo "找不到 systemctl。" >&2
  exit 1
}

mkdir -p "$dropin_dir"
cat > "$dropin_file" <<EOF
[Service]
Environment=HTTP_PROXY=$proxy_url
Environment=HTTPS_PROXY=$proxy_url
Environment=http_proxy=$proxy_url
Environment=https_proxy=$proxy_url
EOF

systemctl daemon-reload
systemctl restart nix-daemon

effective_env="$(systemctl show nix-daemon -p Environment --value)"
if [[ "$effective_env" != *"HTTPS_PROXY=$proxy_url"* ]]; then
  echo "Nix daemon 未加载预期代理：$proxy_url" >&2
  echo "$effective_env" >&2
  exit 1
fi

echo "Nix daemon 代理已设置为：$proxy_url"
echo "当前服务环境："
systemctl show nix-daemon -p Environment --value | tr ' ' '\n' | grep -E '^(HTTP|HTTPS|http|https)_PROXY=' || true
echo
echo "现在可以重试：nh os switch"
