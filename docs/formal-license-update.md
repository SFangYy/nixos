# HimaFormal License 更新操作

## 适用场景

修改了仓库中的以下 license 文件后，HimaFormal 仍然看不到新 feature 或新的有效期：

```text
docs/IC2026_FORMAL.BOSC
```

license 由 FlexNet license server (`lmgrd` 和 vendor daemon `empyrean`) 在启动时读取。文件内容更新后，已经运行的 license server 不会自动重新读取文件，因此需要重启 license server。通常不需要重启整台机器。

## 文件路径

配置使用固定文件名 `IC2026_FORMAL.BOSC`，路径关系如下：

```text
仓库源文件：
/home/sfangyy/Documents/200-Work/220-EnvTools/nixos/docs/IC2026_FORMAL.BOSC

Home Manager 读取的文件：
/home/sfangyy/.config/nixos/docs/IC2026_FORMAL.BOSC

HimaFormal 使用的文件：
/home/sfangyy/EDAHome/HimaFormal/IC2026_FORMAL.BOSC
```

后两个路径应该最终指向仓库中的源文件。可以用下面的命令确认：

```bash
readlink -f /home/sfangyy/.config/nixos/docs/IC2026_FORMAL.BOSC
readlink -f /home/sfangyy/EDAHome/HimaFormal/IC2026_FORMAL.BOSC
```

## 标准更新流程

### 1. 更新 license 文件

把新的内容写入：

```text
docs/IC2026_FORMAL.BOSC
```

确认文件存在：

```bash
ls -l /home/sfangyy/Documents/200-Work/220-EnvTools/nixos/docs/IC2026_FORMAL.BOSC
```

### 2. 应用 NixOS 和 Home Manager 配置

在仓库根目录执行：

```bash
cd /home/sfangyy/Documents/200-Work/220-EnvTools/nixos
NH_ELEVATION_STRATEGY=sudo nh os switch --ask
```

配置激活时会创建或更新 HimaFormal 使用的软链接，并尝试重启 `formal-license-server.service`。

### 3. 手动重启 license server

为了确保正在运行的 FlexNet 进程读取新文件，建议手动执行：

```bash
systemctl --user restart formal-license-server.service
```

如果服务之前没有运行，使用：

```bash
systemctl --user start formal-license-server.service
```

注意：配置中的 `try-restart` 只会重启已经运行的服务。如果服务处于 inactive 或启动失败状态，`try-restart` 不会启动它。

### 4. 检查服务状态和日志

```bash
systemctl --user status formal-license-server.service --no-pager
tail -n 100 ~/lmgrd.log
```

正常情况下，服务状态应为 `active (running)`，日志中不应出现 license 解析错误或 vendor daemon 立即退出。

### 5. 重启 HimaFormal 客户端

已经打开的 `FormalMC` 或其他 HimaFormal 工具可能已经缓存了旧的 license 状态。重启 license server 后，关闭并重新打开相关工具：

```bash
pkill -f '/home/sfangyy/EDAHome/HimaFormal/.*/FormalMC' || true
pkill -f '/home/sfangyy/EDAHome/HimaFormal/.*/empyrean' || true
```

更稳妥的方式是先正常退出 HimaFormal 工具，再重新进入环境：

```bash
formal
```

## 一条命令完成常规重启

如果文件路径已经确认正确，并且只需要让服务读取最新 license，可以执行：

```bash
systemctl --user restart formal-license-server.service && \
systemctl --user status formal-license-server.service --no-pager
```

## 常见问题

### 修改后仍然没有生效

先确认 HimaFormal 实际使用的路径仍然是软链接，并且软链接指向当前文件：

```bash
ls -l /home/sfangyy/EDAHome/HimaFormal/IC2026_FORMAL.BOSC
readlink -f /home/sfangyy/EDAHome/HimaFormal/IC2026_FORMAL.BOSC
```

然后重启服务并重新启动 HimaFormal 客户端。只执行 `nh os switch` 不一定能让已有的 `lmgrd` 进程重新读取 license 内容。

### 服务启动失败

查看日志：

```bash
tail -n 100 ~/lmgrd.log
```

常见原因包括：

- license 文件内容无效或已过期；
- license 中的 hostid 与当前机器不匹配；
- `lmgrd` 或 `empyrean` 进程仍占用旧的端口；
- HimaFormal 安装目录中的 license server 二进制不存在；
- 用户级 systemd 服务没有启动。

确认服务定义和进程：

```bash
systemctl --user cat formal-license-server.service
pgrep -af 'lmgrd|empyrean'
```

### 环境变量未更新

进入 `formal` 环境后，确认变量指向固定 license 文件：

```bash
echo "$FORMAL_LICENSE_FILE"
echo "$LM_LICENSE_FILE"
```

两个变量都应指向：

```text
/home/sfangyy/EDAHome/HimaFormal/IC2026_FORMAL.BOSC
```

如果当前已经打开了旧的 shell 或 HimaFormal 进程，退出后重新执行 `formal`。
