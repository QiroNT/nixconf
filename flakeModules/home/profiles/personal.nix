{ config, ... }:
{
  flake.modules.homeManager.profilePersonal =
    { ... }:
    {
      imports = with config.flake.modules.homeManager; [
        devtools
      ];
    };
}
