{ pkgs }:
let
  nodeAddonApi = pkgs.fetchurl {
    url = "https://registry.npmjs.org/node-addon-api/-/node-addon-api-8.5.0.tgz";
    hash = "sha256-0S8HyBYig7YhNVGFXx2o2sFiMxN0YpgwteZA8TDweRA=";
  };
  nativeAddon = pkgs.stdenv.mkDerivation {
    pname = "kando-wlr-pointer-fixed";
    inherit (pkgs.kando) version src;
    patches = [ ./kando-pointer-enter.patch ];
    nativeBuildInputs = [ pkgs.wayland-scanner ];
    buildInputs = [
      pkgs.wayland
      pkgs.libxkbcommon
    ];
    dontConfigure = true;
    buildPhase = ''
      runHook preBuild
      mkdir addon-headers
      tar -xf ${nodeAddonApi} --strip-components=1 -C addon-headers
      addonHeaders="$PWD/addon-headers"
      cd src/main/backends/linux/wlroots/native
      for protocol in protocols/*.xml; do
        name="$(basename "$protocol" .xml)"
        wayland-scanner client-header "$protocol" "$name.h"
        wayland-scanner private-code "$protocol" "$name.c"
        $CC -fPIC -c "$name.c" -o "$name.o"
      done
      $CXX -std=c++20 -shared -fPIC -O2 -DNAPI_VERSION=8 \
        -I"$addonHeaders" -I${pkgs.nodejs}/include/node \
        Native.cpp ./*.o -o NativeWLR.node
      runHook postBuild
    '';
    installPhase = ''
      install -Dm755 NativeWLR.node $out/lib/NativeWLR.node
    '';
  };
  patchedKando =
    pkgs.runCommand "kando-pointer-fixed-${pkgs.kando.version}"
      {
        meta = pkgs.kando.meta;
        passthru = { inherit nativeAddon; };
      }
      ''
            mkdir -p $out/bin
        cp -rs ${pkgs.kando}/share $out/share
        # Store directories are read-only; make only the cloned directories
        # writable, without following their symlinked files into the store.
        find $out/share -type d -exec chmod u+w {} +
        # Node resolves symlinked entrypoints to their original directory. Keep
        # this entrypoint local so its native_modules path uses the fixed addon.
        unlink $out/share/kando/resources/app/.webpack/main/index.js
        cp ${pkgs.kando}/share/kando/resources/app/.webpack/main/index.js \
          $out/share/kando/resources/app/.webpack/main/index.js
        unlink $out/share/kando/resources/app/.webpack/main/native_modules/NativeWLR.node
            ln -s ${nativeAddon}/lib/NativeWLR.node \
              $out/share/kando/resources/app/.webpack/main/native_modules/NativeWLR.node
            substitute ${pkgs.kando}/bin/kando $out/bin/kando \
              --replace-fail ${pkgs.kando}/share/kando $out/share/kando
            chmod +x $out/bin/kando
      '';
in
# Apply only to the source version whose pointer-enter race was verified.
if pkgs.kando.version == "3.0.0" then patchedKando else pkgs.kando
