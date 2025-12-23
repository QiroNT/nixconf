{ inputs, self, ... }:
{
  flake.modules = self.lib.mkAny "nixpkgs" (
    { ... }:
    {
      nixpkgs = {
        config = {
          allowUnfree = true;
          permittedInsecurePackages = [ "ventoy-1.1.07" ];
        };
        overlays = [
          inputs.self.overlays.default
          inputs.nur.overlays.default
        ];
      };
    }
  );
}
