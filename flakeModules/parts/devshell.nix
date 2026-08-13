{ ... }:
{
  perSystem =
    { pkgs, inputs', ... }:
    let
      rustToolchain = inputs'.fenix.packages.stable.toolchain;
    in
    {
      _module.args.rustToolchain = rustToolchain;

      devShells.default = pkgs.mkShell {
        nativeBuildInputs = with pkgs; [
          rustToolchain
        ];
      };
    };
}
