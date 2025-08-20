{ self, ... }:
{
  flake.modules = self.lib.mkAny "sops" (
    { ... }:
    {
      sops = {
        defaultSopsFile = ../../secrets/common.yaml;
        age.keyFile = "/var/lib/sops-nix/keys.txt";
      };
    }
  );
}
