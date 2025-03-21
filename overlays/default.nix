{ inputs, ... }:
{
  additions =
    final: prev:
    import ../pkgs {
      pkgs = final;
    };

  modifications = final: prev: {
    qutebrowser = prev.qutebrowser.override { enableWideVine = true; };
    base16-schemes = prev.base16-schemes.overrideAttrs (oldAttrs: {
      installPhase = ''
        runHook preInstall

        mkdir -p $out/share/themes/
        install base16/*.yaml $out/share/themes/
        install ${final.custom-colorschemes}/share/themes/*.yaml $out/share/themes/

        runHook postInstall
      '';
    });
  };

  inherit (inputs.niri.overlays) niri;
}
