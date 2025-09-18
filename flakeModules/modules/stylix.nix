{ lib, self, ... }:
{
  flake.modules = self.lib.mkAny "stylix" (
    {
      inputs,
      class,
      pkgs,
      ...
    }:
    {
      imports = [
        {
          stylix = {
            enable = true;
            base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
          };
        }

        (lib.optionalAttrs (class == "nixos") {
          imports = [ inputs.stylix.nixosModules.stylix ];

          stylix = {
            cursor = {
              package = pkgs.bibata-cursors;
              name = "Bibata-Modern-Classic";
              size = 20;
            };

            fonts = {
              serif = {
                package = pkgs.noto-fonts;
                name = "Noto Serif";
              };
              sansSerif = {
                package = pkgs.geist-font;
                name = "Geist";
              };
              monospace = {
                package = pkgs.nerd-fonts.monaspace;
                name = "MonaspiceNe Nerd Font";
              };
              emoji = {
                package = pkgs.noto-fonts-emoji;
                name = "Noto Color Emoji";
              };
              sizes = {
                applications = 10;
              };
            };
          };
        })

        (lib.optionalAttrs (class == "darwin") {
          imports = [ inputs.stylix.darwinModules.stylix ];
        })
      ];
    }
  );
}
