{ lib, ... }:
{
  flake.modules.homeManager.qiront-ghostty =
    { class, ... }:
    lib.optionalAttrs (class == "nixos") {
      programs.ghostty = {
        enable = true;
        settings = {
          # font-family = "MonaspiceNe Nerd Font"; # handled by stylix
          font-style = "Light";
          font-feature = "calt, ss01, ss02, ss03, ss04, ss05, ss06, ss07, ss08, ss09, liga";
          shell-integration = "zsh";
          shell-integration-features = "sudo, title, ssh-env";
        };
      };
    };
}
