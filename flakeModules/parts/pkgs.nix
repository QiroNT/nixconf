{ inputs, ... }:
{
  perSystem =
    { inputs', system, ... }:
    {
      _module.args.pkgs = import inputs.nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
          permittedInsecurePackages = [ "ventoy-1.1.07" ];
        };
        overlays = [
          (final: prev: {
            wezterm = inputs'.wezterm.packages.default;
          })
          inputs.niri.overlays.niri
          inputs.self.overlays.default
        ];
      };
    };
}
