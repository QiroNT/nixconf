{ self, ... }:
{
  flake.modules = self.lib.mkAnyNixos "users-nova" (
    { class, ... }:
    {
      imports = with self.lib.prefixWith "users-nova" (self.lib.withAny class); [
        nix
      ];

      users.users.nova = {
        isNormalUser = true;

        extraGroups = [ ];

        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDuaxd2qdNFNIQpss5qbsy1qYaUXVURegql9u+7EMYsy root@us01"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICz8fLDHIDhM5rbjNfUMzeHpKQjGcruV7MzKwL4/08p6 meow@home-code-nixos"
        ];
      };
    }
  );
}
