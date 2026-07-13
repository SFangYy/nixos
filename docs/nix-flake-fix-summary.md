# Nix Flake 问题修复总结

## 问题

运行 `nh os switch --ask` 时遇到两个错误：

1. **flake.lock JSON 语法错误** - Git 合并冲突标记残留在文件中
2. **GitHub API 限流** - HTTP 403 错误，无法更新 flake inputs

## 解决步骤

### 1. 恢复 flake.lock

合并冲突导致 `flake.lock` 损坏，引用了不存在的节点 `caelestia-cli`：

```bash
git checkout HEAD -- flake.lock
```

### 2. 配置 GitHub Token 绕过 API 限流

从 `secrets/github-token.age` 解密 token：

```bash
nix-shell -p age --run "age -d -i ~/.ssh/id_rsa secrets/github-token.age"
```

使用环境变量临时配置：

```bash
export NIX_CONFIG="access-tokens = github.com=<TOKEN>"
nix flake lock
```

### 3. 更新 flake.lock

成功更新后，新增/更新了多个 inputs：
- `awww` - 新增
- `caelestia-shell` - 新增
- `dank-material-shell` - 替换 `dankMaterialShell`
- `kimi-cli` - 新增
- `niri-unstable` - 更新
- `nixvim` - 更新
- `nixpkgs-stable` - 更新

## 后续建议

### 永久配置 GitHub Token

在 home-manager 配置中添加：

```nix
nix.settings.access-tokens = "github.com=<TOKEN>";
```

或者将 token 存储在 `~/.config/nix/nix.extra.conf`（需要手动管理，不通过 home-manager）。

### 提交更改

```bash
git add flake.lock
git commit -m "fix: resolve flake.lock conflicts and update inputs"
```
