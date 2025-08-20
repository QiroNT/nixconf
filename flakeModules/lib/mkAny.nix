{ ... }:
{
  flake.lib.mkAny = name: module: {
    nixos = {
      ${name} = module;
    };
    darwin = {
      ${name} = module;
    };
  };
}
