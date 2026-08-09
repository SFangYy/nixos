{ inputs, ... }:
{
  additions =
    final: prev:
    import ../pkgs {
      pkgs = final;
    };

  modifications =
    final: prev:
    let
      isLinux = prev.stdenv.hostPlatform.isLinux;
    in
    {
      # Compatibility alias for Niri revisions that still refer to the removed
      # libdisplay-info_0_2 package attribute.
      libdisplay-info_0_2 =
        if isLinux then
          inputs.nixpkgs-stable.legacyPackages.${final.stdenv.hostPlatform.system}.libdisplay-info_0_2 or null
        else
          null;
      # fish 4.8 removed create_manpage_completions.py, which nixpkgs' generic
      # fish-completions hook still invokes for packages with man pages.
      fish = inputs.nixpkgs-stable.legacyPackages.${final.stdenv.hostPlatform.system}.fish;
    }
    // (prev.lib.optionalAttrs isLinux {
      inherit (inputs.awww.packages.${final.stdenv.hostPlatform.system}) awww;
    });

  niri = final: prev: if prev.stdenv.hostPlatform.isLinux then inputs.niri.overlays.niri final prev else { };
  nur = inputs.nur.overlays.default;
}
