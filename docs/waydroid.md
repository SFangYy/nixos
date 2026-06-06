# Waydroid 集成方案

当前阶段只做第一步：

1. 安装并启用 Waydroid。
2. 首次初始化时使用带 Google Apps 的 Android 13 镜像。
3. 安装 `casualsnek/waydroid_script` 里的 `Install libhoudini arm translation`。

其余内容先不做。

## 现状判断

当前仓库有几个适合接入 Waydroid 的点：

* 系统配置集中在 `os/system/configuration.nix`。
* 主机配置很薄，`hosts/inspiron/os.nix` 只负责主机名和硬件导入。
* 桌面脚本通过 Home Manager 暴露到 `~/scripts`，见 `home/programs/desktop/default.nix`。
* 当前用户已经在 `adbuser`、`video`、`kvm` 等组里，这对 Waydroid/ADB 侧是有利的。

这意味着最合适的做法不是把所有内容堆进 `hosts/inspiron/os.nix`，而是新增独立模块。

## 已落地的结构

当前仓库已按下面的结构接入：

* `os/programs/waydroid.nix`
  启用 Waydroid，并安装 `waydroid`、`android-tools`、`lzip`、`python3`、`git`。
* `home/programs/desktop/waydroid.nix`
  提供两个用户命令：
  * `waydroid-init-gapps`
  * `waydroid-install-libhoudini`

导入点：

* 在 `os/programs/default.nix` 中导入 `./waydroid.nix`
* 在 `home/programs/desktop/default.nix` 中导入 `./waydroid.nix`

## 关键边界

NixOS 自带的 Waydroid 模块只有：

* `virtualisation.waydroid.enable`
* `virtualisation.waydroid.package`

它没有“声明式指定 Android 13 / GAPPS 镜像”的选项。

所以“安装 Android 13 GApps 版本”这一步不能单靠 Nix 模块完成，而是需要在系统启用后显式执行：

```bash
sudo waydroid init -s GAPPS
```

Waydroid 当前官方镜像基线本身就是 Android 13，因此这里用 `GAPPS` 初始化即可满足“Android 13 + Google Apps”的目标。

## 需要执行的命令

配置切换完成后，按下面顺序执行。

### 1. 应用配置

```bash
nh os switch
home-manager switch --flake .#sfangyy@inspiron
```

### 2. 初始化 Android 13 GApps 镜像

```bash
waydroid-init-gapps
```

这个命令会：

* 启用并启动 `waydroid-container`
* 若 Waydroid 尚未初始化，则执行 `sudo waydroid init -s GAPPS`
* 如果已初始化，则不会重复执行

如需重装成别的镜像，先手动清掉：

```bash
sudo rm -rf /var/lib/waydroid
```

然后重新运行 `waydroid-init-gapps`。

### 3. 启动 Waydroid

```bash
waydroid show-full-ui
```

### 4. 安装 `libhoudini`

```bash
waydroid-install-libhoudini
```

这个命令会：

* 在 `~/.local/share/waydroid-extra-scripts` 下拉取 `casualsnek/waydroid_script`
* 自动创建 Python venv
* 自动安装 `requirements.txt`
* 执行 `sudo venv/bin/python3 main.py install libhoudini`

## 后续项

这一步有几个明确风险：

* `libhoudini` 不是 Nix 声明式配置，而是对 Waydroid 镜像做后处理。
* 首次运行 `waydroid-install-libhoudini` 需要联网拉取 GitHub 仓库和 Python 依赖。
* 如果你的当前内核缺少 binder/binderfs，Waydroid 会在服务启动阶段失败，这不是脚本问题。

建议先验证：

```bash
systemctl status waydroid-container
waydroid status
```

## 风险点

后续如果这一步稳定，再继续补：

* `microg`
* `magisk`
* `nodataperm`
* 统一的 `waydroid-log` / `waydroid-shell` / `waydroid-extras`
