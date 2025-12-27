{ self, ... }:
{
  flake.modules = self.lib.mkAnyNixos "docker" (
    { ... }:
    {
      virtualisation.docker = {
        enable = true;
        storageDriver = "btrfs";
      };
    }
  );
}
