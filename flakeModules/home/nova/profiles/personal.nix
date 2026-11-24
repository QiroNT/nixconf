{ self, config, ... }:
{
  flake.modules.homeManager.nova-profile-personal =
    { ... }:
    {
      imports = with self.lib.prefixWith "nova" config.flake.modules.homeManager; [
        devtools
      ];
    };
}
