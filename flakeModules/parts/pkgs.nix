{ inputs, ... }:
{
  perSystem =
    { system, ... }:
    {
      _module.args.pkgs = import inputs.nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
          permittedInsecurePackages = [ "ventoy-1.1.07" ];
        };
        overlays = [
          inputs.self.overlays.default
          inputs.nur.overlays.default
          inputs.nix-cachyos-kernel.overlays.pinned
        ];
      };
    };
}
