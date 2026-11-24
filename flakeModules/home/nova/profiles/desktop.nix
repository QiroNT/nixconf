{
  self,
  lib,
  config,
  ...
}:
{
  flake.modules.homeManager.nova-profile-desktop =
    { class, pkgs, ... }:
    {
      imports = [
        {
          imports = with self.lib.prefixWith "nova" config.flake.modules.homeManager; [
            gtk
          ];
        }

        (lib.optionalAttrs (class == "nixos") {
          home.packages = with pkgs; [
          ];

          programs = {
            # the linux browser (TM)
            firefox = {
              enable = true;
              package = pkgs.firefox-devedition;
            };

            # i'd rather like to configure in vscode and use config sync,
            # since changes are mostly gui based
            vscode.enable = true;
          };
        })

        (lib.optionalAttrs (class == "darwin") {

        })
      ];
    };
}
