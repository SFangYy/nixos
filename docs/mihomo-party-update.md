# Mihomo Party 更新指南

本文档说明你仓库中的 `pkgs/mihomo-party.nix` 如何更新到上游最新版。

## 结论

- 默认情况下：需要手动更新（Nix 不会自动改你仓库里的版本号和哈希）。
- 现在仓库已提供自动化脚本：`scripts/update-mihomo-party.sh`。

## 自动更新（推荐）

在仓库根目录执行：

```bash
./scripts/update-mihomo-party.sh
```

脚本会做三件事：

1. 从 `clash-party` 仓库读取最新 tag。
2. 根据最新版本生成 `.deb` 下载地址并计算 `sha256`。
3. 自动修改 `pkgs/mihomo-party.nix` 里的 `version` 和 `sha256`。

仅查看将要改什么（不改文件）：

```bash
./scripts/update-mihomo-party.sh --dry-run
```

更新后建议验证：

```bash
git diff -- pkgs/mihomo-party.nix
nix build .#mihomo-party
```

## 手动更新

1. 查看上游最新 tag（取最大版本）：

```bash
git ls-remote --tags --refs https://github.com/mihomo-party-org/clash-party.git \
  | awk '{print $2}' \
  | sed -n 's#refs/tags/v\([0-9][0-9.]*\)$#\1#p' \
  | sort -V \
  | tail -n1
```

2. 计算新版 `sha256`：

```bash
VER="<上一步输出的版本号>"
URL="https://github.com/mihomo-party-org/mihomo-party/releases/download/v${VER}/mihomo-party-linux-${VER}-amd64.deb"
nix-prefetch-url --type sha256 "$URL"
```

3. 修改文件 `pkgs/mihomo-party.nix`：

- `version = "...";`
- `sha256 = "...";`

4. 构建验证：

```bash
nix build .#mihomo-party
```

## 常见问题

- `nix-prefetch-url` 不存在：
  说明环境没有该命令，先进入你平时的 Nix 开发环境或安装对应工具。
- 上游 tag 已更新但下载失败：
  通常是 release 资产还没同步完，等几分钟再执行。
- GitHub API 403：
  这个流程不依赖 GitHub API，使用 `git ls-remote`，可绕过 API rate limit。
