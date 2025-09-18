{ lib, self, ... }:
{
  flake.modules = self.lib.mkAny "sops" (
    { inputs, class, ... }:
    {
      imports =
        [ ]
        ++ (lib.optionals (class == "nixos") [
          inputs.sops-nix.nixosModules.sops
        ])
        ++ (lib.optionals (class == "darwin") [
          inputs.sops-nix.darwinModules.sops
        ]);

      sops = {
        defaultSopsFile = ../../secrets/common.yaml;
        age.keyFile = "/var/lib/sops-nix/keys.txt";
      };
    }
  );
}
