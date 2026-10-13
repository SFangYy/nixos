{ pkgs }:
pkgs.writeShellApplication {
  name = "switch-mouse-host";
  runtimeInputs = [ pkgs.python3 ];
  text = ''
    export GI_TYPELIB_PATH=${
      pkgs.lib.escapeShellArg (
        pkgs.lib.makeSearchPathOutput "lib" "lib/girepository-1.0" (
          with pkgs;
          [
            gtk3
            glib
            pango
            gdk-pixbuf
            at-spi2-core
            harfbuzz
            gobject-introspection
          ]
        )
      )
    }
    export PYTHONPATH=${
      pkgs.lib.escapeShellArg (
        # Propagated inputs may explicitly select dev; Python lives in .out.
        pkgs.lib.makeSearchPath pkgs.python3.sitePackages (
          map (p: p.out or p) (
            [ pkgs.solaar ] ++ pkgs.python3.pkgs.requiredPythonModules pkgs.solaar.propagatedBuildInputs
          )
        )
      )
    }
    exec python3 ${./switch-mouse-host.py} "$@"
  '';
}
