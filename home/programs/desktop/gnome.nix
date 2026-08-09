{ pkgs, ... }:
{
  home.packages = with pkgs.gnomeExtensions; [
    user-themes
    kimpanel
  ];
  dconf.settings = {
    "org/gnome/shell" = {
      disable-user-extensions = false;
      enabled-extensions = [
        "user-theme@gnome-shell-extensions.gcampax.github.com"
        "kimpanel@kde.org"
      ];
    };
    "org/gnome/desktop/wm/keybindings" = {
      "close" = [ "<Super>q" ];
    };
    "org/gnome/settings-daemon.plugins.media-keys" = {
      custom-keybindings = [
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
      ];
    };
  };
}
