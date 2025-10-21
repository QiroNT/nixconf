{ self, config, ... }:
{
  flake.modules.homeManager.yuri-profile-personal =
    { ... }:
    {
      imports = with self.lib.prefixWith "yuri" config.flake.modules.homeManager; [
        devtools
      ];
    };
}
