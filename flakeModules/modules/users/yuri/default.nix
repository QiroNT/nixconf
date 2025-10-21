{ self, lib, ... }:
{
  flake.modules = self.lib.mkAny "users-yuri" (
    { class, ... }:
    {
      imports = [
        {
          imports = with self.lib.prefixWith "users-yuri" (self.lib.withAny class); [
            nix
            docker
          ];
        }

        (lib.optionalAttrs (class == "nixos") {
          users.users.yuri = {
            isNormalUser = true;

            extraGroups = [
              "wheel" # for sudo
            ];

            openssh.authorizedKeys.keys = [
              "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIiYBPE2ab4jLbcLm/q0kWGfCMoxPxRMR7xi5AwUChLO bbh@awsl.rip"
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
