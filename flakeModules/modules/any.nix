{ self, lib, ... }:
{
  flake.modules = self.lib.mkAny "any" (
    { ... }:
    {
      options.chinos.any = {
        activeModules = lib.mkOption {
          description = "List of currently activated any modules.";
          type = lib.types.listOf lib.types.str;
          default = [ ];
        };
      };
    }
  );
}
