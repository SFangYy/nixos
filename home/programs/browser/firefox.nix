{ pkgs, inputs, ... }:
let
in
# firefox-gnome-theme = builtins.fetchGit {
#   url = "https://github.com/rafaelmardojai/firefox-gnome-theme.git";
#   rev = "a89108e6272426f4eddd93ba17d0ea101c34fb21";
# };
{
  programs.firefox = {
    enable = true;
    profiles.default = {
      isDefault = true;
      # userChrome = ''
      #   @import "${firefox-gnome-theme}/userChrome.css";
      #   @import "${firefox-gnome-theme}/theme/colors/dark.css";
      #   /* Hide Tab bar with only one Tab - [110] */
      #   #tabbrowser-tabs .tabbrowser-tab:only-of-type,
      #   #tabbrowser-tabs
      #     .tabbrowser-tab:only-of-type
      #     + #tabbrowser-arrowscrollbox-periphery {
      #     display: none !important;
      #   }
      #   #tabbrowser-tabs,
      #   #tabbrowser-arrowscrollbox {
      #     min-height: 0 !important;
      #   }
      #   /* #TabsToolbar:not(:hover) */
      #   #alltabs-button {
      #     display: none !important;
      #   }
      # '';
      settings = {
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "browser.tabs.drawInTitlebar" = true;
        "svg.context-properties.content.enabled" = true;
      };
    };
  };
  stylix.targets.firefox.enable = true;
  stylix.targets.firefox.firefoxGnomeTheme.enable = true;
  stylix.targets.firefox.profileNames = [ "default" ];
}
