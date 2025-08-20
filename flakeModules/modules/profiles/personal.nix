{ self, lib, ... }:
{
  flake.modules = self.lib.mkAny "profilePersonal" (
    { class, pkgs, ... }:
    {
      imports = [
        {
          imports = with (self.lib.withAny class); [
            profileBase

            docker
          ];
        }

        (lib.optionalAttrs (class == "nixos") {
          # SUID wrapper, not sure if i need this, but just to not bother my future self
          programs.mtr.enable = true;
          programs.gnupg.agent = {
            enable = true;
            enableSSHSupport = true;
          };

          # compatibility
          programs.nix-ld = {
            enable = true;
            # Add any missing dynamic libraries for unpackaged programs
            # here, NOT in environment.systemPackages
            libraries = with pkgs; [ ];
          };

          # private npm registry
          sops.secrets."personal/npm/npmrc" = {
            sopsFile = ../../../secrets/personal.yaml;
            path = "/home/qiront/.npmrc";
            owner = "qiront";
          };
          sops.secrets."personal/npm/yarnrc" = {
            sopsFile = ../../../secrets/personal.yaml;
            path = "/home/qiront/.yarnrc.yml";
            owner = "qiront";
          };
        })

        (lib.optionalAttrs (class == "darwin") {

        })
      ];
    }
  );
}
