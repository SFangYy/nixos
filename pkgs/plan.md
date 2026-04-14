# Tenda AX300 (AIC8800DC) Wi-Fi 驱动 — NixOS 安装指南

## 已完成的工作

### 创建/修改的文件

| 文件 | 作用 |
|---|---|
| `pkgs/aic8800/default.nix` | 内核模块 + 固件的 Nix derivation，基于 [社区修补版源码](https://github.com/Kiborgik/aic8800dc-linux-patched) |
| `pkgs/aic8800/fix-kernel-7.0.patch` | 修复 `in_irq()` → `in_hardirq()` 的内核 7.0 兼容性补丁 |
| `os/system/hardware-aic8800.nix` | NixOS 模块：注册内核模块、固件、udev 规则 |
| `os/system/default.nix` | 增加了 `hardware-aic8800.nix` 的 import |

### 构建与部署

- ✅ `nix build` 编译通过（含补丁）
- ✅ `sudo nixos-rebuild switch` 部署成功
- ⚠️ **需要重启系统** 才能加载新的内核模块

---

## 接下来的步骤

### 第 1 步：拔出网卡

先把 Tenda AX300 从 USB 口拔出来。

### 第 2 步：重启系统

```bash
sudo reboot
```

> **重要**: 必须重启！内核模块只在启动时从新的 generation 加载，`switch` 不会热加载新编译的 `.ko` 模块。

### 第 3 步：重启后插入网卡

重启完成、登录桌面后，**插入 Tenda AX300 网卡**。

udev 会自动完成以下流程：
1. 检测到 USB 设备 `a69c:5721`（虚拟光驱模式）
2. 自动执行 `eject` 弹出虚拟光驱
3. 设备切换到 Wi-Fi 模式（Product ID 会变化）
4. 内核自动加载 `aic_load_fw` + `aic8800_fdrv` 模块

### 第 4 步：验证驱动加载

```bash
# 检查模块是否加载
lsmod | grep aic

# 预期输出类似：
# aic8800_fdrv          xxxxx  0
# aic_load_fw           xxxxx  0

# 检查是否出现新的 Wi-Fi 网络接口
ip link show

# 查看内核日志（确认驱动初始化）
sudo dmesg | grep -i aic | tail -20
```

### 第 5 步：连接 Wi-Fi

```bash
# 扫描 Wi-Fi 网络
nmcli device wifi list

# 连接到指定网络
nmcli device wifi connect "你的WiFi名称" password "你的密码"
```

或者直接在桌面环境的 **NetworkManager** 托盘图标中选择 Wi-Fi 网络连接。

---

## 故障排查

### 如果模块没有自动加载

手动加载模块：
```bash
sudo modprobe aic_load_fw
sudo modprobe aic8800_fdrv
```

### 如果设备卡在虚拟光驱模式

手动弹出：
```bash
# 查找设备
ls -la /dev/aicudisk

# 手动弹出
sudo eject /dev/aicudisk
```

### 如果看不到 Wi-Fi 接口

检查固件是否正确安装：
```bash
# 检查固件路径
find /run/current-system -name "aic8800DC" -type d

# 检查模块是否可用
modinfo aic8800_fdrv
modinfo aic_load_fw
```

### 如果内核升级后编译失败

社区修补版支持 kernel 6.2 ~ 6.18+，我们的补丁额外支持了 7.0。如果将来内核升级导致编译失败，可能需要在 `pkgs/aic8800/fix-kernel-7.0.patch` 中添加更多修复，或更新社区源码的 commit hash。
