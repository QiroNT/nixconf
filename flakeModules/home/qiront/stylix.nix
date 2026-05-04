{ ... }:
{
  flake.modules.homeManager.qiront-stylix =
    { ... }:
    {
      stylix = {
        targets = {
          vscode.enable = false;
          dank-material-shell.enable = false;
        };
      };
    };
}
