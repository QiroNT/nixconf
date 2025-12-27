{ self, ... }:
{
  flake.modules = self.lib.mkAnyMatch "stylix" (
    { inputs, pkgs, ... }:
    {
      any = {
        stylix = {
          enable = true;
          polarity = "dark";
          base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
        };
      };

      nixos = {
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
              package = pkgs.local.monaspace;
              name = "Monaspace Neon NF";
            };
            emoji = {
              package = pkgs.noto-fonts-color-emoji;
              name = "Noto Color Emoji";
            };
            sizes = {
              applications = 10;
            };
          };
        };
      };

      darwin = {
        imports = [ inputs.stylix.darwinModules.stylix ];
      };
    }
  );
}
