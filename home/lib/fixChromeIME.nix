{ pkgs, ... }:
{
  config.lib.misc.fixChromeIME =
    package:
    pkgs.symlinkJoin {
      name = "${package}-wrapped";
      paths = [ pkgs.${package} ];
      buildInputs = [ pkgs.makeWrapper ];
      postBuild = ''
        wrapProgram $out/bin/${package} --add-flags "--wayland-text-input-version=3"
      '';
    };
}
