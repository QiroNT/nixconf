{ inputs, ... }:
{
  flake.modules.generic.nixpkgs =
    { inputs', ... }:
    {
      nixpkgs = {
        config = {
          allowUnfree = true;
          permittedInsecurePackages = [ "ventoy-1.1.05" ];
        };
        overlays = [
          (final: prev: {
            wezterm = inputs'.wezterm.packages.default;
          })
          inputs.self.overlays.default
        ];
      };
    };
}
