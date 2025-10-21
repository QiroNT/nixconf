{ ... }:
{
  flake.modules.homeManager.yuri-stylix =
    { pkgs, ... }:
    {
      stylix = {
        base16Scheme = "${pkgs.base16-schemes}/share/themes/monokai.yaml";
        targets.vscode.enable = false;
      };
    };
}
