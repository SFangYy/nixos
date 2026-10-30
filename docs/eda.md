# EDA 共享用户

`os/system/eda.nix` 创建普通用户 `eda`，使用 Bash 登录，工作目录为 `/home/eda/work`。
`ue` 是系统级 FHS 环境：交互使用 `ue`，脚本使用 `ue bash script.sh`。
默认 Python 3.12 虚拟环境位于 `$HOME/work/.venv`，与 Picker/CMake 使用同一 ABI；可用 `UE_PYTHON_ENV` 覆盖。UCAgent 使用同一 Python 3.12 ABI，不再默认创建 Python 3.13 环境。

## 安装

先在仓库根目录执行 `sudo nixos-rebuild switch --flake .#inspiron`。
VCS、Verdi、UVMC 从主用户的 `~/EDAHome` 只读挂载到 `/opt/eda`，无需复制约 31 GiB 文件，
也不需要开放主用户的 home 目录。源目录需保留。

准备包含 `pytoffee`、`toffee-test` 和全部依赖的 Python 3.12 wheels 后执行：

```bash
sudo bash os/system/provision-eda.sh /tmp/eda-wheels sfangyy
sudo passwd eda
sudo -iu eda
ue
```

部署脚本只复制本机已安装 Picker 的二进制、模板、头文件、C++ 库与 xspcomm Python 绑定，
不复制个人配置或其他 Python 包。共享安装归 root 所有；Python 虚拟环境归 eda 所有。
再次执行部署前，请确认源 Picker 和 xspcomm 为匹配版本且使用 Python 3.12。

`ue-setup-python` 优先从 `/opt/eda/wheels` 离线安装；没有该目录时才通过包索引安装。
也可显式传入本地 wheel 或源码路径。重新进入 ue 后激活虚拟环境。

## 检查

```bash
sudo -iu eda -- ue bash /absolute/path/to/nixos/os/system/check-eda-env.sh
```

如果配置仓库位于私人 home 内，把检查脚本复制到 eda 可读位置后再运行。
Picker 的 Python/C++ 支持应成功；未安装的 Go/Java/Lua/Scala 绑定不影响 Python 验证。

VCS/Verdi 版本默认 `W-2024.09-SP1`，可用 `VCS_HOME`、`VERDI_HOME` 覆盖。
`UE_EDA_ROOT`、`PICKER_PREFIX` 和 `UE_PYTHON_ENV` 可分别覆盖 EDA 根目录、Picker 安装前缀和虚拟环境。

## License 和图形界面

在 `/etc/eda/license.sh` 中填写实际授权的 `SNPSLMD_LICENSE_FILE` / `LM_LICENSE_FILE`，
或通过登录环境传入；不要将 license 内容或密码写进仓库/Nix store。
当前配置不启动 license 服务。VCS 完整仿真还需要可用授权。

远程 Verdi 使用 `ssh -Y eda@hostname` 后进入 `ue`；客户端需有 X Server。
当前系统已启用 SSH X11 forwarding，工具通过 XCB 运行。

## 本次验证

共享 UE 和完整 NixOS 配置均成功构建；仓库 9 项测试通过。
独立 Python 3.12 环境成功导入 Toffee、toffee-test、xspcomm。
Picker 加法器已导出、编译并运行通过；VCS license 和 Verdi GUI 尚未运行验证。
