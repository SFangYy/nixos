{
  #NOTE: 不使用调试器，想提升加载速度就去plugins文件下的defAult.nix注释点dap。能加快加载速度
  imports = [
    ./dap.nix
    ./dap-ui.nix
    ./languages
  ];
}
