{ self, lib, ... }:
{
  flake.modules = self.lib.mkAny "docker" (
    { class, ... }:
    lib.optionalAttrs (class == "nixos") {
      virtualisation.docker = {
        enable = true;
        storageDriver = "btrfs";
      };
    }
  );
}
