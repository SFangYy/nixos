#NOTE: 不需要的调试器在这里注释掉即可，未来需要时再打开
#NOTE: 鬼知道有多少人会使用调试器，不知道花费这么大劲有什么用
#NOTE: 这里的js、ts调试器是我的编写的配置，好不好用不知道，反正能用。需要使用的也肯定是懂自己需要调试配置的，不必担心。
{
  imports = [
    ./dap-go.nix # go
    ./dap-lldb.nix # c,cpp,rust
    ./dap-python.nix # python
    ./dap-js.nix # js,ts
  ];
}
