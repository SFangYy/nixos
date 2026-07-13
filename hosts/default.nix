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
    inputs.home-manager.nixosModules.home-manager
  ];

  sharedHomeModules = [
    ../home
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
        modules =
          extraOSModules
          ++ sharedOSModules
          ++ [
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                extraSpecialArgs = {
                  inherit
                    inputs
                    nixpkgs
                    self
                    host
                    user
                    ;
                }
                // extraHomeArgs;
                sharedModules = sharedHomeModules;
                users.${user} = {
                  imports = extraHomeModules;
                };
              };
            }
          ];
      };

    };

in
let
  hosts = import ./hosts.nix;
in
{
  flake = builtins.foldl' (x: y: x // y) { } (map mkHost hosts);
}
