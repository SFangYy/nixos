# EDA 共享用户

`os/system/eda.nix` 创建普通用户 `eda`，使用 Bash 登录，工作目录为 `/home/eda/work`。
`ue` 是系统级 FHS 环境：交互使用 `ue`，脚本使用 `ue bash script.sh`。
共享 `eda` 账户不安装 Picker，也跳过 UCAgent 准备，只提供 VCS/Verdi/UVMC。
如需 Python 环境，可在 `ue` 内运行 `ue-setup-python` 自行创建（默认位于 `$HOME/work/.venv`，可用 `UE_PYTHON_ENV` 覆盖）。

## 安装

先在仓库根目录执行 `sudo nixos-rebuild switch --flake .#inspiron`。
VCS、Verdi、UVMC 从主用户的 `~/EDAHome` 只读挂载到 `/opt/eda`，无需复制约 31 GiB 文件，
也不需要开放主用户的 home 目录。源目录需保留。

```bash
sudo bash os/system/provision-eda.sh
sudo passwd eda
sudo -iu eda
ue
```

部署脚本只校验共享挂载和 `ue` 环境，不复制任何文件。

## 检查

```bash
sudo -iu eda -- ue bash /absolute/path/to/nixos/os/system/check-eda-env.sh
```

如果配置仓库位于私人 home 内，把检查脚本复制到 eda 可读位置后再运行。

VCS/Verdi 版本默认 `W-2024.09-SP1`，可用 `VCS_HOME`、`VERDI_HOME` 覆盖。
`UE_EDA_ROOT` 和 `UE_PYTHON_ENV` 可分别覆盖 EDA 根目录和虚拟环境路径。
`PICKER_REQUIRED=1` 可在 eda 账户内临时启用主用户的 Picker 路径。

## License 和图形界面

在 `/etc/eda/license.sh` 中填写实际授权的 `SNPSLMD_LICENSE_FILE` / `LM_LICENSE_FILE`，
或通过登录环境传入；不要将 license 内容或密码写进仓库/Nix store。
当前配置不启动 Synopsys license 服务。VCS 完整仿真还需要可用授权。

远程 Verdi 使用 `ssh -Y eda@hostname` 后进入 `ue`；客户端需有 X Server。
当前系统已启用 SSH X11 forwarding，工具通过 XCB 运行。

## 本次验证

共享 UE 和完整 NixOS 配置均成功构建；仓库 9 项测试通过。
VCS license 和 Verdi GUI 尚未运行验证。

## HimaFormal（统一使用 UE）

原独立 `formal` FHS 环境已移除，HimaFormal 与 VCS/Verdi 共用 `ue`，
Picker 和 Verilator 均使用 UE 的版本，不再引用 `~/work/test/formal_picker`。

```bash
ue
FormalMC -help
ave -f your-script.tcl
hima-lmutil lmstat -c "$HOME/EDAHome/HimaFormal/IC2026_FORMAL.BOSC"
```

`FormalMC` 和 `ave` 均通过包装脚本启动 HimaFormal；`hima-lmutil` 是它专用的许可证查询工具。
仅这些子进程设置 formal 的 `LM_LICENSE_FILE`、`LM_TMP_DIR` 和 OpenSSL 1.0 库路径，
不会在 UE shell 中覆盖 VCS/Verdi 的许可证或动态库变量，也不把 HimaFormal 的整个 `bin` 加入公共 PATH。
旧 OpenSSL 的 `.so.10` 兼容链接保存在 Nix store 内，不再在用户目录中创建。

默认客户端安装位置为 `~/EDAHome/HimaFormal`，许可证为其中的 `IC2026_FORMAL.BOSC`。
包装脚本支持 `AVIS_HOME` 和 `FORMAL_LICENSE_FILE` 覆盖；供应商启动脚本自身也必须对应实际安装位置。
没有安装 HimaFormal 的账户仍可使用 UE 的其他工具。
用户级 `formal-license-server.service` 和许可证软链接管理继续保留，详见 [许可证维护](formal-license-update.md)。
系统切换后退出旧环境，重新进入 `ue`；不要从旧 `formal` shell 嵌套进入。
