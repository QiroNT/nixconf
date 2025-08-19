{ ... }:
{
  flake.modules.generic.home-manager =
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
    };
}
