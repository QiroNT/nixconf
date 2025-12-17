{ lib, config, ... }:
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

  flake.lib.withAny = class: config.flake.modules.${class};

  flake.lib.hasAny = config: name: builtins.elem name config.chinos.any.activeModules;

  # { p-a = 1; p-b = 2} ==> { a = 1; b = 2 }
  flake.lib.prefixWith =
    prefix: attrs:
    attrs
    |> lib.filterAttrs (name: _: lib.hasPrefix (prefix + "-") name)
    |> lib.mapAttrs' (name: value: lib.nameValuePair (lib.removePrefix (prefix + "-") name) value);
}
