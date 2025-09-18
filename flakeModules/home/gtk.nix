{ lib, ... }:
{
  flake.modules.homeManager.gtk =
    { class, pkgs, ... }:
    lib.optionalAttrs (class == "nixos") {
      gtk = {
        enable = true;
        iconTheme = {
          package = pkgs.papirus-icon-theme;
          name = "Papirus";
        };
      };
    };
}
