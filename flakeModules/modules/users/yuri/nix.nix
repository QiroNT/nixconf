{ self, lib, ... }:
{
  flake.modules = self.lib.mkAny "users-yuri-nix" (
    { config, ... }:
    {
      config = lib.mkIf (self.lib.hasAny config "nix") {
        nix.settings.trusted-users = [ "yuri" ];
      };
    }
  );
}
