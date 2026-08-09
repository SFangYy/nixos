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
                backupFileExtension = "backup";
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

  hosts = [
    {
      host = "inspiron";
      user = "sfangyy";
      extraOSModules = [ ./inspiron/os.nix ];
      extraHomeModules = [ ./inspiron/home.nix ];
      publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKqbqHz5O4f6nBoki57c6hekVqUiO4hvSb9k771i61YS";
    }
  ];
in
{
  flake = builtins.foldl' (x: y: x // y) { } (map mkHost hosts);
}
