{
  programs.distrobox = {
    enable = true;
    containers = {
      python-project = {
        image = "fedora:latest";
        additional_packages = "python3 python3-pip git python3-numpy python3-scipy python3-matplotlib python3-pandas";
        init_hooks = [
          "ln -sf /usr/bin/distrobox-host-exec /usr/local/bin/evince"
          "ln -sf /usr/bin/distrobox-host-exec /usr/local/bin/latexmk"
        ];
      };
    };
  };
}
