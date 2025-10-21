{ ... }:
{
  flake.modules.homeManager.qiront-nh =
    { config, ... }:
    {
      programs.nh = {
        enable = true;
        osFlake = "${config.home.homeDirectory}/.config/nix-config";
        darwinFlake = "${config.home.homeDirectory}/.config/nix-darwin";
      };
    };
}
