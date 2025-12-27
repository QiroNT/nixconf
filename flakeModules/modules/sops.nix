{ self, ... }:
{
  flake.modules = self.lib.mkAnyMatch "sops" (
    { inputs, ... }:
    {
      nixos.imports = [ inputs.sops-nix.nixosModules.sops ];
      darwin.imports = [ inputs.sops-nix.darwinModules.sops ];

      any.sops = {
        defaultSopsFile = "${self}/secrets/common.yaml";
        age.keyFile = "/var/lib/sops-nix/keys.txt";
      };
    }
  );
}
