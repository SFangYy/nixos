{
  pkgs,
  ...
}:
{
  stylix = {
    enable = true;
    autoEnable = false;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/everforest.yaml";
    targets = {
      console.enable = true;
      gnome.enable = true;
      grub.enable = true;
      plymouth.enable = true;
    };
  };
}
