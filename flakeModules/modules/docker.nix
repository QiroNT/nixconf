{ self, lib, ... }:
{
  flake.modules = self.lib.mkAny "docker" (
    { class, ... }:
    lib.optionalAttrs (class == "nixos") {
      users.users.qiront.extraGroups = [ "docker" ];
      virtualisation.docker = {
        enable = true;
        storageDriver = "btrfs";
      };
    }
  );
}
