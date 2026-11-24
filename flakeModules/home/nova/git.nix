{ lib, ... }:
{
  flake.modules.homeManager.nova-git =
    { class, pkgs, ... }:
    {
      imports = [
        {
          home.packages = with pkgs; [
            lazygit
            gitu
          ];

          programs = {
            # the software people used to convince everyone else to use
            git = {
              enable = true;
              package = pkgs.git.override {
                sendEmailSupport = true;
                withSsh = true;
                withLibsecret = !pkgs.stdenvNoCC.isDarwin;
              };
              lfs.enable = true;
            };

            # the thing i use to auth the thing just above
            gh.enable = true; # ok it's github cli
          };
        }

        (lib.optionalAttrs (class == "nixos") {

        })

        (lib.optionalAttrs (class == "darwin") {

        })
      ];
    };
}
