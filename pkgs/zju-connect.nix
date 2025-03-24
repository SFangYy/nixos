{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "zju-connect";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "Mythologyli";
    repo = "zju-connect";
    rev = "v${version}";
    hash = "sha256-LrupxRFobVzzOiQCznnaIH17sTsnzjiMVnWDMyN0dwY=";
  };

  vendorHash = "sha256-G+glwXw3zDA4XYWUnrkyG55PicHDutXRe7ZzdJGirZA=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "ZJU RVPN 客户端的 Go 语言实现";
    homepage = "https://github.com/Mythologyli/zju-connect";
    license = lib.licenses.agpl3Only;
    mainProgram = "zju-connect";
  };
}
