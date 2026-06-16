{ ... }:
{
  flake.modules.homeManager.qiront-tldr =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [ tlrc ];
      services.tldr-update = {
        enable = true;
        package = pkgs.tlrc;
      };
    };
}
