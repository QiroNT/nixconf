{ self, lib, ... }:
{
  flake.modules = self.lib.mkAnyNixos "users-qiront-docker" (
    { config, ... }:
    {
      config = lib.mkIf (self.lib.hasAny config "docker") {
        users.users.qiront.extraGroups = [ "docker" ];
      };
    }
  );
}
