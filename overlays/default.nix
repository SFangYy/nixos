{ inputs, ... }:
{
  additions =
    final: prev:
    import ../pkgs {
      pkgs = final;
    };

  modifications = final: prev: let isLinux = prev.stdenv.hostPlatform.isLinux; in {
    sway-unwrapped =
      if isLinux then
        (prev.sway-unwrapped.overrideAttrs (oldAttrs: {
          src = inputs.scroll;
          patches = [ ];
        })).override
          { inherit (inputs.nixpkgs-wayland.packages.${final.stdenv.hostPlatform.system}) wlroots; }
      else
        prev.sway-unwrapped or null;
    sway =
      if isLinux then
        prev.sway.overrideAttrs (oldAttrs: {
          passthru.providedSessions = [ "scroll" ];
        })
      else
        prev.sway or null;
    # awww = if isLinux then inputs.awww.packages.${final.stdenv.hostPlatform.system}.awww else prev.awww or null;
    libfprint =
      if isLinux then
        prev.libfprint.overrideAttrs (oldAttrs: {
          src = final.fetchFromGitLab {
            domain = "gitlab.freedesktop.org";
            owner = "libfprint";
            repo = "libfprint";
            rev = "d79f157282085738ea8ffbe8c2ae96fb8b3ad831";
            hash = "sha256-Ek5MxO+XgTeJ1wty0+WiMf1PUKJTyo/TjIgjWQV8wt8=";
          };
        })
      else
        prev.libfprint or null;
  };

  niri = final: prev: if prev.stdenv.hostPlatform.isLinux then inputs.niri.overlays.niri final prev else { };
  nur = inputs.nur.overlays.default;
}
