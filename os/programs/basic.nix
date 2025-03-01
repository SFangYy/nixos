{
  programs = {
    fish.enable = true;
    adb.enable = true;
    light.enable = true;
    wshowkeys.enable = true;
    nix-ld.enable = true;
    virt-manager.enable = true;
    git = {
      enable = true;
      config = {
        http = {
          proxy = "http://127.0.0.1:7890";
        };
        https = {
          proxy = "http://127.0.0.1:7890";
        };
        safe = {
          directory = "*";
        };
      };
    };
  };
}
