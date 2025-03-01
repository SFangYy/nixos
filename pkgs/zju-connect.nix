{
  lib,
  buildGoModule,
  fetchFromGitHub,
  ...
}:
buildGoModule rec {
  pname = "zju-connect";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "Mythologyli";
    repo = "ZJU-Connect";
    rev = "v${version}";
    hash = "sha256-8QMdesmveXHmAKhuISmAE75La/KeybFqYSfAACfmIJE=";
  };

  vendorHash = "sha256-ANb3zcZCMqg6iO79q9CQEEN8DH0cwb7bAs3YmhfGTz8=";

  meta = {
    description = "ZJU RVPN client";
    homepage = "https://github.com/Mythologyli/ZJU-Connect";
    mainProgram = "zju-connect";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ EdenQwQ ];
  };
}
