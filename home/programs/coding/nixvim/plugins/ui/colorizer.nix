{
  programs.nixvim = {
    plugins.colorizer.enable = true;
    plugins.colorizer.settings = {
      user_default_options = {
        mode = "virtualtext";
        css = true;
        css_fn = true;
        names = false;
        virtualtext = "■";
        virtualtext_inline = true;
        virtualtext_mode = "foreground";
      };
    };
  };
}
