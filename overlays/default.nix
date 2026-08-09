{ inputs, ... }:
{
  additions =
    final: prev:
    import ../pkgs {
      pkgs = final;
    };

  modifications = final: prev: {
    # Compatibility alias for Niri revisions that still refer to the removed
    # libdisplay-info_0_2 package attribute.
    libdisplay-info_0_2 =
      inputs.nixpkgs-stable.legacyPackages.${final.stdenv.hostPlatform.system}.libdisplay-info_0_2;
    inherit (inputs.awww.packages.${final.stdenv.hostPlatform.system}) awww;
    # fish 4.8 removed create_manpage_completions.py, which nixpkgs' generic
    # fish-completions hook still invokes for packages with man pages.
    fish = inputs.nixpkgs-stable.legacyPackages.${final.stdenv.hostPlatform.system}.fish;
  };

  inherit (inputs.niri.overlays) niri;
  nur = inputs.nur.overlays.default;
}
