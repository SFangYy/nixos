{
  inputs,
  nixpkgs,
  self,
  ...
}:
let
  sharedOSModules = [
    ../overlays
    ../os
    ../nix
    inputs.stylix.nixosModules.stylix
    inputs.niri.nixosModules.niri
  ];
  sharedHomeModules = [
    ../overlays
    ../home
    ../nix/nixpkgs.nix
    ../sharedConfig.nix
    ../lib/colorScheme/buildColorScheme.nix
    ../lib/wallpaper/buildWallpaper.nix
    inputs.nur.modules.homeManager.default
    inputs.stylix.homeManagerModules.stylix
    inputs.niri.homeModules.niri
    inputs.nixvim.homeManagerModules.nixvim
    inputs.agenix.homeManagerModules.default
    ../secrets/age.nix
  ];
in
{
  flake =
    let
      host = "eden-inspiron";
      user = "eden";
    in
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
