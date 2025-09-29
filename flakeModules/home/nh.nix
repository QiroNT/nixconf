{ ... }:
{
  flake.modules.homeManager.nh =
    { ... }:
    {
      programs.nh = {
        enable = true;
        osFlake = "/home/qiront/.config/nix-config";
        darwinFlake = "/Users/qiront/.config/nix-darwin";
      };
    };
}
