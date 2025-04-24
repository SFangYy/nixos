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
    sway-unwrapped =
      (prev.sway-unwrapped.overrideAttrs (oldAttrs: {
        src = final.fetchFromGitHub {
          owner = "dawsers";
          repo = "scroll";
          rev = "1bade4906068873259617f6f41a4ba93a3573fa3";
          hash = "sha256-QnCH98x9oRpGbikSHa68R9eqdgwWD/0p0Fai1aA7x+E=";
        };
        patches = [ ];
      })).override
        { inherit (inputs.nixpkgs-wayland.packages.${final.system}) wlroots; };
    sway = prev.sway.overrideAttrs (oldAttrs: {
      passthru.providedSessions = [ "scroll" ];
    });
  };

  inherit (inputs.niri.overlays) niri;
}
