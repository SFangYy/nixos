# NixOS 启动版本回退问题修复记录 (2026-06-17)

## 问题描述

系统在执行 `nixos-rebuild switch` 之后能生成新版本，但重启后会自动回退到 6 月 15 日的版本（Generation 103/104），无法默认进入最新生成的版本。

## 已完成的更改

### 1. 修复 EFI 变量写入权限

- **文件**: `os/system/boot.nix`
- **更改**: 将 `boot.loader.efi.canTouchEfiVariables` 设置为 `true`。
- **状态**: 已验证，重启后能正确进入最新 Generation。

### 2. 优化启动项管理工具

- **文件**: `os/system/configuration.nix`
- **更改**: 添加了 `efibootmgr` 和 `pciutils` 到系统软件包中。
- **原因**: 便于后续清理冗余 EFI 启动项和查看硬件状态。

### 3. 系统引导界面优化

- **文件**: `os/system/boot.nix`
- **更改**:
  - 设置 `consoleMode = "max"` 以获得更好的分辨率。
  - 设置 `editor = false` 以增加安全性，防止在引导界面修改内核参数。

## 待执行的操作

### 1. 应用最新优化

执行以下命令应用配置：

```bash
nh os switch
```

### 2. 清理冗余 EFI 启动项 (手动)

通过 `sudo efibootmgr` 查看，发现大量重复的 `Linux Boot Manager`。可以执行以下命令删除明显冗余的项（请谨慎，确保保留当前 BootCurrent 对应的项）：

```bash
# 查看当前正在使用的项
sudo efibootmgr | grep "BootCurrent"
# 删除不再需要的项 (例如 0019)
# sudo efibootmgr -b 0019 -B
```

### 3. 彻底转向 Flake

- 备份旧配置：`sudo mv /etc/nixos /etc/nixos.bak`
- 创建新的引导文件：
  ```bash
  sudo mkdir /etc/nixos
  # 可以放置一个简单的 flake.nix 指向你的开发目录，或者保持为空
  ```
