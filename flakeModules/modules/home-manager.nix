{ lib, self, ... }:
{
  flake.modules = self.lib.mkAny "home-manager" (
    {
      self,
      self',
      inputs,
      inputs',
      class,
      ...
    }:
    {
      imports =
        [ ]
        ++ (lib.optionals (class == "nixos") [
          inputs.home-manager.nixosModules.home-manager
        ])
        ++ (lib.optionals (class == "darwin") [
          inputs.home-manager.darwinModules.home-manager
        ]);

      home-manager = {
        useUserPackages = true;
        useGlobalPkgs = true;

        extraSpecialArgs = {
          inherit
            self
            self'
            inputs
            inputs'
            class
            ;
        };
      };
    }
  );
}
