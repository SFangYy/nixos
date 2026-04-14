{ lib, stdenv, fetchFromGitHub, kernel }:

let
  modDestDir = "$out/lib/modules/${kernel.modDirVersion}/kernel/drivers/net/wireless/aic8800";
  fwDestDir = "$out/lib/firmware";
in
stdenv.mkDerivation rec {
  pname = "aic8800";
  version = "6.4.3.0-patched.1";

  src = fetchFromGitHub {
    owner = "Kiborgik";
    repo = "aic8800dc-linux-patched";
    rev = "94dcea25238b8ae91722c557ae6388a803b02f4e";
    sha256 = "1kgdijjqsbx1hfww1v5mzv8x1xckl95r5xjj4fvdkyzd95plncrd";
  };

  patches = [
    ./fix-kernel-7.0.patch
    ./add-tenda-usb-id.patch
  ];

  nativeBuildInputs = kernel.moduleBuildDependencies;

  makeFlags = [
    "-C ${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "M=$(PWD)/drivers/aic8800"
    "ARCH=x86_64"
    "CONFIG_PLATFORM_UBUNTU=y"
    "CONFIG_PLATFORM_ROCKCHIP=n"
    "CONFIG_PLATFORM_ALLWINNER=n"
    "CONFIG_PLATFORM_AMLOGIC=n"
    "CONFIG_PLATFORM_HI=n"
  ];

  buildFlags = [ "modules" ];

  installPhase = ''
    runHook preInstall

    # Install kernel modules
    mkdir -p ${modDestDir}
    install -p -m 644 drivers/aic8800/aic_load_fw/aic_load_fw.ko ${modDestDir}/
    install -p -m 644 drivers/aic8800/aic8800_fdrv/aic8800_fdrv.ko ${modDestDir}/

    # Install firmware files
    mkdir -p ${fwDestDir}
    cp -r fw/aic8800DC ${fwDestDir}/

    runHook postInstall
  '';

  meta = with lib; {
    description = "AIC8800DC USB Wi-Fi driver (patched for modern kernels)";
    homepage = "https://github.com/Kiborgik/aic8800dc-linux-patched";
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
