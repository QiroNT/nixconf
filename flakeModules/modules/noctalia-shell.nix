{ self, ... }:
{
  flake.modules = self.lib.mkAnyNixos "noctalia-shell" (
    { inputs, ... }:
    {
      imports = [ inputs.noctalia.nixosModules.default ];
      services.noctalia-shell.enable = true;
    }
  );
}
