{
  description = "Eden's NixOS Flake";

  outputs =
    {
      self,
      nixpkgs,
      ...
    }@inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-darwin"
      ];
      imports = [
        ./hosts
        inputs.treefmt-nix.flakeModule
        { _module.args = { inherit inputs self nixpkgs; }; }
        {
          options.flake.homeConfigurations = inputs.nixpkgs.lib.mkOption {
            type = inputs.nixpkgs.lib.types.attrsOf inputs.nixpkgs.lib.types.raw;
            default = { };
          };
        }
      ];
      flake = {
        homeManagerModules = import ./modules/home-manager;
        overlays = import ./overlays { inherit inputs self; };
        templates = import ./templates;
        homeConfigurations."fy" = inputs.home-manager.lib.homeManagerConfiguration {
          pkgs = import inputs.nixpkgs {
            system = "aarch64-darwin";
            overlays = builtins.attrValues self.overlays;
            config.allowUnfree = true;
          };
          modules = [
            inputs.stylix.homeModules.stylix
            inputs.nixvim.homeModules.nixvim
            ./macos-home.nix
          ];
          extraSpecialArgs = {
            inherit self inputs;
            user = "fy";
            host = "macos";
          };
        };
      };
      perSystem =
        { pkgs, ... }:
        {
          packages = import ./pkgs { inherit pkgs; };
          treefmt = {
            projectRootFile = "flake.nix";
            programs.nixfmt.enable = true;
            programs.ruff-format.enable = true;
            programs.prettier.enable = true;
            programs.beautysh.enable = true;
            programs.toml-sort.enable = true;
            settings.global.excludes = [ "*.age" ];
            settings.formatter = {
              jsonc = {
                command = "${pkgs.nodePackages.prettier}/bin/prettier";
                includes = [ "*.jsonc" ];
              };
              scripts = {
                command = "${pkgs.beautysh}/bin/beautysh";
                includes = [ "*/scripts/*" ];
              };
            };
          };
        };
    };

  inputs = {
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable-small";
    nixpkgs-r.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-new-libinput.url = "github:skowalak/nixpkgs/libinput-update-1.31.0";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-parts.url = "github:hercules-ci/flake-parts";
    niri-unstable = {
      # url = "github:JustinSpedding/niri/up-down-keybinds";
      # url = "github:Atan-D-RP4/niri/feat/layer-anims";
      url = "github:niri-wm/niri";
      flake = false;
    };
    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.niri-unstable.follows = "niri-unstable";
    };
    nur.url = "github:nix-community/NUR";
    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim.url = "github:nix-community/nixvim/nixos-25.11";
    nil = {
      url = "github:oxalica/nil";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixd = {
      url = "github:nix-community/nixd";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nh.url = "github:nix-community/nh";
    treefmt-nix.url = "github:numtide/treefmt-nix";
    agenix.url = "github:ryantm/agenix";
    nixpkgs-wayland.url = "github:nix-community/nixpkgs-wayland";
    quickshell = {
      url = "git+https://git.outfoxxed.me/quickshell/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dank-material-shell.url = "github:AvengeMedia/DankMaterialShell";
    caelestia-shell = {
      url = "github:caelestia-dots/shell";
      inputs.quickshell.follows = "quickshell";
    };
    noctalia-shell = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hexecute.url = "github:ThatOtherAndrew/Hexecute";
    antigravity-flake = {
      url = "github:Hy4ri/antigravity-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    kimi-cli.url = "github:MoonshotAI/kimi-cli";
    awww.url = "git+https://codeberg.org/LGFae/awww";
    waydeeper.url = "github:EdenQwQ/waydeeper";
  };
}
