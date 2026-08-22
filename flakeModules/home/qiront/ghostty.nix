{ lib, ... }:
{
  flake.modules.homeManager.qiront-ghostty =
    { class, ... }:
    {
      imports = [
        {
          programs.ghostty = {
            enable = true;
            settings = {
              # font-family = "Monaspace Neon NF"; # handled by stylix
              font-style = "Light";
              font-feature = "calt, ss01, ss02, ss03, ss04, ss05, ss06, ss07, ss08, ss09, ss10, liga";
              shell-integration = "zsh";
              shell-integration-features = "sudo, title, ssh-env";
            };
          };
        }

        (lib.optionalAttrs (class == "nixos") {
        })

        (lib.optionalAttrs (class == "darwin") {
          programs.ghostty = {
            package = null;
            settings = {
              font-size = lib.mkForce 13;
              macos-option-as-alt = "left";
              keybind = [
                "alt+left=unbind"
                "alt+right=unbind"
              ];
            };
          };
        })
      ];
    };
}
