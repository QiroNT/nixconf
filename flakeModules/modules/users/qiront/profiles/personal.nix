{ self, lib, ... }:
{
  flake.modules = self.lib.mkAny "users-qiront-profile-personal" (
    { class, config, ... }:
    {
      imports = [
        {
          config = lib.mkIf (self.lib.hasAny config "profile-personal") {

          };
        }

        (lib.optionalAttrs (class == "nixos") {
          config = lib.mkIf (self.lib.hasAny config "profile-personal") {
            # private npm registry
            sops.secrets."personal/npm/npmrc" = {
              sopsFile = "${self}/secrets/personal.yaml";
              path = "/home/qiront/.npmrc";
              owner = "qiront";
            };
            sops.secrets."personal/npm/yarnrc" = {
              sopsFile = "${self}/secrets/personal.yaml";
              path = "/home/qiront/.yarnrc.yml";
              owner = "qiront";
            };
          };
        })

        (lib.optionalAttrs (class == "darwin") {
          config = lib.mkIf (self.lib.hasAny config "profile-personal") {

          };
        })
      ];
    }
  );
}
