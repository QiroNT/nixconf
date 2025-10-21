{ self, lib, ... }:
{
  flake.modules = self.lib.mkAny "users-yuri-docker" (
    { class, config, ... }:
    lib.optionalAttrs (class == "nixos") {
      config = lib.mkIf (self.lib.hasAny config "docker") {
        users.users.yuri.extraGroups = [ "docker" ];
      };
    }
  );
}
