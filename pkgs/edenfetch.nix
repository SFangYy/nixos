{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:
rustPlatform.buildRustPackage {
  pname = "edenfetch";
  version = "0.1.0";
  src = fetchFromGitHub {
    owner = "EdenQwQ";
    repo = "edenfetch";
    rev = "ae6cc1207990e35288ed4a58caa21564bf1df9c3";
    hash = "sha256-ipdz6tIB7BF43lwk+KN+9orW0FLt7HJsCZuN2wbe6Is=";
  };
  useFetchCargoVendor = true;
  cargoHash = "sha256-t+tHvhTMwQwmozit6vcqE9iRZElaG4wJdzg79gcBJNY=";
  meta = {
    description = "edenfetch is a minimal fetch program written in Rust.";
    homepage = "https://github.com/EdenQwQ/edenfetch";
    mainProgram = "edenfetch";
    maintainers = with lib.maintainers; [ EdenQwQ ];
  };
}
