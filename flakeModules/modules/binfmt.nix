{ self, ... }:
{
  flake.modules = self.lib.mkAnyNixos "binfmt" (
    { ... }:
    {
      boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
    }
  );
}
