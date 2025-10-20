{ self, lib, ... }:
{
  flake.modules = self.lib.mkAny "users-yuri" (
    { class, config, ... }:
    {
      imports = [
        {
          config = lib.mkIf (self.lib.hasAny config "nix") {
            nix.settings.trusted-users = [ "yuri" ];
          };
        }

        (lib.optionalAttrs (class == "nixos") {
          users.users.yuri = {
            isNormalUser = true;

            extraGroups = [
              "wheel" # for sudo
            ]
            ++ (lib.optionals (self.lib.hasAny config "docker") [ "docker" ]);

            openssh.authorizedKeys.keys = [
              "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIiYBPE2ab4jLbcLm/q0kWGfCMoxPxRMR7xi5AwUChLO bbh@awsl.rip",
              "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINSyGKSSRCE/LCVsdXLfxP+NGliAzCx4iQRJBKx6SGnT bbh@awsl.rip"
            ];
          };
        })

        (lib.optionalAttrs (class == "darwin") {

        })
      ];
    }
  );
}
