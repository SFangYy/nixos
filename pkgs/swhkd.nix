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
    rev = "c5c4071459a6465a3743a8bb5bb990e27cdf315b";
    hash = "sha256-Tv9+UBDBuRD3equ2XNmyt3Fm1+9DxkRzqV4M7PWnBLA=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-LBbmFyddyw7vV5voctXq3L4U3Ddbh428j5XbI+td/dg=";

  NO_RFKILL_SW_SUPPORT = 1;

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
  };
}
