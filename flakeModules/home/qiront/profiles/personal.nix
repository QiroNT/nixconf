{ self, config, ... }:
{
  flake.modules.homeManager.qiront-profile-personal =
    { ... }:
    {
      imports = with self.lib.prefixWith "qiront" config.flake.modules.homeManager; [
        devtools
      ];
    };
}
