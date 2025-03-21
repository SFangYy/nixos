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
    inputs.nur.modules.homeManager.default
    inputs.stylix.homeManagerModules.stylix
    inputs.niri.homeModules.niri
    inputs.nixvim.homeManagerModules.nixvim
    inputs.agenix.homeManagerModules.default
    ../secrets/age.nix
    inputs.distrobox4nix.homeManagerModule
  ] ++ (builtins.attrValues self.homeManagerModules);
in
{
  flake =
    let
      host = "eden-inspiron";
      user = "eden";
    in
    {
      overlays = import ../overlays { inherit inputs; };

      homeManagerModules = import ../modules/home-manager;

      nixosConfigurations.${host} = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit
            inputs
            nixpkgs
            self
            host
            user
            ;
        };
        modules = [
          ./inspiron/os.nix
        ] ++ sharedOSModules;
      };

      homeConfigurations."${user}@${host}" = inputs.home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages."x86_64-linux";
        extraSpecialArgs = {
          inherit
            inputs
            self
            host
            user
            ;
          nixosVersion = "unstable";
          homeManagerVersion = "master";
        };
        modules = [
          ./inspiron/home.nix
        ] ++ sharedHomeModules;
      };
    };
}
