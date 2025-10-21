{ lib, ... }:
{
  flake.modules.homeManager.qiront-tldr =
    { class, pkgs, ... }:
    {
      imports = [
        {
          home.packages = with pkgs; [ tlrc ];
        }

        (lib.optionalAttrs (class == "nixos") {
          services.tldr-update = {
            enable = true;
            package = pkgs.tlrc;
          };
        })

        (lib.optionalAttrs (class == "darwin") {

        })
      ];
    };
}
