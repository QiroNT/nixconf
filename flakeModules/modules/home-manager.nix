{ self, ... }:
{
  flake.modules = self.lib.mkAnyMatch "home-manager" (
    {
      self,
      self',
      inputs,
      inputs',
      class,
      ...
    }:
    {
      nixos.imports = [ inputs.home-manager.nixosModules.home-manager ];
      darwin.imports = [ inputs.home-manager.darwinModules.home-manager ];

      any.home-manager = {
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
