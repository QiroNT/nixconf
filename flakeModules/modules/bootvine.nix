{ inputs, self, ... }:
{
  flake.modules = self.lib.mkAnyNixos "bootvine" (
    { ... }:
    {
      imports = [ inputs.bootvine.nixosModules.default ];

      # tui boot log
      services.bootvine.enable = true;
    }
  );
}
