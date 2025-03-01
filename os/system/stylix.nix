{
  self,
  lib,
  host,
  user,
  ...
}:
let
  cfg = self.homeConfigurations."${user}@${host}".config;
in
{
  stylix = {
    enable = true;
    base16Scheme = lib.mkDefault cfg.stylix.base16Scheme;
    autoEnable = false;
    targets = {
      console.enable = true;
      gnome.enable = true;
      grub.enable = true;
      plymouth.enable = true;
    };
  };
  specialisation = builtins.mapAttrs (name: value: {
    configuration = {
      stylix.base16Scheme = lib.mkForce cfg.specialisation.${name}.configuration.stylix.base16Scheme;
      environment.etc."specialisation".text = name;
    };
  }) cfg.specialisation;
}
