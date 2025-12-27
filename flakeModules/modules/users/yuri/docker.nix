{ self, lib, ... }:
{
  flake.modules = self.lib.mkAnyNixos "users-yuri-docker" (
    { config, ... }:
    {
      config = lib.mkIf (self.lib.hasAny config "docker") {
        users.users.yuri.extraGroups = [ "docker" ];
      };
    }
  );
}
