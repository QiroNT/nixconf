{
  inputs = {
    nixpkgs-rust.url = "github:nixos/nixpkgs?ref=83aaf6183611b2816a35d3d437eb99177d43378f";
    nixpkgs-zed.url = "github:nixos/nixpkgs?ref=f62f4aa5819324640d60158f38c8ed333b4de18f";
    utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    nixpkgs-rust,
    nixpkgs-zed,
    utils,
  }:
    utils.lib.eachDefaultSystem (
      system: let
        pkgs = nixpkgs-rust.legacyPackages.${system};
        zed-editor = pkgs.callPackage "${nixpkgs-zed}/pkgs/by-name/ze/zed-editor/package.nix" {};

        zed-fhs = pkgs.buildFHSUserEnv {
          name = "zed";
          targetPkgs = _pkgs: [
            zed-editor
          ];
          runScript = "zed";
        };
      in {
        devShell = pkgs.mkShell {
          buildInputs = [
            zed-fhs
          ];
        };
      }
    );
}
