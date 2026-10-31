{ lib, ... }:
{
  flake.modules.homeManager.qiront-stylix =
    { class, pkgs, ... }:
    {
      imports = [
        {
          stylix = {
            targets = {
              vscode.enable = false;
              dank-material-shell.enable = false;
            };
          };
        }

        (lib.optionalAttrs (class == "nixos") {
          home.packages = with pkgs; [ kdePackages.breeze-icons ];

          stylix = {
            targets = {
              qt.icons.override = {
                package = pkgs.kdePackages.breeze-icons;
                light = "breeze";
                dark = "breeze-dark";
              };
            };
          };
        })

        (lib.optionalAttrs (class == "darwin") {

        })
      ];
    };
}
