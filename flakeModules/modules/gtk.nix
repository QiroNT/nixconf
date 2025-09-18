{ self, lib, ... }:
{
  flake.modules = self.lib.mkAny "gtk" (
    { class, pkgs, ... }:
    lib.optionalAttrs (class == "nixos") {
      gtk = {
        enable = true;
        iconTheme = {
          package = pkgs.papirus-icon-theme;
          name = "Papirus";
        };
      };
    }
  );
}
