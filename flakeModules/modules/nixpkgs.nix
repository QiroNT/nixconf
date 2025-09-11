{ inputs, self, ... }:
{
  flake.modules = self.lib.mkAny "nixpkgs" (
    { inputs', ... }:
    {
      nixpkgs = {
        config = {
          allowUnfree = true;
          permittedInsecurePackages = [ "ventoy-1.1.07" ];
        };
        overlays = [
          (final: prev: {
            wezterm = inputs'.wezterm.packages.default;
          })
          inputs.self.overlays.default
        ];
      };
    }
  );
}
