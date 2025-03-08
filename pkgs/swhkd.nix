{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  udev,
}:
rustPlatform.buildRustPackage {
  pname = "swhkd";
  version = "1.3.0-unstable-2025-02-08";

  src = fetchFromGitHub {
    owner = "waycrate";
    repo = "swhkd";
    rev = "d7182b6854ea1873c388f38714b923570cb71f86";
    hash = "sha256-+cxF/aWy2OLs1s+vQIXXsTx4hVAfJGenEdxOSgsmcqk=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-LBbmFyddyw7vV5voctXq3L4U3Ddbh428j5XbI+td/dg=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    udev
  ];

  postBuild = ''
    $src/scripts/build-polkit-policy.sh --swhkd-path=$out/bin/swhkd
  '';

  postInstall = ''
    install -D -m0444 ./com.github.swhkd.pkexec.policy -t $out/share/polkit-1/actions
  '';

  meta = with lib; {
    description = "A drop-in replacement for sxhkd that works with wayland";
    homepage = "https://github.com/waycrate/swhkd";
    license = licenses.bsd2;
    maintainers = with maintainers; [ EdenQwQ ];
  };
}
