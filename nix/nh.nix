{
  self,
  host,
  user,
  pkgs,
  inputs,
  ...
}:
{
  programs.nh = {
    enable = true;
    package = inputs.nh.packages.${pkgs.stdenv.hostPlatform.system}.nh;
    clean = {
      enable = true;
      dates = "daily";
      extraArgs =
        let
          numColorschemes =
            if self ? nixosConfigurations && self.nixosConfigurations ? ${host} then
              builtins.length self.nixosConfigurations.${host}.config.home-manager.users.${user}.colorSchemes
            else if self ? homeConfigurations && self.homeConfigurations ? "${user}@${host}" then
              builtins.length self.homeConfigurations."${user}@${host}".config.colorSchemes
            else if self ? homeConfigurations && self.homeConfigurations ? ${user} then
              builtins.length self.homeConfigurations.${user}.config.colorSchemes
            else
              1;
          numToKeep = toString (numColorschemes * 2);
        in
        "--keep ${numToKeep}";
    };
  };
  environment.variables.NH_FLAKE = "/home/${user}/.config/nixos";
  environment.sessionVariables.NH_ELEVATION_STRATEGY = "sudo";
}
