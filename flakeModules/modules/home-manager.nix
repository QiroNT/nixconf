{ self, ... }:
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
