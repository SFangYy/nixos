#NOTE: Go 调试器
# 如不需要直接在 ../dap/default.nix中注释即可。未来需要再打开注释
{pkgs, ...}: {
  programs.nixvim = {
    plugins.dap-go.enable = true;
    extraPackages = [
      pkgs.delve
    ];
  };
}
