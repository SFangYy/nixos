{ inputs, ... }:
{
  additions =
    final: prev:
    import ../pkgs {
      pkgs = final;
    };

  modifications = final: prev: {
    base16-schemes = prev.base16-schemes.overrideAttrs (oldAttrs: {
      installPhase = ''
        runHook preInstall

        mkdir -p $out/share/themes/
        install base16/*.yaml $out/share/themes/
        install ${final.custom-colorschemes}/share/themes/*.yaml $out/share/themes/

        runHook postInstall
      '';
    });
    inherit (inputs.nixpkgs-wayland.packages.${final.stdenv.hostPlatform.system}) swww;
  };

  inherit (inputs.niri.overlays) niri;
  nur = inputs.nur.overlays.default;
}
