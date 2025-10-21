{ self, lib, ... }:
{
  flake.modules = self.lib.mkAny "users-qiront-nix" (
    { config, ... }:
    {
      config = lib.mkIf (self.lib.hasAny config "nix") {
        nix.settings.trusted-users = [ "qiront" ];
      };
    }
  );
}
