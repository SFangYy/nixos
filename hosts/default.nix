{
  inputs,
  nixpkgs,
  self,
  ...
}:
let
  sharedOSModules = [
    ../os
    ../nix
    inputs.stylix.nixosModules.stylix
    inputs.niri.nixosModules.niri
  ];

  sharedHomeModules = [
    ../home
    ../nix/nixpkgs.nix
    ../nix/substituters.nix
    inputs.stylix.homeModules.stylix
    inputs.niri.homeModules.niri
    inputs.nixvim.homeModules.nixvim
    inputs.agenix.homeManagerModules.default
    ../secrets/age.nix
    # inputs.mangowc.hmModules.mango
    inputs.dank-material-shell.homeModules.dank-material-shell
    inputs.caelestia-shell.homeManagerModules.default
    inputs.noctalia-shell.homeModules.default
  ]
  ++ (builtins.attrValues self.homeManagerModules);

  mkHost =
    {
      host,
      user,
      extraOSModules ? [ ],
      extraOSArgs ? { },
      extraHomeModules ? [ ],
      extraHomeArgs ? { },
      ...
    }:
    {
      nixosConfigurations.${host} = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit
            inputs
            nixpkgs
            self
            host
            user
            ;
        }
        // extraOSArgs;
        modules = extraOSModules ++ sharedOSModules;
      };

      homeConfigurations."${user}@${host}" = inputs.home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          system = "x86_64-linux";
          overlays = builtins.attrValues self.overlays;
          config.allowUnfree = true;
        };
        extraSpecialArgs = {
          inherit
            inputs
            self
            host
            user
            ;
        }
        // extraHomeArgs;
        modules = extraHomeModules ++ sharedHomeModules;
      };
    };

in
let
  hosts = import ./hosts.nix;
in
{
  flake = builtins.foldl' (x: y: x // y) { } (map mkHost hosts);
}
