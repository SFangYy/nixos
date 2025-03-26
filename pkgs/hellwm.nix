{
  stdenv,
  lua,
  libdrm,
  pixman,
  wayland,
  libinput,
  pkg-config,
  wlroots_0_18,
  libxkbcommon,
  wayland-scanner,
  wayland-protocols,
  lib,
  fetchFromGitHub,
}:
stdenv.mkDerivation {
  pname = "hellwm";
  version = "0.0.1";

  src = lib.cleanSource (fetchFromGitHub {
    owner = "EdenQwQ";
    repo = "hellwm";
    rev = "c84f13f6167af6625038d7effcb7494d53cf1856";
    hash = "sha256-uFhU7s4rkSpEUQH5mSuCgbE/SNGVV0uTqnpPoS0AWi0=";
  });

  buildInputs = [
    lua
    libdrm
    pixman
    wayland
    libinput
    pkg-config
    wlroots_0_18
    libxkbcommon
    wayland-scanner
    wayland-protocols
  ];

  buildPhase = ''
    make
  '';

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/share/wayland-sessions
    install -Dm755 hellwm -t $out/bin
    install -Dm755 hellcli -t $out/bin
    cat > $out/share/wayland-sessions/hellwm.desktop << EOF
    [Desktop Entry]
    Name=HellWM
    Comment=HellWM Wayland Compositor
    Exec=$out/bin/hellwm
    Type=Application
    EOF
  '';

  passthru = {
    providedSessions = [ "hellwm" ];
  };

  meta = {
    description = "HellWM";
    homepage = "https://github.com/HellSoftware/HellWM";
    maintainers = [ "danihek" ];
  };
}
