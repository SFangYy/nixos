{
  description = "Minimal Home Manager Flake for macOS";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      nixvim,
      ...
    }:
    let
      system = "aarch64-darwin"; # Apple Silicon 使用 aarch64-darwin, Intel 使用 x86_64-darwin
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      homeConfigurations."yourname" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          nixvim.homeManagerModules.nixvim
          ./macos-home.nix
        ];
        extraSpecialArgs = { inherit self; };
      };
    };
}
