# 指南：在 NixOS 上运行 PiliPlus AppImage

在 NixOS 上运行 AppImage 有时会比较复杂，因为 NixOS 独特的系统设计，它不遵循大多数 Linux 应用程序所期望的传统文件系统层次结构标准（FHS）。

`PiliPlus_linux_2.0.1+4775_amd64.AppImage` 这个程序需要在 NixOS 上满足两个条件才能正确运行：
1.  一个名为 `appimage-run` 的包装工具，用于创建一个兼容的运行环境。
2.  一系列该 AppImage 缺失但又是必需的依赖库，这些库需要由 Nix 系统提供。

本文档总结了解决此问题的必要步骤，并提供了一个可重用的解决方案。

## 所需的依赖项

经过一系列的排查，我们发现需要通过 Nix 安装以下软件包来满足此应用程序的全部依赖：

*   `appimage-run`
*   `mpv`
*   `libepoxy`
*   `libayatana-appindicator`
*   `libayatana-indicator`
*   `ayatana-ido`
*   `libdbusmenu`

## 一次性运行命令

如果您只想临时运行一次该程序，可以在终端中执行以下完整命令。此命令会临时下载所有必需的软件包，并设置正确的库文件路径，以便应用程序能够找到它们。

```bash
nix-shell -p appimage-run mpv libepoxy libayatana-appindicator libayatana-indicator ayatana-ido libdbusmenu --run '
  export LD_LIBRARY_PATH=$(nix-build --no-out-link "<nixpkgs>" -A mpv)/lib:$(nix-build --no-out-link "<nixpkgs>" -A libepoxy)/lib:$(nix-build --no-out-link "<nixpkgs>" -A libayatana-appindicator)/lib:$(nix-build --no-out-link "<nixpkgs>" -A libayatana-indicator)/lib:$(nix-build --no-out-link "<nixpkgs>" -A ayatana-ido)/lib:$(nix-build --no-out-link "<nixpkgs>" -A libdbusmenu)/lib:$LD_LIBRARY_PATH;
  appimage-run ./PiliPlus_linux_2.0.1+4775_amd64.AppImage
'
```

## 推荐方案：创建可重用的启动脚本

由于上述命令非常长且复杂，最好的方法是将其保存到一个脚本文件中，方便将来轻松运行。

1.  **创建一个文件**，命名为 `run-piliplus.sh`，并将以下内容粘贴进去：

    ```sh
    #!/usr/bin/env bash

    # 这是一个在 NixOS 上启动 PiliPlus AppImage 的脚本。
    # 它假设 AppImage 文件与此脚本位于同一目录下。

    # 使用 nix-shell 启动一个包含所有依赖的临时环境来运行程序
    nix-shell -p appimage-run mpv libepoxy libayatana-appindicator libayatana-indicator ayatana-ido libdbusmenu --run '
      # 手动设置 LD_LIBRARY_PATH，强制链接器在 Nix store 中查找所有必需的库
      export LD_LIBRARY_PATH=$(nix-build --no-out-link "<nixpkgs>" -A mpv)/lib:$(nix-build --no-out-link "<nixpkgs>" -A libepoxy)/lib:$(nix-build --no-out-link "<nixpkgs>" -A libayatana-appindicator)/lib:$(nix-build --no-out-link "<nixpkgs>" -A libayatana-indicator)/lib:$(nix-build --no-out-link "<nixpkgs>" -A ayatana-ido)/lib:$(nix-build --no-out-link "<nixpkgs>" -A libdbusmenu)/lib:$LD_LIBRARY_PATH;
      
      # 使用 appimage-run 启动 AppImage
      appimage-run ./PiliPlus_linux_2.0.1+4775_amd64.AppImage
    '
    ```

2.  **让脚本文件可执行**：
    在终端中运行以下命令：
    ```bash
    chmod +x run-piliplus.sh
    ```

3.  **运行程序**：
    现在，您只需要运行这个脚本即可启动 PiliPlus：
    ```bash
    ./run-piliplus.sh
    ```
