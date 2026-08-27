{ ... }:
{
  flake.modules.homeManager.qiront-stylix =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.kdePackages.breeze-icons ];

      stylix = {
        targets = {
          vscode.enable = false;
          dank-material-shell.enable = false;
          qt.icons.override = {
            package = pkgs.kdePackages.breeze-icons;
            light = "breeze";
            dark = "breeze-dark";
          };
        };
      };
    };
}
