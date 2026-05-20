{ self, ... }:
{
  flake.modules = self.lib.mkAnyNixos "users-yuri" (
    { class, ... }:
    {
      imports = with self.lib.prefixWith "users-yuri" (self.lib.withAny class); [
        nix
        docker
      ];

      users.users.yuri = {
        isNormalUser = true;

        extraGroups = [
          "wheel" # for sudo
        ];

        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIiYBPE2ab4jLbcLm/q0kWGfCMoxPxRMR7xi5AwUChLO bbh@awsl.rip"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINSyGKSSRCE/LCVsdXLfxP+NGliAzCx4iQRJBKx6SGnT bbh@awsl.rip"
          "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIPm8fm2GbPerlhMI4jwfjyg3HGIyql/n2XaMNHwHn8nTAAAABHNzaDo= Sayuri Nekomiya's YubiKey 5"
        ];
      };
    }
  );
}
