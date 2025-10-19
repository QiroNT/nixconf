{ ... }:
{
  flake.lib.mkAny =
    name: module:
    let
      imports = [
        { chinos.any.activeModules = [ name ]; }
        module
      ];
    in
    {
      nixos = {
        ${name} = { inherit imports; };
      };
      darwin = {
        ${name} = { inherit imports; };
      };
    };
}
