{ ... }:
{
  flake.modules.homeManager.stylix =
    { ... }:
    {
      stylix = {
        targets.vscode.enable = false;
      };
    };
}
