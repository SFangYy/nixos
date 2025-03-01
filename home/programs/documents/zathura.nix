{
  config,
  pkgs,
  ...
}:
{
  xdg.configFile."zathura/stylix".text = ''
    set default-fg                "#${config.lib.stylix.colors.base05}"
    set default-bg                "#${config.lib.stylix.colors.base00}"

    set completion-bg             "#${config.lib.stylix.colors.base02}"
    set completion-fg             "#${config.lib.stylix.colors.base05}"
    set completion-highlight-bg   "#${config.lib.stylix.colors.base01}"
    set completion-highlight-fg   "#${config.lib.stylix.colors.base05}"
    set completion-group-bg       "#${config.lib.stylix.colors.base02}"
    set completion-group-fg       "#${config.lib.stylix.colors.base0D}"

    set statusbar-fg              "#${config.lib.stylix.colors.base05}"
    set statusbar-bg              "#${config.lib.stylix.colors.base02}"

    set notification-bg           "#${config.lib.stylix.colors.base02}"
    set notification-fg           "#${config.lib.stylix.colors.base05}"
    set notification-error-bg     "#${config.lib.stylix.colors.base02}"
    set notification-error-fg     "#${config.lib.stylix.colors.base08}"
    set notification-warning-bg   "#${config.lib.stylix.colors.base02}"
    set notification-warning-fg   "#${config.lib.stylix.colors.base0A}"

    set inputbar-fg               "#${config.lib.stylix.colors.base05}"
    set inputbar-bg               "#${config.lib.stylix.colors.base02}"

    set recolor-lightcolor        "#${config.lib.stylix.colors.base00}"
    set recolor-darkcolor         "#${config.lib.stylix.colors.base05}"

    set index-fg                  "#${config.lib.stylix.colors.base05}"
    set index-bg                  "#${config.lib.stylix.colors.base00}"
    set index-active-fg           "#${config.lib.stylix.colors.base05}"
    set index-active-bg           "#${config.lib.stylix.colors.base02}"

    set render-loading-bg         "#${config.lib.stylix.colors.base00}"
    set render-loading-fg         "#${config.lib.stylix.colors.base05}"

    set highlight-color           "#${config.lib.stylix.colors.base01}"
    set highlight-fg              "#${config.lib.stylix.colors.base0E}"
    set highlight-active-color    "#${config.lib.stylix.colors.base0E}"
  '';
  programs.zathura = {
    enable = true;
    package = pkgs.zathura;
    extraConfig = ''
      include stylix

      set selection-clipboard clipboard

      set recolor true

      set font 'Comic Code'
    '';
  };
}
