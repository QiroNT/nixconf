{
  lib,
  rustPlatform,
  steel,
  ...
}:
let
  manifest = lib.importTOML ./Cargo.toml;
in
rustPlatform.buildRustPackage {
  pname = manifest.package.name;
  version = manifest.workspace.package.version;

  src = ./.;

  cargoLock.lockFile = ./Cargo.lock;

  nativeBuildInputs = [
    steel
  ];

  buildPhase = ''
    export STEEL_HOME=steel
    mkdir steel
    cargo steel-lib
  '';

  doCheck = false;

  installPhase = ''
    mkdir -p $out/share
    cp -r steel $out/share
  '';
}
